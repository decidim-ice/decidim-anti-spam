# frozen_string_literal: true

module Decidim
  module SpamSignal
    class SpamConfigRepo
      attr_reader :handler_name, :config
      attr_accessor :errors

      def initialize(handler_name, attributes)
        @config = with_defaults(
          attributes
        )
        @handler_name = handler_name
        @errors = []
      end

      def valid?
        # loop over all the scans, initialize the proper forms and validates them.
        scans.each do |scan|
          form_klass = scan.form
          form = form_klass.from_model(scan)
          @errors << form.errors.full_messages unless form.valid?
        end
      end

      def scans = @config.[]("scans")

      def rules = @config.[]("rules")

      def spam_cop = @config.[]("spam_cop")

      def suspicious_cop = @config.[]("suspicious_cop")

      def rule(key)
        rules[key.to_s]
      end

      def add_rule(rule)
        rules.merge!(rule)
      end

      def rm_rule(key)
        rules.reject! { |k, _v| k == key }
      end

      def cop(cop_type)
        if cop_type == "spam"
          @config["spam_cop"]
        else
          @config["suspicious_cop"]
        end
      end

      def update_cop_attribute(cop)
        attributes = validate_cop!(cop["handler_name"], cop)
        attributes["handler_name"] = cop["handler_name"]
        type = cop["type"]
        if type == "spam"
          @config["spam_cop"] = attributes
        else
          @config["suspicious_cop"] = attributes
        end
      end

      def rm_cop(cop_type)
        if cop_type == "spam"
          @config["spam_cop"] = {}
        else
          @config["suspicious_cop"] = {}
        end
      end

      def add_scan(scan, options = {})
        set_scan(scan, options)
      end

      def set_scan(scan, options = {})
        ensure_scan_name! scan
        validate_scan!(scan, options)
        scans[scan.to_s] = options
        scans
      end

      def scan_strategy(scan)
        ensure_scan_name! scan
        scan_repository.strategy(scan)
      end

      def scan_options(scan)
        ensure_scan_name! scan
        scans[scan.to_s]
      end

      def cop_options(cop, cop_type)
        ensure_cop_name! cop
        if cop_type == "spam"
          spam_cop
        else
          suspicious_cop
        end
      end

      def validate_scan!(scan, options)
        form_scan_klass = form_scan(scan)
        return {} unless form_scan_klass

        validator = form_scan_klass.new(options).with_context(handler_name: scan)
        raise Error, validator.errors unless validator.valid?

        validator.attributes
      end

      def validate_cop!(cop, options)
        form_cop_klass = form_cop(cop)
        return {} unless form_cop_klass

        validator = form_cop_klass.new(options).with_context(handler_name: cop)
        raise Error, validator.errors unless validator.valid?

        validator.attributes
      end

      def rm_scan(scan)
        scans.reject! { |k| k == scan.to_s }
      end

      private

      def form_scan(scan)
        ensure_scan_name! scan
        scanner = scan_repository.strategy(scan)
        scanner.form
      end

      def form_cop(cop)
        ensure_cop_name! cop
        cop_strategy = cops_repository.strategy(cop)
        cop_strategy.form
      end

      def ensure_scan_name!(scan)
        scan_sym = scan.to_s.to_sym
        raise Error, "#{scan} is not a valid strategy #{scanners.join(",")}" unless scanners.include? scan_sym
      end

      def ensure_cop_name!(cop)
        cop_sym = cop.to_s.to_sym
        raise Error, "#{cop} is not a valid strategy #{cops.join(",")}" unless cops.include? cop_sym
      end

      def with_defaults(conf)
        conf["scans"] ||= {}
        conf["rules"] ||= {}
        conf["spam_cop"] ||= {}
        conf["suspicious_cop"] ||= {}
        conf
      end

      def scanners
        scan_repository.strategies
      end

      def scan_repository
        Scans::ScansRepository.instance
      end

      def cops
        cops_repository.strategies
      end

      def cops_repository
        Cops::CopsRepository.instance
      end
    end
  end
end

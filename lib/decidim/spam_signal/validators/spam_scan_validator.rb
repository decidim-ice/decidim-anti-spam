# frozen_string_literal: true

module Decidim
  module SpamSignal
    module SpamScanValidator
      extend ActiveSupport::Concern
      included do
        validate :detect_spam!
        def detect_spam!
          return if skip_scan_spam?

          # Collect fired symbols
          fired_symboles = run_scanners(spam_scanners, spam_tested_content)
          return if fired_symboles.blank? # Nothing got fired, all good!

          # Check the rules
          suspicious_rules = current_rules("suspicious")
          spam_rules = current_rules("spam")

          # If it's a cop fire it, else if it's a suspicous, fire it.
          if fire_cop?(spam_rules, fired_symboles) && obvious_spam_cop
            before_cop_fire("spam")
            obvious_spam_cop.call(
              errors: errors,
              suspicious_user: author,
              reportable: spam_reportable_user,
              config: obvious_spam_cop_options,
              justification: "#{I18n.t("activerecord.models.decidim/comments/comment", count: 1)}: #{spam_tested_content}",
              error_key: spam_error_key
            )
          elsif fire_cop?(suspicious_rules, fired_symboles) && suspicious_spam_cop
            before_cop_fire("suspicious")
            suspicious_spam_cop.call(
              errors: errors,
              suspicious_user: author,
              reportable: spam_reportable_user,
              config: suspicious_spam_cop_options,
              justification: "#{I18n.t("activerecord.models.decidim/comments/comment", count: 1)}: #{spam_tested_content}",
              error_key: spam_error_key
            )
          end
        end

        def author
          scan_context[:author]
        end

        def spam_error_key
          nil
        end

        def before_spam_cop_fire; end

        def spam_reportable_user
          raise "Not implemented"
        end

        def spam_tested_content
          raise "Not implemented"
        end

        def skip_scan_spam
          raise "Not implemented"
        end

        def spam_scanners
          raise "Not implemented"
        end

        def scan_context
          raise "Not implemented"
        end

        private

        def spam_scanners
          @spam_scanners ||= resource_spam_config.scans.map do |s, options|
            options["context"] = scan_context
            [Scans::ScansRepository.instance.strategy(s), options]
          end
        end

        def obvious_spam_cop_options
          @obvious_spam_cop_options ||= resource_spam_config.spam_cop || nil
        end

        def obvious_spam_cop
          @obvious_spam_cop ||= begin
            cop_key = obvious_spam_cop_options["handler_name"]
            if cop_key
              Cops::CopsRepository.instance.strategy(
                cop_key
              )
            end
          end
        end

        def suspicious_spam_cop_options
          @suspicious_spam_cop_options ||= resource_spam_config.suspicious_cop || nil
        end

        def suspicious_spam_cop
          @suspicious_spam_cop ||= begin
            cop_key = suspicious_spam_cop_options["handler_name"]
            if cop_key
              Cops::CopsRepository.instance.strategy(
                cop_key
              )
            end
          end
        end

        def spam_config
          @spam_config ||= Config.get_config(scan_context[:current_organization])
        end

        def current_rules(handler_name = "spam")
          filtered_rules = resource_spam_config.rules.filter { |_rule_id, rule| rule["handler_name"] == handler_name }
          filtered_rules.map do |_rule_id, rule|
            rule["rules"].symbolize_keys.keys
          end
        end

        def run_scanners(scanners, tested_content)
          fired_symboles = scanners.map do |scan_command, scan_option|
            scan_command.call(
              tested_content,
              scan_option
            ).keys.filter { |s| s != :ok && s != :valid }
          end
          fired_symboles.flatten
        end

        def fire_cop?(rules, fired_events)
          rules.map do |ruleset|
            ruleset.map do |rule|
              fired_events.include? rule
            end.all?
          end.any?
        end
      end
    end
  end
end

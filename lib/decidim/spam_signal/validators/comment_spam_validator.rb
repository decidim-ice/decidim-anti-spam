# frozen_string_literal: true

module Decidim
  module SpamSignal
    module CommentSpamValidator
      extend ActiveSupport::Concern

      included do
        validate :scan_spam

        def scan_spam
          return if body.empty?

          tested_content = Extractors::CommentExtractor.extract(self, spam_config)
          # Collect fired symbols
          symboles = spam_scanners.map do |scan_command, scan_option|
            scan_command.call(
              tested_content,
              scan_option
            )
          end.map(&:keys).flatten.filter { |s| s != :ok && s != :valid }
          return if !symboles || symboles.empty?
          # Check the rules
          suspicious_rules = spam_ruleset("suspicious")
          spam_rules = spam_ruleset("spam")
          fire_suspicious_cop = suspicious_rules.map do |ruleset|
            ruleset.map do |rule|
              symboles.include? rule
            end.all?
          end.any?
          fire_spam_cop = spam_rules.map do |ruleset|
            ruleset.map do |rule|
              symboles.include? rule
            end.all?
          end.any?

          # If it's a cop fire it, else if it's a suspicous, fire it.
          if fire_spam_cop && obvious_spam_cop
            obvious_spam_cop.call(
              errors,
              author,
              obvious_spam_cop_options,
              tested_content
            )
          elsif fire_suspicious_cop && suspicious_spam_cop
            suspicious_spam_cop.call(
              errors,
              author,
              suspicious_spam_cop_options,
              tested_content
            )
          end
        end

        def obvious_spam_cop_options
          cop = spam_config.comments.spam_cop
          return nil unless cop
          cop
        end

        def obvious_spam_cop
          cop_key = obvious_spam_cop_options["handler_name"]
          return nil unless cop_key
          Cops::CopsRepository.instance.strategy(
            cop_key
          )
        end

        def suspicious_spam_cop_options
          cop = spam_config.comments.suspicious_cop
          return nil unless cop
          cop
        end
        def suspicious_spam_cop
          cop_key = suspicious_spam_cop_options["handler_name"]
          return nil unless cop_key
          Cops::CopsRepository.instance.strategy(
            cop_key
          )
        end

        def spam_config
          @config ||= Config.get_config(context.current_organization)
        end

        def author
          context.author || nil
        end

        def spam_scanners
          spam_config.comments.scans.map do |s, options|
            [Scans::ScansRepository.instance.strategy(s), options]
          end
        end

        def spam_ruleset(handler_name = "spam")
          spam_config.comments.rules.map do |rule_id, rule|
            rule
          end.filter { |r| r["handler_name"] == handler_name }.map do |r|
            r["rules"].symbolize_keys.keys
          end
        end
      end
    end
  end
end

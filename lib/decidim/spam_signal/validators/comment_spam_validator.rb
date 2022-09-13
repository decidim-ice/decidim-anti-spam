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
          spam_scan.call(
            tested_content,
            spam_config
          ) do
            on(:spam) do
              obvious_spam_cop.call(
                errors,
                author,
                spam_config,
                tested_content
              )
            end
            on(:suspicious) do
              suspicious_spam_cop.call(
                errors,
                author,
                spam_config,
                tested_content
              )
            end
          end
        end

        def spam_scan
          Scans::ScansRepository.instance.strategy(
            spam_config.comment_scan
          )
        end

        def obvious_spam_cop
          Cops::CopsRepository.instance.strategy(
            spam_config.comment_obvious_cop
          )
        end

        def suspicious_spam_cop
          Cops::CopsRepository.instance.strategy(
            spam_config.comment_suspicious_cop
          )
        end

        def spam_config
          @config ||= Config.get_config(organization)
        end
      end
    end
  end
end

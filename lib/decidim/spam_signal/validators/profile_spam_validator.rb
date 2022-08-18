# frozen_string_literal: true

module Decidim
  module SpamSignal
    module ProfileSpamValidator
      extend ActiveSupport::Concern

      included do 
        validate :scan_spam, on: :update, if: :about_changed?
        def scan_spam
          return if about.empty?
          tested_content = Extractors::ProfileExtractor.extract(self, spam_config)
          spam_scan.call(
            tested_content,
            spam_config
          ) do
            on(:spam) do
              obvious_spam_cop.call(
                self,
                spam_config,
                tested_content
              )
              errors.add(
                :about,
                I18n.t("errors.spam",
                  scope: "decidim.spam_signal",
                  default: "This looks like spam."
                )
              )
            end
            on(:suspicious) do
              suspicious_spam_cop.call(
                self,
                spam_config,
                tested_content
              )
            end
          end
        end

        def spam_scan
          ::Decidim::SpamSignal::Scans::ScansRepository.instance.strategy(
            spam_config.profile_scan
          )
        end

        def obvious_spam_cop
          ::Decidim::SpamSignal::Cops::CopsRepository.instance.strategy(
            spam_config.profile_obvious_cop
          )
        end

        def suspicious_spam_cop
          ::Decidim::SpamSignal::Cops::CopsRepository.instance.strategy(
            spam_config.profile_suspicious_cop
          )
        end

        def spam_config
          @config ||= Config.get_config(organization)
        end
      end
    end
  end
end

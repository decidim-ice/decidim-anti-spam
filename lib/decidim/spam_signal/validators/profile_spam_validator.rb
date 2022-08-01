# frozen_string_literal: true

module Decidim
  module SpamSignal
    module ProfileSpamValidator
      extend ActiveSupport::Concern

      included do
        validate :spam_signal_scan_about, on: :update, if: :about_changed?
        def spam_signal_scan_about
          return if about.empty?
          spam_scan.call(
            about,
            spam_scan_config
          ) do
            on(:spam) do
              obvious_spam_cop.call(
                self,
                obvious_spam_cop_config,
                about
              )
            end
            on(:suspicious) do
              suspicious_spam_cop.call(
                self,
                suspicious_spam_cop_config,
                about
              )
            end
          end
        end

        def spam_scan
          SpamScannerStrategiesService.instance.strategy(
            spam_config.profile_scan
          )
        end

        def spam_scan_config
          spam_config.scan_settings[spam_config.profile_scan.to_sym] || {}
        end

        def obvious_spam_cop
          SpamCopStrategiesService.instance.strategy(
            spam_config.profile_obvious_cop
          )
        end
        def obvious_spam_cop_config
          spam_config.cops_settings[spam_config.profile_obvious_cop.to_sym] || {}
        end

        def suspicious_spam_cop
          SpamCopStrategiesService.instance.strategy(
            spam_config.profile_suspicious_cop
          )
        end

        def suspicious_spam_cop_config
          spam_config.cops_settings[spam_config.profile_suspicious_cop.to_sym] || {}
        end

        def spam_config
          @config ||= Config.get_config(organization)
        end
      end
    end
  end
end

# frozen_string_literal: true

module Decidim
  module SpamSignal
    module ProfileSpamValidator
      extend ActiveSupport::Concern

      included do
        validate :spam_signal_scan_about, on: :update, if: :about_changed?
        def spam_signal_scan_about
          return if about.empty?
          spam_detector.call(
            self,
            config,
            about
          ) do 
            on(:spam) do 
              obvious_spam_cop.call(
                self,
                config,
                about
              )
            end
            on(:suspicious) do
              suspicious_spam_cop.call(
                self,
                config,
                about
              )
            end
          end
        end

        def spam_detector
          SpamScannerStrategiesService.instance.strategy(
            config.profile_scan
          )
        end

        def obvious_spam_cop
          SpamCopStrategiesService.instance.strategy(
            config.profile_obvious_cop
          )
        end

        def suspicious_spam_cop
          SpamCopStrategiesService.instance.strategy(
            config.profile_suspicious_cop
          )
        end

        def config
          Config.get_config(organization)
        end
      end
    end
  end
end

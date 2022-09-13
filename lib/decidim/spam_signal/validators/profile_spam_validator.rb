# frozen_string_literal: true

module Decidim
  module SpamSignal
    module ProfileSpamValidator
      extend ActiveSupport::Concern

      included do
        validate :scan_spam
        def scan_spam
          return if !about || about.empty?
          current_user = self
          tested_content = Extractors::ProfileExtractor.extract(self, spam_config)
          spam_scan.call(
            tested_content,
            spam_config
          ) do
            on(:spam) do
              restore_values(current_user)
              obvious_spam_cop.call(
                errors,
                current_user,
                spam_config,
                tested_content
              )
            end
            on(:suspicious) do
              restore_values(current_user)
              suspicious_spam_cop.call(
                errors,
                current_user,
                spam_config,
                tested_content
              )
            end
          end
        end

        # Case the lock cop is there, 
        # it will save the user without validation,
        # we should then update the attributes to before
        # state
        def restore_values(user)
          if user.about_previously_changed?
            user.about = user.about_previously_was
          else
            user.about = nil
          end
          
          if user.personal_url_previously_changed?
            user.personal_url = user.personal_url_previously_was
          else
            user.personal_url = nil
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

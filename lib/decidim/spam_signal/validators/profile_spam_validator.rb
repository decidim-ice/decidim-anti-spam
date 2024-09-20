# frozen_string_literal: true

module Decidim
  module SpamSignal
    module ProfileSpamValidator
      extend ActiveSupport::Concern

      included do
        include ::Decidim::SpamSignal::SpamScanValidator
        validate :detect_spam!

        def spam_tested_content
          @spam_tested_content ||= Extractors::ProfileExtractor.extract(self, spam_config)
        end

        def spam_error_key
          :about
        end

        def spam_reportable_user
          self
        end

        def skip_scan_spam?
          about.blank? || blocked_at_changed?(from: nil) || blocked_changed?(from: false)
        end

        def resource_spam_config
          @resource_spam_config ||= spam_config.profiles
        end

        def scan_context
          {
            validator: "profile",
            is_updating: true,
            date: updated_at,
            current_organization: organization,
            author: self
          }
        end

        def current_user
          self
        end

        def before_cop_fire(_cop_type)
          restore_values(self)
        end

        # Case the lock cop is there,
        # it will save the user without validation,
        # we should then update the attributes to before
        # state
        def restore_values(user)
          user.about = user.about_was
          user.personal_url = user.personal_url_was
        end
      end
    end
  end
end

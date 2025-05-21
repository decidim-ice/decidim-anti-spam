# frozen_string_literal: true

module Decidim
  module SpamSignal
    module Flows
      module MeetingFlow
        include ActiveSupport::Configurable
        config_accessor(:available_conditions) do
          [
            :forbidden_tlds,
            :allowed_tlds,
            :word,
            :official_account
          ]
        end

        config_accessor(:available_actions) do
          [
            :report,
            :forbid_save
          ]
        end

        module MeetingValidationFormOverrides
          extend ActiveSupport::Concern

          included do
            include ::Decidim::SpamSignal::Flows::FlowValidator
            validate :detect_spam!

            def current_organization
              @current_organization ||= context.current_organization
            end

            def antispam_trigger_type
              "Decidim::SpamSignal::Flows::MeetingFlow"
            end

            def content_for_antispam
              @content_for_antispam ||= Extractors::MeetingExtractor.extract(self)
            end

            def spam_error_keys
              [:description, :address, :location_hints, :registration_terms, :title, :registration_url, :location]
            end

            ##
            # @deprecated
            def reportable_content
              nil
            end

            def suspicious_user
              context.current_user
            end

            ##
            # A condition has been met, we restore values
            # before doing actions. As blocking/locking will
            # save the user without validation in the process.
            def after_antispam; end

            ##
            # Skip the flow if no content to test,
            # or if the user is updated to be blocked.
            def skip_antispam?
              # blocked_status_changed?
              false
            end
          end
        end
      end
    end
  end
end

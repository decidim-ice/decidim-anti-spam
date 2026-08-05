# frozen_string_literal: true

module Decidim
  module SpamSignal
    class AuthenticationValidationForm < Decidim::Form
      include ::Decidim::SpamSignal::Flows::FlowValidator

      validate :detect_spam!

      def current_organization
        @current_organization ||= context.current_organization
      end

      def antispam_trigger_type
        "Decidim::SpamSignal::Flows::AuthenticationFlow"
      end

      def content_for_antispam
        # no content for antispam, as check only globals.
        nil
      end

      def spam_error_keys
        []
      end

      def reportable_content
        nil
      end

      def suspicious_user
        nil
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

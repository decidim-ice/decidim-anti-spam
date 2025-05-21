# frozen_string_literal: true

module Decidim
  module SpamSignal
    module Flows
      # Aditional validator that get inserted in CommentForm
      # .context is the form context (user, organization, etc)
      # attributes like body are form attributes
      module CommentFlow
        include ActiveSupport::Configurable
        ##
        # Available conditions for the comment flow.
        config_accessor(:available_conditions) do
          [
            :forbidden_tlds,
            :allowed_tlds,
            :word
          ]
        end

        ##
        # Available actions for the comment flow.
        config_accessor(:available_actions) do
          [
            :report,
            :forbid_save
          ]
        end

        module CommentValidationFormOverrides
          extend ActiveSupport::Concern

          included do
            include ::Decidim::SpamSignal::Flows::FlowValidator

            validate :detect_spam!

            def antispam_trigger_type
              "Decidim::SpamSignal::Flows::CommentFlow"
            end

            delegate :current_organization, to: :context

            def suspicious_user
              context.current_user
            end

            def spam_error_keys
              [:body]
            end

            def reportable_content
              commentable
            end

            def content_for_antispam
              @content_for_antispam ||= Extractors::CommentExtractor.extract(self)
            end

            def skip_antispam?
              body.empty?
            end
          end
        end
      end
    end
  end
end

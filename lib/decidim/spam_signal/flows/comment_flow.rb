# frozen_string_literal: true

module Decidim
  module SpamSignal
    module Flows
      # Aditional validator that get inserted in CommentForm
      # .context is the form context (user, organization, etc)
      # attributes like body are form attributes
      module CommentFlow
        class << self
          def config = self

          def configure
            yield self
          end
        end

        ##
        # Available conditions for the comment flow.
        mattr_accessor :available_conditions, default: [
          :forbidden_tlds,
          :allowed_tlds,
          :word,
          :official_account,
          :forbidden_continents,
          :forbidden_countries,
          :allowed_countries
        ]

        ##
        # Available actions for the comment flow.
        mattr_accessor :available_actions, default: [
          :report,
          :forbid_save,
          :lock
        ]

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

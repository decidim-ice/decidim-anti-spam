# frozen_string_literal: true

module Decidim
  module SpamSignal
    module CommentSpamValidator
      extend ActiveSupport::Concern

      included do
        include ::Decidim::SpamSignal::SpamScanValidator
        validate :detect_spam!
        def spam_reportable_user
          context.author
        end

        def spam_error_key
          :body
        end

        def spam_tested_content
          @spam_tested_content ||= Extractors::CommentExtractor.extract(self, spam_config)
        end

        def skip_scan_spam?
          body.empty?
        end

        def resource_spam_config
          @resource_spam_config ||= spam_config.comments
        end

        def scan_context
          {
            validator: commentable.commentable_type == "Decidim::Comments::Comment" ? "comment-reply" : "comment",
            is_updating: id.present?,
            date: id.present? ? updated_at : Time.zone.now,
            current_organization: context.current_organization,
            author: context.author
          }
        end
      end
    end
  end
end

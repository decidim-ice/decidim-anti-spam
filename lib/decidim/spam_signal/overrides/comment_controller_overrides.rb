# frozen_string_literal: true

module Decidim
  module SpamSignal
    module Overrides
      module CommentControllerOverrides
        extend ActiveSupport::Concern

        included do
          alias_method :spam_signal_origin_create, :create
          alias_method :spam_signal_origin_update, :update

          def update
            comment = set_comment
            set_commentable
            enforce_permission_to(:update, :comment, comment:)
            @form = Decidim::Comments::CommentForm.from_params(
              params.merge(commentable: comment.commentable)
            ).with_context(
              current_user:,
              current_organization:
            )
            @form.validate
          end

          def create
            @form = Decidim::Comments::CommentForm.from_params(
              params.merge(commentable:)
            ).with_context(
              current_organization:,
              current_component:,
              current_user:
            )
            @form.validate
          end
        end
      end
    end
  end
end

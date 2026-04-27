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
            set_comment
            set_commentable
            enforce_permission_to(:update, :comment, comment:)

            @form = Decidim::Comments::CommentForm.from_params(
              params.merge(commentable: comment.commentable)
            ).with_context(
              current_user:,
              current_organization:,
              current_component:
            )

            Decidim::Comments::UpdateComment.call(comment, @form) do
              on(:ok) do
                respond_to do |format|
                  format.js { render :update }
                end
              end

              on(:invalid) do
                respond_to do |format|
                  format.js { render :update_error }
                end
              end
            end
          end

          def create
            enforce_permission_to(:create, :comment, commentable:)

            @form = Decidim::Comments::CommentForm.from_params(
              params.merge(commentable:)
            ).with_context(
              current_organization:,
              current_component:,
              current_user:
            )
            Decidim::Comments::CreateComment.call(@form) do
              on(:ok) do |comment|
                handle_success(comment)
                respond_to do |format|
                  format.js { render :create }
                end
              end

              on(:invalid) do
                @error = t("create.error", scope: "decidim.comments.comments")
                respond_to do |format|
                  format.js { render :error }
                end
              end
            end
          end
        end
      end
    end
  end
end

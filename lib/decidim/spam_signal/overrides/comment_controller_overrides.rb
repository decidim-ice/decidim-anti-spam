module Decidim
  module SpamSignal
    module Overrides
      module CommentControllerOverrides
        extend ActiveSupport::Concern

        included do
          alias_method :spam_signal_origin_create, :create

          def create
            @form = Decidim::Comments::CommentForm.from_params(
              params.merge(commentable:)
            ).with_context(
              current_organization:,
              current_component:,
              current_user:
            )
            @form.validate
            spam_signal_origin_create
          end
        end
      end
    end
  end
end
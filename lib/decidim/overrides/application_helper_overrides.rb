# frozen_string_literal: true

module Decidim
  module SpamSignal
    module ApplicationHelperOverrides
      extend ActiveSupport::Concern
      included do
        def spam_reported?
          ::Decidim::SpamSignal.spam_actions_performed.any?
        end

        def spam_actions_performed
          ::Decidim::SpamSignal.spam_actions_performed
        end
      end
    end
  end
end

# frozen_string_literal: true

module Decidim
  module SpamSignal
    module ApplicationHelperOverrides
      extend ActiveSupport::Concern

      included do
        def spam_reported?(symbol = nil)
          if symbol.present?
            ::Decidim::SpamSignal.spam_actions_performed.include?(symbol)
          else
            ::Decidim::SpamSignal.spam_actions_performed.any?
          end
        end

        def spam_actions_performed
          ::Decidim::SpamSignal.spam_actions_performed
        end

        def spam_errors
          ::Decidim::SpamSignal.spam_errors
        end
      end
    end
  end
end

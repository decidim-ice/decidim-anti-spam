# frozen_string_literal: true

module Decidim
  module SpamSignal
    module Conditions
      class OfficialAccountCommand < ConditionHandler
        def call
          return broadcast(:valid) if official_account?

          broadcast(:invalid)
        end

        private

        def official_account?
          context[:suspicious_user].officialized?
        end
      end
    end
  end
end

module Decidim
  module SpamSignal
    module ProfileSpamValidator
      extend ActiveSupport::Concern

      included do
        validate :demo

        def demo
          byebug
        end
      end
    end
  end
end
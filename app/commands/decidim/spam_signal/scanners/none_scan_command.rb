# frozen_string_literal: true

module Decidim
  module SpamSignal
    module Scanners
      class NoneScanCommand < ::Rectify::Command
        def call
          broadcast(:ok)
        end
      end
    end
  end
end

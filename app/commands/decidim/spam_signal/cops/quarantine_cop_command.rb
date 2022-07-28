# frozen_string_literal: true

module Decidim
  module SpamSignal
    module Cops
      class QuarantineCopCommand < ::Rectify::Command
        def call
          broadcast(:ok)
        end
      end
    end
  end
end

# frozen_string_literal: true

module Decidim
  module SpamSignal
    module Cops
      class NoneCopCommand < CopHandler
        def self.form
          nil
        end
        def call
          broadcast(:ok)
        end
      end
    end
  end
end

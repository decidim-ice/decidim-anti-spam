# frozen_string_literal: true

module Decidim
  module SpamSignal
    module Scans
      class NoneScanCommand < ScanHandler
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

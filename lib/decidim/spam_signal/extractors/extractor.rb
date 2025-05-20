# frozen_string_literal: true

module Decidim
  module SpamSignal
    module Extractors
      class Extractor
        def self.extract(_model)
          raise Error, "not implemented"
        end
      end
    end
  end
end

# frozen_string_literal: true

module Decidim
  module SpamSignal
    module Extractors
      class CommentExtractor < Extractor
        def self.extract(comment)
          body = comment.attributes[:body]
          return "" if body.blank?

          body
        end
      end
    end
  end
end

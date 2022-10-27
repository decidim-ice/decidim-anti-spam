# frozen_string_literal: true

module Decidim
  module SpamSignal
    module Extractors
      class CommentExtractor < Extractor
        def self.extract(comment, config)
          body = comment.attributes[:body]
          return "" unless body.present?
          body
        end
      end
    end
  end
end

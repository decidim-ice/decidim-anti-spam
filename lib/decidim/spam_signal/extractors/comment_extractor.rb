# frozen_string_literal: true

module Decidim
  module SpamSignal
    module Extractors
      class CommentExtractor < Extractor
        def self.extract(comment, config)
          return "" unless comment.body.present?
          content = []
          config.organization.available_locales.each do |locale|
            content << "#{locale}: #{comment.body[locale]}" if comment.body[locale]
          end
          content.join("\n\n")
        end
      end
    end
  end
end

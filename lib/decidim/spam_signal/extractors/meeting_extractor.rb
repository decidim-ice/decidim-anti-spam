# frozen_string_literal: true

module Decidim
  module SpamSignal
    module Extractors
      class MeetingExtractor < Extractor
        def self.extract(meeting, _config)
          body = meeting.attributes[:body]
          return "" if body.blank?

          body
        end
      end
    end
  end
end

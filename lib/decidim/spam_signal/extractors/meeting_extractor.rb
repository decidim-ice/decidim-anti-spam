# frozen_string_literal: true

module Decidim
  module SpamSignal
    module Extractors
      class MeetingExtractor < Extractor
        def self.extract(meeting)
          address = meeting.attributes[:address]
          description = meeting.attributes[:description]
          location = meeting.attributes[:location]
          location_hints = meeting.attributes[:location_hints]
          registration_terms = meeting.attributes[:registration_terms]
          title = meeting.attributes[:title]
          registration_url = meeting.attributes[:registration_url]

          extracted_content = []
          extracted_content << title if title.present?
          extracted_content << description if description.present?
          extracted_content << address if address.present?
          extracted_content << location if location.present?
          extracted_content << location_hints if location_hints.present?
          extracted_content << registration_terms if registration_terms.present?
          extracted_content << registration_url if registration_url.present?

          extracted_content.join(". ")
        end
      end
    end
  end
end

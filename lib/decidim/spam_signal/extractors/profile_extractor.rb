# frozen_string_literal: true

module Decidim
  module SpamSignal
    module Extractors
      class ProfileExtractor < Extractor
        def self.extract(user, _config)
          "#{user.about}
===
#{user.personal_url}"
        end
      end
    end
  end
end

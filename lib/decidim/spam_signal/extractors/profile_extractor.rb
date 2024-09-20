# frozen_string_literal: true

module Decidim
  module SpamSignal
    module Extractors
      class ProfileExtractor < Extractor
        def self.extract(user, _config)
          url = if user.personal_url
                  "#{I18n.t("activemodel.attributes.user.personal_url")}: #{user.personal_url}"
                else
                  ""
                end
          "#{user.about}#{url}"
        end
      end
    end
  end
end

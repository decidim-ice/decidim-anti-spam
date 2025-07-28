module Decidim
  module SpamSignal
    module Actions
      class ActionSettingsForm < Decidim::Form
        include Decidim::SpamSignal::SettingsForm

        def normalize_locale(locale)
          locale.to_s.gsub("-", "__")
        end
      end
    end
  end
end
# frozen_string_literal: true

module Decidim
  module SpamSignal
    class SpamSettingsFormBuilder < Decidim::AuthorizationFormBuilder
      def input_field(name, type, **_options)
        return hidden_field(name) if name.to_s == "handler_name"

        case type
        when :date, :datetime, :time, :"decidim/attributes/localized_date"
          date_field name
        when :integer, Integer
          number_field name
        else
          return text_area name, rows: 5 if name.to_s.ends_with? "_csv"
          return number_field name if name.to_s.starts_with? "num_"
          return check_box name if name.to_s.starts_with?("is_") || name.to_s.ends_with?("enabled")

          text_field name
        end
      end
    end
  end
end

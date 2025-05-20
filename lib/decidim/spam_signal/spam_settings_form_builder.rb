# frozen_string_literal: true

module Decidim
  module SpamSignal
    class SpamSettingsFormBuilder < Decidim::FormBuilder
      def all_fields
        available_locales = Decidim.available_locales

        non_localized_fields = public_attributes.reject do |key, _|
          localized_ref_present = available_locales.any? do |locale|
            key_without_locale = key.sub("_#{locale}", "")
            key_without_locale != key && (form_attributes.include?(key_without_locale) || form_attributes.include?(key_without_locale.to_sym))
          end
          localized_ref_present
        end

        fields = non_localized_fields.map do |name, type|
          @template.content_tag(:div, input_field(name, type, **form_metadata), **field_attributes(name))
        end

        safe_join(fields)
      end

      def input_field(name, type, **options)
        return hidden_field(name) if name.to_s == "handler_name"

        case type
        when :date, :datetime, :time, :"decidim/attributes/localized_date"
          date_field name
        when :integer, Integer
          number_field name
        when :hash
          translated_input(name, type, **options)
        else
          plain_text_input(name, type, **options)
        end
      end

      private

      def translated_input(name, _type, **_options)
        return translated :editor, name, rows: 5, aria: { label: name } if name.to_s.ends_with? "_html"

        translated :text_area, name, rows: 3
      end

      def plain_text_input(name, _type, **options)
        return text_area name, { rows: 5, aria: { label: name } }.merge(options || {}) if name.to_s.ends_with? "_csv"
        return number_field name, aria: { label: name } if name.to_s.starts_with? "num_"
        return check_box name if name.to_s.starts_with?("is_") || name.to_s.ends_with?("enabled")

        text_field name
      end

      def public_attributes
        form_attributes.inject({}) do |all, (name, value_type)|
          all.update(name => value_type.type)
        end
      end

      def conditional_display
        @conditional_display ||= object.class.conditional_display
      end

      def field_attributes(attribute_name)
        return { class: "field field--antispam field--#{attribute_name}" } unless conditional_display.has_key?(attribute_name.to_s)

        {
          data: {
            display_if: conditional_display[attribute_name.to_s]
          },
          class: "field field--antispam js-antispam-display-if field--#{attribute_name}"
        }
      end

      def form_attributes
        object.class.attribute_types.select do |key, _|
          object.form_attributes.include?(key) || object.form_attributes.include?(key.to_sym)
        end
      end

      def form_metadata
        object.class.const_defined?(:METADATA) ? object.class::METADATA : {}
      end
    end
  end
end

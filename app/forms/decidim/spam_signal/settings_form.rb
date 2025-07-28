# frozen_string_literal: true

module Decidim
  module SpamSignal
    module SettingsForm
      extend ActiveSupport::Concern
      include Decidim::TranslatableAttributes

      included do
        class_attribute :conditional_display, default: {}

        def self.add_conditional_display(attribute_to_display, attribute_to_check)
          raise "Attribute to check must be a boolean. Found #{attribute_types[attribute_to_check.to_s].type}" unless attribute_types[attribute_to_check.to_s].type == :boolean

          conditional_display[attribute_to_display.to_s] = attribute_to_check.to_s
        end

        def form_attributes
          attributes.except(:id).keys
        end

        def handler_name
          raise Error, "no handler_name context" if context.nil? || context.handler_name.blank?

          context.handler_name
        end

        def self.human_attribute_name(attr, options = {})
          attribute_without_locales = attr.to_s
          current_locale = I18n.locale
          matching_locale = current_locale
          # Remove locales prefix if it is present
          Decidim.available_locales.each do |locale|
            normalized_locale = locale.to_s.gsub("-", "__")
            if attribute_without_locales.end_with?("_#{normalized_locale}")
              matching_locale = locale
              attribute_without_locales =  attribute_without_locales.sub("_#{normalized_locale}", "")
              break
            end
          end
          # Return the human name in the matching locale for the attribute
          I18n.with_locale(matching_locale) do
            I18n.t("decidim.spam_signal.forms.#{name.demodulize.underscore}.#{attribute_without_locales}", **options)
          end
        end

        def model_name
          ActiveModel::Name.new(self, Decidim::SpamSignal, handler_name)
        end
      end
    end
  end
end

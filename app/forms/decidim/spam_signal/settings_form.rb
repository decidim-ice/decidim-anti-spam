# frozen_string_literal: true

module Decidim
  module SpamSignal
    module SettingsForm
      extend ActiveSupport::Concern

      included do
        include Decidim::TranslatableAttributes

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
          I18n.t("decidim.spam_signal.forms.#{name.demodulize.underscore}.#{attr}", **options)
        end

        def model_name
          ActiveModel::Name.new(self, Decidim::SpamSignal, handler_name)
        end
      end
    end
  end
end

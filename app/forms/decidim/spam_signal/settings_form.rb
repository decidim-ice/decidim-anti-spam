# frozen_string_literal: true

module Decidim
  module SpamSignal
    module SettingsForm
      extend ActiveSupport::Concern

      included do
        def form_attributes
          attributes.except(:id).keys
        end

        def handler_name
          raise Error, "no handler_name context" if context.nil? || !context.handler_name.present?
          context.handler_name
        end

        def self.human_attribute_name(attr)
          I18n.t("decidim.spam_signal.forms.#{self.name.demodulize.underscore}.#{attr}")
        end
        def model_name
          ActiveModel::Name.new(self, Decidim::SpamSignal, handler_name)
        end
      end
    end
  end
end

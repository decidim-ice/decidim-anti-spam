# frozen_string_literal: true

module Decidim
  module SpamSignal
    module Admin
      class FlowForm < Decidim::Form
        include TranslatableAttributes

        def form_attributes
          attributes.except(:id).keys
        end

        mimic :flow
        translatable_attribute :name, String
        attribute :conditions, [FlowConditionForm]
        attribute :action_settings, [Decidim::Form]

        validates :name, presence: true

        validates :action_settings, presence: true
        validate :valid_actions
        validate :valid_conditions

        private

        def valid_actions
          errors.add(:action_settings, I18n.t("forms.valid_actions.empty", scope: "decidim.spam_signal")) unless action_settings.any?
          errors.add(:action_settings, I18n.t("forms.valid_actions.invalid", scope: "decidim.spam_signal")) unless action_settings.all?(&:valid?)
        end

        def valid_conditions
          errors.add(:conditions, I18n.t("forms.valid_conditions.empty", scope: "decidim.spam_signal")) unless conditions.any?
          errors.add(:conditions, I18n.t("forms.valid_conditions.invalid", scope: "decidim.spam_signal")) unless conditions.all?(&:valid?)
        end
      end
    end
  end
end

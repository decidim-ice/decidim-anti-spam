# frozen_string_literal: true

module Decidim
  module SpamSignal
    module Admin
      class FlowConditionForm < Decidim::Form
        def form_attributes
          attributes.except(:id).keys
        end
        mimic :flow_condition

        attribute :anti_spam_condition_id, Integer
        attribute :anti_spam_flow_id, Integer
        validates :anti_spam_condition_id, presence: true
        validates :anti_spam_flow_id, presence: true

        validate :validate_condition_exists
        validate :valid_for_flow

        private

        def validate_condition_exists
          return nil if errors.any?

          errors.add(:anti_spam_condition_id, "Condition not found") if condition_object.blank?
        end

        def valid_for_flow
          return nil if errors.any?

          errors.add(:anti_spam_condition_id, "Condition not valid for flow") unless flow_object.available_conditions.include?(condition_object.condition_type.to_sym)
        end

        def flow_object
          return nil if errors.any?

          @flow_object ||= Decidim::SpamSignal::Flow.find(attributes["anti_spam_flow_id"])
        end

        def condition_object
          return nil if errors.any?

          @condition_object ||= Decidim::SpamSignal::Condition.find(attributes["anti_spam_condition_id"])
        end
      end
    end
  end
end

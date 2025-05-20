# frozen_string_literal: true

module Decidim
  module SpamSignal
    class Condition < ApplicationRecord
      self.table_name = "anti_spam_conditions"
      belongs_to :organization, foreign_key: :decidim_organization_id, class_name: "Decidim::Organization"
      has_many :flows, through: :anti_spam_flows_conditions, source: :anti_spam_flow
      validates :name, presence: true
      validates :condition_type, presence: true
      validate :in_registry

      def form
        @form ||= Decidim::SpamSignal.config.conditions_registry.form_for(condition_type)
      end

      def command
        Decidim::SpamSignal.config.conditions_registry.command_for(condition_type)
      end

      private

      def in_registry
        unless Decidim::SpamSignal.config.conditions_registry.include?(condition_type)
          errors.add(
            :condition_type,
            :not_registered,
            message: "Condition type #{condition_type} is not registered"
          )
        end
      end
    end
  end
end

# frozen_string_literal: true

module Decidim
  module SpamSignal
    module Admin
      class ConditionForm < Decidim::Form
        include TranslatableAttributes

        def form_attributes
          attributes.except(:id).keys
        end

        mimic :condition

        attribute :name, String
        attribute :settings, Decidim::Form
        attribute :condition_type, String

        validate :valid_settings

        def self.conditional_display
          {}
        end

        private

        def valid_settings
          return if settings.nil?

          errors.add(:settings, I18n.t("update.invalid", scope: "decidim.spam_signal.admin.conditions")) unless settings.valid?
          errors.add(:settings, I18n.t("update.format", scope: "decidim.spam_signal.admin.conditions")) unless valid_format?(settings.attributes)
        end

        def valid_format?(settings_attributes)
          str = settings_attributes.values.last

          case settings_attributes.keys.last
          when "stop_list_words_csv"
            valid_word_format?(str)
          when "forbidden_tlds_csv", "allowed_tlds_csv"
            valid_tlds_format?(str)
          end
        end

        def valid_word_format?(str)
          !!str.match(/^(\s*[\p{L}\d[:punct:]]+(?:\s+[\p{L}\d[:punct:]]+)*\s*)(,\s*[\p{L}\d[:punct:]]+(?:\s+[\p{L}\d[:punct:]]+)*\s*)*$/)
        end

        def valid_tlds_format?(str)
          !!str.match(/^(\s*\.[a-zA-Z]+\s*)(,\s*\.[a-zA-Z]+\s*)*$/)
        end
      end
    end
  end
end

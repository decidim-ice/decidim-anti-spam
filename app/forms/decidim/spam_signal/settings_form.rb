# frozen_string_literal: true

module Decidim
  module SpamSignal
    class SettingsForm < Decidim::Form
      def form_attributes
        attributes.except(:id).keys
      end
      def self.handler_name
        name.demodulize.underscore.sub!(/(_cop|_scan)(_form|_command)/, "")
      end
      def handler_name
        self.class.handler_name
      end
      def self.model_name
        ActiveModel::Name.new(self, Decidim::SpamSignal, handler_name)
      end
      def model_name
        self.class.model_name
      end
    end
  end
end

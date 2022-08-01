# frozen_string_literal: true

module Decidim
  module SpamSignal
    class StrategyForm < Decidim::Form
      def form_attributes
        attributes.except(:id).keys
      end
      def self.handler_name
        name.demodulize.underscore.sub!(/(_cop|_scan)(_form|_command)/, "")
      end
      def handler_name
        self.class.handler_name
      end
      def self.mimic
        handler_name
      end
    end
  end
end

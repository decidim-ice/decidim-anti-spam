# frozen_string_literal: true

module Decidim
  module SpamSignal
    class ApplicationHandler < Decidim::SpamSignal::Command
      def self.form
        raise Error, "Handler need to define a form or return null"
      end

      def self.handler_name
        name.demodulize.underscore.sub(/(_cop|_scan)(_form|_command)/, "")
      end

      def handler_name
        self.class.handler_name
      end

      def self.i18n_key
        raise Error, "Not Implemented"
      end

      def config
        raise Error, "Not Implemented"
      end
    end
  end
end

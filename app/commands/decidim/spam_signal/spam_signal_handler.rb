# frozen_string_literal: true

module Decidim
  module SpamSignal
      class SpamSignalHandler < ::Rectify::Command

        def self.form
          raise Error, "Handler need to define a form or return null"
        end

        def self.handler_name
          name.demodulize.underscore.sub(/(_cop|_scan)(_form|_command)/,"")
        end
        def handler_name
          self.class.handler_name
        end

        def config
          raise Error, "Not implemented"
        end

      end
  end
end

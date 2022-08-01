# frozen_string_literal: true

module Decidim
  module SpamSignal
      class ScanHandler < SpamSignalHandler
        attr_reader :suspicious_content

        def initialize(suspicious_content, config)
          @suspicious_content = suspicious_content
          @config = config
        end

        def config
          @scan_config ||= @config.for_scan(handler_name)
        end

      end
  end
end

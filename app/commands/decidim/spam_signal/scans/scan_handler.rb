# frozen_string_literal: true

module Decidim
  module SpamSignal
    module Scans
      class ScanHandler < ApplicationHandler
        attr_reader :suspicious_content

        def initialize(suspicious_content, config)
          @suspicious_content = suspicious_content
          @config = config
        end
        def self.i18n_key
          "decidim.spam_signal.scans.#{handler_name}"
        end
        def config
          @scan_config ||= @config.for_scan(handler_name)
        end
      end
    end
  end
end

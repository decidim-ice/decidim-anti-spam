# frozen_string_literal: true

module Decidim
  module SpamSignal
    module Scans
      class ScanHandler < ApplicationHandler
        attr_reader :suspicious_content, :config

        def initialize(suspicious_content, config)
          @suspicious_content = suspicious_content
          @config = config
        end

        def self.i18n_key
          "decidim.spam_signal.scans.#{handler_name}"
        end

        def self.output_symbols
          []
        end
      end
    end
  end
end

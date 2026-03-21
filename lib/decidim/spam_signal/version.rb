# frozen_string_literal: true

module Decidim
  # This holds the decidim-spam_signal version.
  module SpamSignal
    def self.version
      "1.0.6" # DO NOT UPDATE MANUALLY
    end

    def self.decidim_version
      [">= 0.27", "<0.30"].freeze
    end
  end
end

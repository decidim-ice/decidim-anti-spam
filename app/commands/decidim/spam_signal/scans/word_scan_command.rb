# frozen_string_literal: true

module Decidim
  module SpamSignal
    module Scans
      class WordScanCommand < ScanHandler
        def self.form
          ::Decidim::SpamSignal::Scans::WordSettingsForm
        end

        def call
          return broadcast(:ok) if suspicious_content.empty?
          return broadcast(:word_found) if contains_stop_words?
          broadcast(:ok)
        end

        def self.output_symbols
          [:word_found]
        end

        private
          def contains_stop_words?
            @contains_stop_words ||= suspicious_content.match(
              /#{regex(stop_list_words)}/i
            ).to_s.present?
          end

          def regex(patterns)
            Regexp.union(patterns).source
          end

          def stop_list_words
            @stop_list_words ||= (
              config["stop_list_words_csv"] || ""
            ).split("\n").map(&:strip)
          end
      end
    end
  end
end

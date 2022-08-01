# frozen_string_literal: true

module Decidim
  module SpamSignal
    module Scans
      class WordAndLinksScanCommand < ScanHandler
        def self.form
          WordAndLinksScanForm
        end

        def call
          return broadcast(:ok) if suspicious_content.empty?
          return broadcast(:spam) if contains_stop_tlds?
          return broadcast(:spam) if contains_uri? && contains_stop_words?
          return broadcast(:suspicious) if contains_stop_words?
          broadcast(:ok)
        end

        private
          def contains_uri?
            suspicious_content.match?(URI.regexp)
          end

          def contains_stop_words?
            @contains_stop_words ||= suspicious_content.match(
              /#{regex(stop_list_words)}/i
            ).to_s.present?
          end

          def contains_stop_tlds?
            @contains_stop_tlds ||= suspicious_content.match(
              /#{regex(stop_list_tlds)}/i
            ).to_s.present?
          end

          def regex(patterns)
            Regexp.union(patterns).source
          end

          def stop_list_words
            @stop_list_words ||= (
              config[:stop_list_words] || ""
            ).split(",").map(&:strip)
          end

          def stop_list_tlds
            @stop_list_tlds ||= (
              config[:stop_list_tlds] || ""
            ).split(",").map(&:strip)
          end
      end
    end
  end
end

# frozen_string_literal: true

module Decidim
  module SpamSignal
    module Scanners
      class WordAndLinksScanCommand < ::Rectify::Command
        attr_reader :content, :config
        def call(model, config, suspicious_content)
          return broadcast(:ok) if suspicious_content.empty?
          @content = suspicious_content
          @config = config
          return broadcast(:spam) if content_has_stop_list_tlds
          has_uri = content_has_uri?(content)
          has_stop_words = content_has_stop_list_words?(content)
          return broadcast(:spam) if has_uri && has_stop_words
          return broadcast(:suspicious) if has_stop_words
          broadcast(:ok)
        end

        private
          def content_has_uri?
            content.match?(URI.regexp) unless content.nil?
          end

          def content_has_stop_list_words?
            content.match(/#{regex(stop_list_words)}/i).to_s.present? unless content.nil?
          end

          def content_has_stop_list_tlds?
            content.match(/#{regex(stop_list_tlds)}/i).to_s.present? unless content.nil?
          end

          def regex(patterns)
            Regexp.union(patterns).source
          end

          def stop_list_words
            config.stop_list_words.split(",").map(&:strip)
          end

          def stop_list_tlds
            config.stop_list_tlds.split(",").map(&:strip)
          end
      end
    end
  end
end

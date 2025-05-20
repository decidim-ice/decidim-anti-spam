# frozen_string_literal: true

module Decidim
  module SpamSignal
    module Conditions
      class WordCommand < ConditionHandler
        def call
          return broadcast(:valid) if suspicious_content.empty?
          return broadcast(:invalid) if contains_stop_words?

          broadcast(:valid)
        end

        private

        def contains_stop_words?
          suspicious_content.match?(
            /#{regex(stop_list_words)}/i
          )
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

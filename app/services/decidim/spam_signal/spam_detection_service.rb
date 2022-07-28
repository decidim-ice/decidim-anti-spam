# frozen_string_literal: true

module Decidim
  module SpamSignal
    class SpamDetectionService
      attr_reader :config
      class_attribute :_instances
      def self.instances
        self._instances ||= {}
      end
      def self.instance(config)
        key = config.id
        self.instances[key] = self.new(config) unless self.instances.key?(key)
        self.instances[key]
      end

      def initialize(config)
        @config = config
      end


      def valid?(content)
        !invalid?(content)
      end

      def invalid?(content)
        return true if content_has_stop_list_tlds?(content)
        content_has_uri?(content) && content_has_stop_list_words?(content)
      end

      private
        def content_has_uri?(content)
          content.match?(URI.regexp) unless content.nil?
        end

        def content_has_stop_list_words?(content)
          content.match(/#{regex(stop_list_words)}/i).to_s.present? unless content.nil?
        end

        def content_has_stop_list_tlds?(content)
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

# frozen_string_literal: true

module Decidim
  module SpamReport
    module SpamDetectionService
      def valid?
        !invalid?
      end

      def invalid?(content)
        true
      end

      private
        def black_worlds
          ["Call Girl"]
        end

        def black_tlds
          ["blackdomain.gg"]
        end

        def white_tlds
          ["lausanne.ch"]
        end
    end
  end
end

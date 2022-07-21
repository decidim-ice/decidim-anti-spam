


module Decidim
  module SpamSignal
    class SpamSignalJob < ApplicationJob
      
      # attr_reader :logger
      
      def perform(logger = Rails.logger)
        # @logger = logger
        invoke!
      end

      private

        def invoke!
          puts "Init Job"
          spam_signal = Decidim::SpamSignal::AppSpamSignal.new
          spam_signal.run!
        end

        
    end
  end
end

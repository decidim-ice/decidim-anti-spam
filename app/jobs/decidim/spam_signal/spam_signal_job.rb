module Decidim
  module SpamSignal
    class SpamSignalJob < ApplicationJob
            
      def perform()
        invoke!
      end

      private

        def invoke!
          spam_signal = Decidim::SpamSignal::AppSpamSignal.new
          spam_signal.run!
        end

        
    end
  end
end

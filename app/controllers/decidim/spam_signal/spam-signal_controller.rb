require_dependency "decidim/spam_signal/application_controller"

module Decidim
  module SpamSignal
    class SpamSignalController < Decidim::SpamSignal::ApplicationController
      def index
        puts "hello"
        render text: "hello"
      end
    end
  end
end

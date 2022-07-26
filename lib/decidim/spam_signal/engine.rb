# frozen_string_literal: true

require "rails"
require "decidim/core"

module Decidim
  module SpamSignal
    # This is the engine that runs on the public interface of spam_signal.
    class Engine < ::Rails::Engine
      isolate_namespace Decidim::SpamSignal     
    end
  end
end

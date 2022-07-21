# frozen_string_literal: true

require "rails"
require "decidim/core"

module Decidim
  module SpamSignal
    # This is the engine that runs on the public interface of spam_signal.
    class Engine < ::Rails::Engine
      isolate_namespace Decidim::SpamSignal

      initializer "decidim_spam_signal.assets" do |app|
        app.config.assets.precompile += %w[decidim_spam_signal_manifest.js decidim_spam_signal_manifest.css]
      end
      
    end
  end
end

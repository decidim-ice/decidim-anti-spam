# frozen_string_literal: true

require "rails"
require "decidim/core"
require "deface"

module Decidim
  module SpamSignal
    # This is the engine that runs on the public interface of spam_signal.
    class Engine < ::Rails::Engine
      isolate_namespace Decidim::SpamSignal

      config.to_prepare do
        Decidim::User.include(ProfileSpamValidator)
        Decidim::Comments::CommentForm.include(CommentSpamValidator)
      end

      initializer "decidim_spam_signal.webpacker.assets_path" do
        Decidim.register_assets_path File.expand_path("#{Decidim::SpamSignal::Engine.root}/app/packs")
      end
    end
  end
end

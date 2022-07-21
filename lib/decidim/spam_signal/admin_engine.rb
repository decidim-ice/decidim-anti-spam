# frozen_string_literal: true

module Decidim
  module SpamSignal
    # This is the engine that runs on the public interface of `SpamSignal`.
    class AdminEngine < ::Rails::Engine
      isolate_namespace Decidim::SpamSignal::Admin

    end
  end
end

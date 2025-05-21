# frozen_string_literal: true

module Decidim
  module SpamSignal
    class Configuration
      include ActiveSupport::Configurable
      config_accessor(:conditions_registry) { Decidim::SpamSignal::ManifestRegistry::SpamManifestRegistry.new }
      config_accessor(:actions_registry) { Decidim::SpamSignal::ManifestRegistry::SpamManifestRegistry.new }
      config_accessor(:available_flows) do
        [
          Decidim::SpamSignal::Flows::CommentFlow,
          Decidim::SpamSignal::Flows::ProfileFlow,
          Decidim::SpamSignal::Flows::MeetingFlow
        ]
      end
    end
  end
end

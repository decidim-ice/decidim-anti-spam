# frozen_string_literal: true

module Decidim
  module SpamSignal
    class Configuration
      class << self
        def config = self

        def configure
          yield self
        end
      end

      mattr_accessor :conditions_registry, default: Decidim::SpamSignal::ManifestRegistry::SpamManifestRegistry.new
      mattr_accessor :actions_registry, default: Decidim::SpamSignal::ManifestRegistry::SpamManifestRegistry.new
      mattr_accessor :available_flows, default: [
        Decidim::SpamSignal::Flows::CommentFlow,
        Decidim::SpamSignal::Flows::ProfileFlow,
        Decidim::SpamSignal::Flows::MeetingFlow,
        Decidim::SpamSignal::Flows::ProposalFlow,
        Decidim::SpamSignal::Flows::AuthenticationFlow
      ]
    end
  end
end

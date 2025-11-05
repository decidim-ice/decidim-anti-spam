# frozen_string_literal: true

require_relative "spam_signal/admin"
require_relative "spam_signal/engine"
require_relative "spam_signal/admin_engine"

require_relative "spam_signal/middleware/authentication_validation"
require_relative "spam_signal/manifest_registry/spam_manifest_registry"
require_relative "spam_signal/manifest_registry/spam_manifest"

require_relative "spam_signal/anti_spam_user"
require_relative "spam_signal/spam_settings_form_builder"

require_relative "spam_signal/flows/flow_validator"
require_relative "spam_signal/flows/comment_flow"
require_relative "spam_signal/flows/profile_flow"
require_relative "spam_signal/flows/meeting_flow"
require_relative "spam_signal/flows/proposal_flow"
require_relative "spam_signal/flows/authentication_flow"

require_relative "spam_signal/extractors/extractor"
require_relative "spam_signal/extractors/comment_extractor"
require_relative "spam_signal/extractors/profile_extractor"
require_relative "spam_signal/extractors/meeting_extractor"
require_relative "spam_signal/extractors/proposal_extractor"

require_relative "spam_signal/configuration"
require_relative "spam_signal/overrides/comment_controller_overrides"

require_relative "overrides/application_controller_overrides"
require_relative "overrides/application_helper_overrides"

require_relative "spam_signal/dup_generator_settings"
require_relative "spam_signal/organization_spam_signal_extensions"

require_relative "spam_signal/overrides/user_report_overrides"

module Decidim
  # This namespace holds the logic of the `SpamSignal` component. This component
  # allows users to create spam_signal in a participatory space.
  module SpamSignal
    class Error < StandardError; end
    autoload :SpamManifestRegistry, "decidim/spam_signal/manifest_registry/spam_manifest_registry"
    autoload :SpamManifest, "decidim/spam_signal/manifest_registry/spam_manifest"
    autoload :Configuration, "decidim/spam_signal/configuration"

    def self.config
      @config ||= Decidim::SpamSignal::Configuration.new
    end

    def self.configure
      yield config
    end

    def self.spam_actions_performed
      Current.spam_actions_performed ||= []
      Current.spam_actions_performed
    end

    def self.spam_errors
      Current.spam_errors
    end

    def self.spam_errors=(errors)
      Current.spam_errors = errors
    end

    def self.current_continent
      Current.continent
    end

    def self.current_country
      Current.country
    end

    def self.current_continent=(continent)
      Current.continent = continent
    end

    def self.current_country=(country)
      Current.country = country
    end
  end
end

# frozen_string_literal: true

require_relative "spam_signal/admin"
require_relative "spam_signal/engine"
require_relative "spam_signal/admin_engine"

require_relative "spam_signal/manifest_registry/spam_manifest_registry"
require_relative "spam_signal/manifest_registry/spam_manifest"

require_relative "spam_signal/anti_spam_user"
require_relative "spam_signal/spam_settings_form_builder"

require_relative "spam_signal/flows/flow_validator"
require_relative "spam_signal/flows/comment_flow"
require_relative "spam_signal/flows/profile_flow"

require_relative "spam_signal/extractors/extractor"
require_relative "spam_signal/extractors/comment_extractor"
require_relative "spam_signal/extractors/profile_extractor"

require_relative "spam_signal/configuration"

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
  end
end

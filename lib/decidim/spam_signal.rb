# frozen_string_literal: true

require_relative "spam_signal/admin"
require_relative "spam_signal/engine"
require_relative "spam_signal/admin_engine"

require_relative "spam_signal/cop_bot"
require_relative "spam_signal/spam_settings_form_builder"

require_relative "spam_signal/validators/profile_spam_validator"
require_relative "spam_signal/validators/comment_spam_validator"

require_relative "spam_signal/extractors/extractor"
require_relative "spam_signal/extractors/comment_extractor"
require_relative "spam_signal/extractors/profile_extractor"

require_relative "spam_signal/cops/cops_repository"
require_relative "spam_signal/scans/scans_repository"

module Decidim
  # This namespace holds the logic of the `SpamSignal` component. This component
  # allows users to create spam_signal in a participatory space.
  module SpamSignal
    class Error < StandardError; end
    autoload :CopsRepository, "decidim/spam_signal/cops/cops_repository"
    autoload :ScansRepository, "decidim/spam_signal/scans/scans_repository"

    autoload :WordScanCommand, "decidim/spam_signal/scans/word_scan_command"
    autoload :LockCopCommand, "decidim/spam_signal/cops/lock_cop_command"
  end
end

# frozen_string_literal: true

require_relative "spam_signal/admin"
require_relative "spam_signal/engine"
require_relative "spam_signal/admin_engine"

require_relative "spam_signal/validators/profile_spam_validator"

module Decidim
  # This namespace holds the logic of the `SpamSignal` component. This component
  # allows users to create spam_signal in a participatory space.
  module SpamSignal
  end
end

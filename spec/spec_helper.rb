# frozen_string_literal: true

ENV["RAILS_ENV"] = "test"
ENV["NODE_ENV"] ||= "test"
ENV["ENGINE_ROOT"] = File.dirname(__dir__)

require "decidim/dev"

Decidim::Dev.dummy_app_path = File.expand_path(File.join(__dir__, "decidim_dummy_app"))

require "decidim/dev/test/base_spec_helper"
require "decidim/core/test/factories"
require "decidim/spam_signal/test/factories"

RSpec.configure do |config|
  config.before do
    # decidim-core >= 0.29.7 organization factory hardcodes %w(en ca es).
    I18n.available_locales = (I18n.available_locales.map(&:to_sym) | %i(en fr es ca)).uniq

    Decidim::SpamSignal.config.conditions_registry.clear
    Decidim::SpamSignal.config.actions_registry.clear
  end
end

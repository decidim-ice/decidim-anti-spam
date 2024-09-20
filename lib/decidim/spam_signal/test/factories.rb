# frozen_string_literal: true

require "decidim/faker/localized"
require "decidim/faker/internet"
require "decidim/dev"
require "decidim/core/test/factories"
require_relative "scan_factories"
FactoryBot.define do
  factory :spam_signal_config, class: "Decidim::SpamSignal::Config" do
    organization { create(:organization) }
    comment_settings do
      {
        "scans" => {},
        "rules" => {},
        "spam_cop" => {},
        "suspicious_cop" => {}
      }
    end
    profile_settings do
      {
        "scans" => {},
        "rules" => {},
        "spam_cop" => {},
        "suspicious_cop" => {}
      }
    end
  end
end

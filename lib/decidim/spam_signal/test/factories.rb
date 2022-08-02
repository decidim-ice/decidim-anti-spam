# frozen_string_literal: true

require "decidim/faker/localized"
require "decidim/faker/internet"
require "decidim/dev"
require "decidim/core/test/factories"
require_relative "scan_factories"
FactoryBot.define do
  factory :spam_signal_config, class: "Decidim::SpamSignal::Config" do
    organization { create(:organization) }
    profile_scan { "none" }
    comment_scan { "none" }

    profile_obvious_cop { "none" }
    profile_suspicious_cop { "none" }
    comment_obvious_cop { "none" }
    comment_suspicious_cop { "none" }

    scan_settings { {
      "none": {},
      "word_and_links": {},
    }}

    cops_settings { {
      "none": {},
      "quarantine": {}
    }}
  end

  factory :banned_user, class: "Decidim::SpamSignal::BannedUser" do
    transient do
      organization { create(:organization) }
      configuration { create(:spam_signal_config, organization: organization) }
      num_days_of_quarantine { rand(2..5) }
    end
    banned_user { create(:user, organization: organization) }
    admin_reporter { create(:user, :admin, organization: organization) }
    removed_at { nil }
    notified_at { nil }
    trait :suspicious do
      notified_at { Time.current }
    end
    trait :to_ban do
      notified_at { Time.current - num_days_of_quarantine.days - 30.minutes }
    end
  end
end

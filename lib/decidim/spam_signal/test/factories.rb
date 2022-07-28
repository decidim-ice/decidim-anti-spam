# frozen_string_literal: true

require "decidim/faker/localized"
require "decidim/faker/internet"
require "decidim/dev"
require "decidim/core/test/factories"
FactoryBot.define do
  factory :spam_signal_config, class: "Decidim::SpamSignal::Config" do
      organization { create(:organization) }
      days_before_delete { rand(2..9) }
      validate_profile { true }
      validate_comments { true }
      stop_list_tlds { "sex,drug" }
      stop_list_words { "blackdomain.gg" }
  end
  
  factory :banned_user, class: "Decidim::SpamSignal::BannedUser" do
    transient do
      organization { create(:organization) }
      configuration { create(:spam_signal_config, organization: organization) }
    end
    banned_user { create(:user, organization: organization) }
    admin_reporter { create(:user, :admin, organization: organization) }
    removed_at { nil }
    notified_at { nil }
    trait :suspicious do
      notified_at { Time.current }
    end
    trait :to_ban do
      notified_at { Time.current - configuration.days_before_delete.days - 30.minutes }
    end
  end
end

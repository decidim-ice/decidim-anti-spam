# frozen_string_literal: true

require "decidim/faker/localized"
require "decidim/faker/internet"
require "decidim/dev"
require "decidim/core/test/factories"
FactoryBot.define do
  factory :banned_user, class: "Decidim::SpamSignal::BannedUser" do
    transient do
      organization { create(:organization) }
    end
    banned_user { create(:user, organization: organization) }
    admin_reporter { create(:user, :admin, organization: organization) }
    removed_at { nil }
    notified_at { nil }
    trait :suspicious do
      notified_at { Time.current }
    end
    trait :to_ban do
      notified_at { Time.current - Decidim::SpamSignal.config.days_before_delete - 30.minutes }
    end
  end
end

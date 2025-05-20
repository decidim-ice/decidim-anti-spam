# frozen_string_literal: true

FactoryBot.define do
  factory :spam_signal_flow, class: "Decidim::SpamSignal::Flow" do
    organization { create(:organization) }
    trigger_type { "dummy" }
    name { Faker::Lorem.word }
    action_settings { [{ foo: "bar" }] }
    conditions { [] }
  end
end

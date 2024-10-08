# frozen_string_literal: true

require "spec_helper"

describe Decidim::SpamSignal::CopBot do
  let(:organization) { create(:organization) }
  let(:spam_cop) { create(:user, :admin, locale: organization.default_locale, organization: organization) }

  describe "#get" do
    it "create a bot user from USER_BOT_EMAIL" do
      expect do
        ENV["USER_BOT_EMAIL"] = "test@example.org"
        Decidim::SpamSignal::CopBot.get(organization)
      end.to change(Decidim::User, :count).by(1)
      expect(Decidim::User.last.email).to eq("test@example.org")
    end

    it "unblock the bot user if was blocked" do
      cop = Decidim::SpamSignal::CopBot.get(organization)
      cop.update(blocked: true)
      expect do
        Decidim::SpamSignal::CopBot.get(organization)
      end.to change { cop.reload.blocked? }.from(true).to(false)
    end

    it "set the bot user as admin if he was removed" do
      cop = Decidim::SpamSignal::CopBot.get(organization)
      cop.update(admin: false)
      expect do
        Decidim::SpamSignal::CopBot.get(organization)
      end.to change { cop.reload.admin? }.from(false).to(true)
    end
  end
end

# frozen_string_literal: true

require "spec_helper"

describe Decidim::SpamSignal::QuarantineCleaningCommand::class do
  let(:organization) { create :organization }
  let(:spam_cop) { create(:user, :admin, organization: organization) }
  let(:spammer) { create(:user, organization: organization) }
  let(:user) { create(:user, organization: organization) }
  let(:participatory_process) { create(:participatory_process, organization: organization) }
  let(:component) { create(:component, participatory_space: participatory_process) }
  let(:dummy_resource) { create(:dummy_resource, component: component, author: user) }
  let(:target_content) { dummy_resource }
  let!(:comment) { create(:comment, commentable: target_content, author: spammer) }
  let!(:suspicious_users) { create_list(:banned_user, rand(2..9), :suspicious, organization: organization ) }
  let!(:to_ban_users) { create_list(:banned_user, rand(2..9), :to_ban, organization: organization) }

  context "when a user is in quarantine for more than 5 days" do
    it "set users as banned" do
      to_ban_count = Decidim::SpamSignal::BannedUser.to_ban.count
      expect do
        Decidim::SpamSignal::QuarantineCleaningCommand.call()
      end.to change(Decidim::SpamSignal::BannedUser.banned_users.all, :count).from(0).to(to_ban_count)
      expect(Decidim::SpamSignal::BannedUser.to_ban.count).to eq(0)
    end

    it "destroys the user" do
      ban_user_list = Decidim::SpamSignal::BannedUser.to_ban
      to_ban = ban_user_list.first
      to_ban_id = to_ban.banned_user.id
      to_ban_email = to_ban.banned_user.email
      to_ban_count = ban_user_list.count
      expect do 
        Decidim::SpamSignal::QuarantineCleaningCommand.call()
      end.to change(Decidim::User.all, :count).by(-1*to_ban_count)
      
      to_ban.reload
      expect(to_ban.banned_user).to be_nil
      expect(to_ban.banned_email).to eq(to_ban_email)
    end
  end
end

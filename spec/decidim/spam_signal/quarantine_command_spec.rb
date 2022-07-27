# frozen_string_literal: true

require "spec_helper"

describe Decidim::SpamSignal::QuarantineCommand::class do
  let(:organization) { create :organization }
  let(:spam_cop) { create(:user, :admin, organization: organization) }
  let(:spammer) { create(:user, organization: organization) }
  let(:user) { create(:user, organization: organization) }
  let(:participatory_process) { create(:participatory_process, organization: organization) }
  let(:component) { create(:component, participatory_space: participatory_process) }
  let(:dummy_resource) { create(:dummy_resource, component: component, author: user) }
  let(:target_content) { dummy_resource }
  let!(:comment) { create(:comment, commentable: target_content, author: spammer) }

  context "when putting a user in quarantine" do
    it "blocks the user" do
      expect do
        Decidim::SpamSignal::QuarantineCommand.call(spammer, spam_cop)
      end.to change { spammer.reload.blocked? }.from(false).to(true)
    end

    it "moderates the user" do
      expect do
        Decidim::SpamSignal::QuarantineCommand.call(spammer, spam_cop)
      end.to change { Decidim::UserModeration.count }.by(1)
    end

    it "adds it in the quarantine list" do
      expect do
        Decidim::SpamSignal::QuarantineCommand.call(spammer, spam_cop)
      end.to change { Decidim::SpamSignal::BannedUser.quarantine_users.count }.by(1)
    end

    it "saves the user email separately" do 
      Decidim::SpamSignal::QuarantineCommand.call(spammer, spam_cop)
      new_quarantine = Decidim::SpamSignal::BannedUser.quarantine_users.last
      expect(new_quarantine.banned_email).to eq(spammer.email)
    end

    it "doesn't add it in the banned list" do
      expect do
        Decidim::SpamSignal::QuarantineCommand.call(spammer, spam_cop)
      end.to change { Decidim::SpamSignal::BannedUser.banned_users.count }.by(0)
    end

    it "notifies the user about the blocking" do
      expect(::Decidim::BlockUserJob).to receive(:perform_later)
        .with(spammer, I18n.t("decidim.spam_signal.spam_block_justification"))
      Decidim::SpamSignal::QuarantineCommand.call(spammer, spam_cop)
    end

    it "reportes comments the user posted" do
      expect do
        Decidim::SpamSignal::QuarantineCommand.call(spammer, spam_cop)
      end.to change { comment.reload.reported? }.from(false).to(true)
    end
    it "hides comments the user posted" do
      expect do
        Decidim::SpamSignal::QuarantineCommand.call(spammer, spam_cop)
      end.to change { comment.reload.hidden? }.from(false).to(true)
    end



  end
end

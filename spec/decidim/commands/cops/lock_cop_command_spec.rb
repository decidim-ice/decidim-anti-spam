# frozen_string_literal: true

require "spec_helper"
module Decidim::SpamSignal::Cops
  describe LockCopCommand::class do
    let(:organization) { create :organization }
    let(:spam_cop) { create(:user, :admin, organization: organization) }
    let(:spammer) { create(:user, organization: organization) }
    let(:user) { create(:user, organization: organization) }
    let(:participatory_process) { create(:participatory_process, organization: organization) }
    let(:component) { create(:component, participatory_space: participatory_process) }
    let(:dummy_resource) { create(:dummy_resource, component: component, author: user) }
    let(:target_content) { dummy_resource }
    let!(:comment) { create(:comment, commentable: target_content, author: spammer) }
    let(:config) { Decidim::SpamSignal::Config.get_config(organization) }

    context "when putting a user in lock" do
      it "set the handler_name to lock" do
        expect(LockCopCommand.handler_name).to eq("lock")
      end

      it "locks the user" do
        expect do
          LockCopCommand.call(spammer, config, spam_cop)
        end.to change { spammer.reload.access_locked? }.from(false).to(true)
      end

      it "does send email instruction if config .is_email_unlockable" do
        config = Decidim::SpamSignal::Config.get_config(organization)
        config.update cops_settings: { lock: { is_email_unlockable: true } }
        expect(spammer).to receive(:lock_access!) do |opts|
          expect(opts.fetch(:send_instructions, true)).to eq(true)
        end
        LockCopCommand.call(spammer, config, spam_cop)
      end

      it "doesn't send email instruction if config not .is_email_unlockable" do
        config = Decidim::SpamSignal::Config.get_config(organization)
        config.update cops_settings: { lock: { is_email_unlockable: false } }
        expect(spammer).to receive(:lock_access!) do |opts|
          expect(opts.fetch(:send_instructions, true)).to eq(false)
        end
        LockCopCommand.call(spammer, config, spam_cop)
      end
    end
  end
end

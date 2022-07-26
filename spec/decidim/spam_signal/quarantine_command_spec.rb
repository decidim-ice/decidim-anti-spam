# frozen_string_literal: true

require "spec_helper"

describe Decidim::SpamSignal::QuarantineCommand::class do
  let(:organization) { create :organization }
  let(:spam_cop) { create(:user, :admin, organization: organization) }
  let(:spammer) { create(:user, organization: organization) }
  let(:participatory_process) { create(:participatory_process, organization: organization) }
  let(:component) { create(:component, participatory_space: participatory_process) }
  let(:dummy_resource) { create(:dummy_resource, component: component, author: spammer) }
  let(:spamming_content) { dummy_resource }


  it "blocks the user" do
    expect do
     Decidim::SpamSignal::QuarantineCommand.call(spammer, spam_cop)
   end.to change { spammer.blocked_at}.from(nil)
  end
  it "moderates the user" do
    expect do
      Decidim::SpamSignal::QuarantineCommand.call(spammer, spam_cop)
    end.to change {Decidim::UserModeration.count}.by(1)
  end
  it "add it in the quarantine list" do
    expect do
      Decidim::SpamSignal::QuarantineCommand.call(spammer, spam_cop)
    end.to change {Decidim::SpamSignal::BannedUser.count}.by(1)
  end


end

require "spec_helper"

describe Decidim::SpamSignal::CommentSpamValidator::class do
  let(:organization) { create :organization }
  let(:spam_cop) { create(:user, :admin, organization: organization) }
  let(:spammer) { create(:user, organization: organization) }
  let(:user) { create(:user, organization: organization) }
  let(:participatory_process) { create(:participatory_process, organization: organization) }
  let(:component) { create(:component, participatory_space: participatory_process) }
  let(:dummy_resource) { create(:dummy_resource, component: component, author: user) }
  let(:target_content) { dummy_resource }
  let(:config) do
    create(
      :spam_signal_config
    )
  end

  before do 
    Decidim::SpamSignal::Scans::ScansRepository.instance.set_strategy(
      "none",
      Decidim::SpamSignal::Scans::NoneScanCommand
    )
  end

  it "Runs scan on creation" do
    comment_body = {en: "spam", es: "and ham"}
    current_config =  Decidim::SpamSignal::Config.get_config(organization)
    expect(Decidim::SpamSignal::Scans::NoneScanCommand).to receive(:call).once do |tested_content,spam_config|
      expect(spam_config).to be(current_config)
      expect(tested_content).to eq("en: spam\n\nes: and ham")
    end
    create(:comment, commentable: target_content, author: spammer, body: comment_body)
  end

  it "Runs scan on update"  do
    updated_body = {en: "spam", es: "and ham"}
    current_config =  Decidim::SpamSignal::Config.get_config(organization)
    comment = create(
      :comment, 
      commentable: target_content, 
      author: spammer, 
      body:  {en: "spam", es: "and ham"}
    )
    expect(Decidim::SpamSignal::Scans::NoneScanCommand).to receive(:call).once do |tested_content,spam_config|
      expect(spam_config).to be(current_config)
      expect(tested_content).to eq("en: updated")
    end
    comment.update(body: {en: "updated"})
  end

  it "Is invalid on :spam detection" do
    Decidim::SpamSignal::Scans::ScansRepository.instance.set_strategy(
      "none",
      SpamScan
    )
    comment = build(:comment, commentable: target_content, author: spammer)
    expect(comment).to be_invalid
  end

  it "Is valid on :suspicious detection" 
  it "Apply obvious cops on :spam detection" 

  it "Is valid on :ok detection"
end
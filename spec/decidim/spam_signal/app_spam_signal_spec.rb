# frozen_string_literal: true

require "spec_helper"

describe "SpamSignal::AppSpamSignal" do
  context "#run!" do

    let(:user) { class_double("Decidim::User")}

    it "take_or_create_user_bot" do
      spam_signal = Decidim::SpamSignal::AppSpamSignal.new
      expect(spam_signal).to receive(:take_or_create_user_bot)
      expect(spam_signal).to receive(:take_or_create_user_bot)

      allow(spam_signal).to receive(:take_or_create_user_bot).and_return(:user)
      spam_signal.run!
    end

  end
end

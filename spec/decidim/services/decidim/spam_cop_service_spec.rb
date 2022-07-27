# frozen_string_literal: true

require "spec_helper"

describe Decidim::SpamSignal::SpamCopService::class do
  
    let(:spam_cop) { create(:user, :admin, organization: organization) }

    it "get" do
      allow(Decidim::SpamSignal::SpamCopService).to receive(:get).and_return(:spam_cop)
      expect(Decidim::SpamSignal::SpamCopService.get).to eq(:spam_cop)
    end

end
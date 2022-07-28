# frozen_string_literal: true

require "spec_helper"

describe Decidim::SpamSignal::SpamDetectionService::class do

  let(:spam_detection_service) { Decidim::SpamSignal::SpamDetectionService }

  it "valid?(content)" do
    expect(spam_detection_service.valid?("https://Sexy")).to eq(false)
    expect(spam_detection_service.valid?("blackdomain.gg")).to eq(false)
    expect(spam_detection_service.valid?('<a href="https://domain">Meet women</a>')).to eq(false)
    expect(spam_detection_service.valid?('<a href="https://domain">My CV</a>')).to eq(true)
  end

end

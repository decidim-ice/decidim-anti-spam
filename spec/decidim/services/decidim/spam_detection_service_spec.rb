# frozen_string_literal: true

require "spec_helper"

describe Decidim::SpamSignal::SpamDetectionService::class do

  let(:config) do
    create(
      :spam_signal_config,
      stop_list_tlds: "blackdomain.gg",
      stop_list_words: "sex,callgirl"
    )
  end
  let(:spam_detection_service) { Decidim::SpamSignal::SpamDetectionService.instance(config) }
  context "validates" do 
    it("'dumb text'") { expect(spam_detection_service.valid?("dumb text")).to be true }
    it("'http://good.url.com'") { expect(spam_detection_service.valid?("http://good.url.com")).to be true }
    it("'CallGirl'") { expect(spam_detection_service.valid?("CallGirl")).to be true }
  end
  context "unvalidates" do 
    it("'https://hello.blackdomain.gg'") { expect(spam_detection_service.valid?("https://hello.blackdomain.gg")).to be false }
    it("'Sexy https://ransomware.com'") { expect(spam_detection_service.valid?("Sexy https://ransomware.com")).to be false }
    it("'Nice! https://ransomware.com sex'") { expect(spam_detection_service.valid?("Nice! https://ransomware.com sex")).to be false }
  end

end

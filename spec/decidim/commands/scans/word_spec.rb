# frozen_string_literal: true

require "spec_helper"

describe Decidim::SpamSignal::Scans::WordScanCommand::class do

  let(:config) do
    create(
      :spam_signal_config,
      scan_settings: {
        "none": {},
        "word": {
          "stop_list_tlds_csv": "blackdomain.gg",
          "stop_list_words_csv": "sex,callgirl"
        }
      }
    )
  end
  def scan(content)
    Decidim::SpamSignal::Scans::WordScanCommand.call(
      content,
      config
    ) do
      on(:ok) { return :ok }
      on(:spam) { return :spam }
      on(:suspicious) { return :suspicious }
    end
  end

  context "is fine" do
    it("'dumb text'") { expect(scan("dumb text")).to be :ok }
    it("'http://good.url.com'") { expect(scan("http://good.url.com")).to be :ok }
  end
  context "is spam" do
    it("'https://hello.blackdomain.gg'") { expect(scan("https://hello.blackdomain.gg")).to be :spam }
    it("'Sexy https://ransomware.com'") { expect(scan("Sexy https://ransomware.com")).to be :spam }
    it("'Nice! https://ransomware.com sex'") { expect(scan("Nice! https://ransomware.com sex")).to be :spam }
  end
  context "is suspicious" do
    it("'CallGirl'") { expect(scan("CallGirl")).to be :suspicious }
  end

end

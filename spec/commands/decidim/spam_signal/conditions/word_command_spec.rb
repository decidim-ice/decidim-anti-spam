# frozen_string_literal: true

require "spec_helper"

describe Decidim::SpamSignal::Conditions::WordCommand do
  def run_condition_with_config(content, conf, context = {})
    Decidim::SpamSignal::Conditions::WordCommand.call(
      content,
      conf,
      context
    ) do
      on(:ok) { return :ok }
      on(:invalid) { return :invalid }
    end.keys.first
  end

  context "with dictionnary=(sexy,call girl,Let's talk)" do
    let(:word_config) { { "stop_list_words_csv" => "sexy\ncall girl\nLet's talk" } }

    def run_condition(content) = run_condition_with_config(content, word_config)
    context "when it is fine" do
      it("'call for dumb text'") { expect(run_condition("call for dumb text")).to be :valid }
      it("'http://good.url.com'") { expect(run_condition("http://good.url.com")).to be :valid }
    end

    context "when found a word" do
      it("'https://hello.sexy.gg'") { expect(run_condition("https://hello.sexy.gg")).to be :invalid }
      it("'Sexy https://ransomware.com'") { expect(run_condition("Sexy https://ransomware.com")).to be :invalid }
      it("'https://ransomware.com let's talk") { expect(run_condition("https://ransomware.com let's talk")).to be :invalid }
    end
  end

  context "with empty dictionnary" do
    let(:word_config) { { "stop_list_words_csv" => "\n\n\n" } }

    def run_condition(content) = run_condition_with_config(content, word_config)
    context "when it is fine" do
      it("'call for dumb text'") { expect(run_condition("call for dumb text")).to be :valid }
      it("'http://good.url.com'") { expect(run_condition("http://good.url.com")).to be :valid }
      it("'Sexy https://ransomware.com'") { expect(run_condition("Sexy https://ransomware.com")).to be :valid }
      it("'https://hello.sexy.gg'") { expect(run_condition("https://hello.sexy.gg")).to be :valid }
      it("'https://ransomware.com let's talk") { expect(run_condition("https://ransomware.com let's talk")).to be :valid }
    end
  end
end

# frozen_string_literal: true

require "spec_helper"

describe Decidim::SpamSignal::Conditions::ForbiddenTldsCommand do
  def run_condition_with_config(content, conf, context = {})
    Decidim::SpamSignal::Conditions::ForbiddenTldsCommand.call(
      content,
      conf,
      context
    ).keys.first
  end

  context "with forbidden tlds=(.finance,.fin.br)" do
    let(:forbidden_tlds_config) { { "forbidden_tlds_csv" => ".finance,.fin.br" } }

    def run_condition(content) = run_condition_with_config(content, forbidden_tlds_config)
    context "when it is fine" do
      it("'There is no URL'") { expect(run_condition("There is no URL")).to be :valid }
      it("'this is not an url: crypto.finance is ok'") { expect(run_condition("this is not an url: crypto.finance is ok")).to be :valid }
      it("'http://good.url.com'") { expect(run_condition("http://good.url.com")).to be :valid }
      it("'http://participa.social.br'") { expect(run_condition("http://participa.social.br")).to be :valid }
      it("'http://infos.com.br'") { expect(run_condition("http://infos.com.br")).to be :valid }
    end

    context "when it found a forbidden domain" do
      it("'Check https://crypto.finance'") { expect(run_condition("Check https://crypto.finance")).to be :invalid }
      it("'Check http://crypto.finance") { expect(run_condition("Check http://crypto.finance")).to be :invalid }
      it("'Click on [Google](https://escorts.fin.br) to read my blogpost'") { expect(run_condition("Click on [Google](https://escorts.fin.br) to read my blogpost")).to be :invalid }
      it("'Can't resist: https://a.subdomain.fin.br") { expect(run_condition("Can't resist: https://a.subdomain.fin.br")).to be :invalid }
    end
  end

  context "with empty forbidden tlds" do
    let(:forbidden_tlds_config) { { "forbidden_tlds_csv" => "" } }

    def run_condition(content) = run_condition_with_config(content, forbidden_tlds_config)
    context "when it is fine" do
      it("'call for dumb text'") { expect(run_condition("call for dumb text")).to be :valid }
      it("'http://good.url.com'") { expect(run_condition("http://good.url.com")).to be :valid }
      it("'Sexy https://ransomware.com'") { expect(run_condition("Sexy https://ransomware.com")).to be :valid }
      it("'https://hello.sexy.gg'") { expect(run_condition("https://hello.sexy.gg")).to be :valid }
      it("'https://ransomware.com let's talk") { expect(run_condition("https://ransomware.com let's talk")).to be :valid }
    end
  end
end

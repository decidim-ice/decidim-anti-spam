# Decidim::SpamSignal::Admin::ConfigController
require "spec_helper"
module Decidim::SpamSignal::Admin
  describe ConfigController, type: :controller do
    routes { Decidim::SpamSignal::AdminEngine.routes }

    let(:organization) { create(:organization) }
    let(:current_user) { create(:user, :admin, :confirmed, organization: organization) }

    before do
      request.env["decidim.current_organization"] = organization
      sign_in current_user, scope: :user
    end

    it "fails if " do
      configuration = Decidim::SpamSignal::Config.get_config(organization)
      expect do
        put :update, params: { id: configuration.id ,config: {profile_scan: "word_and_links"} }
      end.to change {configuration.reload.profile_scan}.from("none").to("word_and_links")
      expect(subject).to redirect_to(spam_filter_reports_path)
    end
    it "update a spam-filter configuration" do
      configuration = Decidim::SpamSignal::Config.get_config(organization)
      expect do
        put :update, params: { id: configuration.id ,config: {profile_scan: "word_and_links"} }
      end.to change {configuration.reload.profile_scan}.from("none").to("word_and_links")
      expect(subject).to redirect_to(spam_filter_reports_path)
    end

    it "update scan configurations" do 
      configuration = Decidim::SpamSignal::Config.get_config(organization)
      configuration.update(profile_scan: "word_and_links", scan_settings: {word_and_links: {stop_list_words_csv: "foo"}})
      expect do
        put :update, params: { id: configuration.id, word_and_links: {stop_list_words_csv: "bar"} }
      end.to change {configuration.reload.scan_settings["word_and_links"]["stop_list_words_csv"]}.from("foo").to("bar")
      expect(subject).to redirect_to(spam_filter_reports_path)
    end

    it "update cops configurations" do
      configuration = Decidim::SpamSignal::Config.get_config(organization)
      configuration.update(
        profile_scan: "word_and_links",
        profile_obvious_cop: "quarantine", 
        cops_settings: {quarantine: {num_days_of_quarantine: 1}})
      expect do
        put :update, params: { id: configuration.id, quarantine: {num_days_of_quarantine: 5} }
      end.to change {configuration.reload.cops_settings["quarantine"]["num_days_of_quarantine"]}.from(1).to(5)
      expect(subject).to redirect_to(spam_filter_reports_path)
    end

  end
end
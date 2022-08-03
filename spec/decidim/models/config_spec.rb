# frozen_string_literal: true

module Decidim::SpamSignal
  describe Config do
    context "#get_config" do
      it "create a configuration if not exists" do
        organization = create(:organization)
        expect do
          Config.get_config(organization)
        end.to change { Config.count }.by(1)
        config = Config.get_config(organization)
        expect(config.profile_scan).to eq("none")
        expect(config.profile_obvious_cop).to eq("none")
        expect(config.profile_suspicious_cop).to eq("none")
        expect(config.comment_scan).to eq("none")
        expect(config.comment_obvious_cop).to eq("none")
        expect(config.comment_suspicious_cop).to eq("none")
        expect(config.scan_settings).not_to be_empty
        expect(config.cops_settings).not_to be_empty
      end
    end

    context "#none scans" do
      it "set cops to none cops if scans are none" do
        config = create(
          :spam_signal_config,
          profile_scan: "word_and_links",
          profile_obvious_cop: "quarantine"
        )
        expect do
          config.update(profile_scan: "none")
        end.to change { config.reload.profile_obvious_cop }.from("quarantine").to("none")
      end
    end
  end
end

# frozen_string_literal: true

module Decidim::SpamSignal
  describe Config do
    let(:organization) { create(:organization) }
    let(:empty_config) { { "rules" => [], "scans" => {}, "spam_cop" => {}, "suspicious_cop" => {} } }
    let(:configuration) { Config.get_config(organization) }
    context "#get_config" do
      it "create a configuration if not exists" do
        expect do
          Config.get_config(organization)
        end.to change { Config.count }.by(1)
        config = Config.get_config(organization)
        expect(config.comment_settings).to eq(empty_config)
      end
    end

    context "#none scans" do
      it "can add none scan to comment" do
        expect do
          configuration.comments.add_scan("none")
          configuration.save
        end.to change { configuration.reload.comments.scans }.from({}).to({ "none" => {} })
      end

      it "can remove none scan from comment" do
        previous_scan = { **empty_config["scans"], "word" => { "list" => "a b c" } }
        configuration.comments.add_scan("word", { "list" => "a b c" })
        configuration.save
        expect do
          configuration.comments.rm_item("word")
          configuration.save
        end.to change { configuration.reload.comments.scans }.from(previous_scan).to({})
      end
    end
  end
end

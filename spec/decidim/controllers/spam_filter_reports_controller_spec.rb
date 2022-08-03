# frozen_string_literal: true

require "spec_helper"
module Decidim::SpamSignal::Admin
  describe SpamFilterReportsController, type: :controller do
    routes { Decidim::SpamSignal::AdminEngine.routes }

    let(:organization) { create(:organization) }
    let(:current_user) { create(:user, :admin, :confirmed, organization: organization) }

    before do
      request.env["decidim.current_organization"] = organization
      sign_in current_user, scope: :user
    end

    it "renders index template" do
      get :index
      expect(subject).to render_template(:index)
    end

    it "create a configuration for the organization" do
      expect do
        get :index
      end.to change { Decidim::SpamSignal::Config.count }.by(1)
    end
  end
end

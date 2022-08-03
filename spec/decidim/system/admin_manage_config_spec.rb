require "spec_helper"
describe "Admin manages configuration", type: :system do
  let(:organization) {create(:organization)}
  let(:current_user) { create(:user, :admin, :confirmed, organization: organization) }

  before do
    switch_to_host(organization.host)
    login_as current_user, scope: :user
  end
  
  it "displays a configuration form" do
    visit :index
    within "#ConfigurationForm" do
      expect(page).to have_field("ProfileScan")
    end
  end
end
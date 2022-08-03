# frozen_string_literal: true

ENV["RAILS_ENV"] = "test"
ENV["NODE_ENV"] ||= "test"
ENV["ENGINE_ROOT"] = File.dirname(__dir__)

require "decidim/dev"

Decidim::Dev.dummy_app_path = File.expand_path(File.join(__dir__, "dummy"))

require "decidim/dev/test/base_spec_helper"
require "decidim/core/test/factories"
require "decidim/spam_signal/test/factories"
require "selenium/webdriver"

Capybara.register_driver :remote_browser do |app|
  capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
    "goog:chromeOptions": { args: %w(headless disable-gpu no-sandbox) }
  )
  Capybara::Selenium::Driver.new(app, 
    browser: :remote, 
    url: "http://0.0.0.0:4444",
    desired_capabilities: capabilities
  )
end
Capybara.configure do |config|
  config.server_host = IPSocket.getaddress(Socket.gethostname)
  config.server_port = 3000

  config.javascript_driver = :remote_browser
  config.default_driver = :remote_browser
  config.app_host = "http://localhost:3000"
  config.run_server = true
end
RSpec.configure do |config|
  config.before :each, type: :system do
    driven_by(:remote_browser)
    switch_to_default_host
    domain = (try(:organization) || try(:current_organization))&.host
  end
  config.before do
    config.include Devise::Test::IntegrationHelpers, type: :request
    # Reset the locales to Decidim defaults before each test.
    # Some tests may change this which is why this is important.
    I18n.available_locales = [:en, :ca, :es]


    # Revert back to the simple backend before every test because otherwise the
    # tests may be interfered by the backend set by the specific tests. You
    # could otherwise see the following errors in case the tests are not run in
    # a specific order (where the test setting the custom backend would be
    # last):
    #   #<Double (anonymous)> was originally created in one example but has
    #   leaked into another example and can no longer be used
    #
    # The reason for this is that the factories are calling the faker gem which
    # is calling the translate method using the currently active I18n backend.
    I18n.backend = I18n::Backend::Simple.new

    # Remove the subscribers from the start_processing.action_controller
    # notification so that it does not leave any subscribers from individual
    # tests which might be using the test doubles. May cause the same error as
    # explained above.
    ActiveSupport::Notifications.unsubscribe(
      "start_processing.action_controller"
    )
  end
end

# frozen_string_literal: true

module Decidim
  module SpamSignal
    module Middleware
      class AuthenticationValidation
        # Initializes the Rack Middleware.
        #
        # app - The Rack application
        def initialize(app)
          @app = app
        end

        # Main entry point for a Rack Middleware.
        #
        # env - A Hash.
        def call(env)
          @request = ActionDispatch::Request.new(env)

          ::Decidim::SpamSignal.current_country = fetch_header("COUNTRY", "X-Country")
          ::Decidim::SpamSignal.current_continent = fetch_header("CONTINENT", "X-Continent")

          current_organization = env["decidim.current_organization"]
          return @app.call(env) if @request.path.start_with?("/system")
          return [302, { "Location" => "/system" }, []] if current_organization.blank?

          current_user = env["warden"]&.user("user") || Decidim::User.new
          # Fire authentication with a dummy active model, to keep the same logic
          # as other flows
          ::Decidim::SpamSignal::Flows::AuthenticationFlow::DummyUser.new(current_organization, current_user).validate
          @app.call(env)
        end

        def fetch_header(*keys)
          keys.each do |key|
            value = @request.headers[key]
            return value if value.present?
          end
          ""
        end
      end
    end
  end
end

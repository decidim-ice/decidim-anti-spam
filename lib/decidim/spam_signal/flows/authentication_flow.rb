# frozen_string_literal: true

module Decidim
  module SpamSignal
    module Flows
      module AuthenticationFlow
        include ActiveSupport::Configurable

        config_accessor(:available_conditions) do
          [
            :forbidden_continents,
            :forbidden_countries,
            :allowed_countries
          ]
        end

        config_accessor(:available_actions) do
          [
            :hide_authentication
          ]
        end

        class DummyUser
          include ::ActiveModel::Model
          include ::Decidim::SpamSignal::Flows::FlowValidator

          validate :detect_spam!

          attr_reader :current_organization, :current_user

          def initialize(current_organization, current_user = nil)
            @current_organization = current_organization
            @current_user = current_user
          end

          def antispam_trigger_type
            "Decidim::SpamSignal::Flows::AuthenticationFlow"
          end

          def suspicious_user
            @suspicious_user ||= current_user || Decidim::User.new
          end

          def spam_error_keys
            [:last_sign_in_ip]
          end

          def reportable_content
            nil
          end

          def content_for_antispam
            nil
          end

          def skip_antispam?
            false
          end
        end
      end
    end
  end
end

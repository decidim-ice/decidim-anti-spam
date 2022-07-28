# frozen_string_literal: true

module Decidim
  module SpamSignal
    module Admin
      class SpamFilterReportsController < Decidim::SpamSignal::Admin::ApplicationController
        include FormFactory
        helper Decidim::SpamSignal::Admin::SpamSignalHelper
        before_action :get_config
        def index
          @quarantine = quarantine_users.page(params[:page]).per(15)
          @form_configuration = form(ConfigForm).from_model(Config.get_config(current_organization))
        end

        private
          def get_config
              @current_config = Config.get_config(current_organization)
          end
          def quarantine_users
            Decidim::SpamSignal::BannedUser.quarantine_users.order(notified_at: :asc)
          end
      end
    end
  end
end

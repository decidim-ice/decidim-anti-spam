# frozen_string_literal: true

module Decidim
  module SpamSignal
    module Admin
      class QuarantinesController < Decidim::SpamSignal::Admin::ApplicationController
        helper QuarantineHelper
        before_action :find_report!, :get_config

        def show; end

        def destroy
          RemoveQuarantineCommand.call(@report)
          flash[:notice] = "Quarantine removed for #{@report.banned_user.email}."
          redirect_to spam_filter_reports_path()
        end

        private
          def get_config
            @current_config = Config.get_config(current_organization)
            @cop_config = @current_config.for_cop("quarantine")
          end

          def find_report!
            @report ||= Decidim::SpamSignal::BannedUser.find(params.require(:id))
          end
      end
    end
  end
end

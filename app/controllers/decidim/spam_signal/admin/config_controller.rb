# frozen_string_literal: true

module Decidim
  module SpamSignal
    module Admin
      class ConfigController < ApplicationController
        include FormFactory
        before_action :get_config
        helper Decidim::SpamSignal::Admin::SpamSignalHelper
        attr_reader :current_config
        def update
          @form_configuration = ConfigForm.from_params(params.require(:config))
          UpdateConfigCommand.call(@form_configuration) do
            on(:ok) do |config|
              flash[:sucess] = "Configuration updated"
              redirect_to decidim_admin_spam_signal.spam_filter_reports_path
            end

            on(:invalid) do |message|
              render "decidim/spam_signal/admin/spam_filter_reports"
            end
          end
        end

        private
          def get_config
            @current_config = Config.get_config(current_organization)
          end
      end
    end
  end
end

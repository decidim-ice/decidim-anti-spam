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
          @form_configuration = ConfigForm.from_params(params[:config] || {})
          @scanner_forms = scanner_forms
          @cop_forms = cop_forms
          @quarantine = quarantine_users.page(params[:page]).per(15)
          UpdateConfigCommand.call(
            current_config,
            @form_configuration,
            @scanner_forms,
            @cop_forms
          ) do
            on(:ok) do
              flash[:sucess] = "Configuration updated"
              redirect_to decidim_admin_spam_signal.spam_filter_reports_path
            end

            on(:invalid) do |message|
              flash[:error] = "An error occured"
              redirect_to decidim_admin_spam_signal.spam_filter_reports_path
            end
          end
        end

        private
          def scanner_forms
            strategies = []
            strategies << current_config.profile_scan
            strategies << current_config.comment_scan
            strategies.uniq.map do |s|
              form = Decidim::SpamSignal::Scans::ScansRepository.instance.strategy(s).form || nil
              form.from_params(params[s.to_sym] || {}).with_context(handler_name: s) unless form.nil?
            end.reject { |f| f.nil? }
          end
          def cop_forms
            strategies = []
            strategies << current_config.profile_obvious_cop
            strategies << current_config.profile_suspicious_cop
            strategies << current_config.comment_obvious_cop
            strategies << current_config.comment_suspicious_cop
            strategies.uniq.map do |s|
              form = Decidim::SpamSignal::Cops::CopsRepository.instance.strategy(s).form || nil
              form.from_params(params[s.to_sym] || {}).with_context(handler_name: s) unless form.nil?
            end.reject { |f| f.nil? }
          end

          def get_config
            @current_config = Decidim::SpamSignal::Config.where(
              id: params.require(:id), 
              organization: current_organization
            ).first!
          end

          def quarantine_users
            Decidim::SpamSignal::BannedUser.quarantine_users.order(notified_at: :asc)
          end
      end
    end
  end
end

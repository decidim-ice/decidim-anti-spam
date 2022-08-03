# frozen_string_literal: true

module Decidim
  module SpamSignal
    module Admin
      class SpamFilterReportsController < Decidim::SpamSignal::Admin::ApplicationController
        include FormFactory
        helper Decidim::SpamSignal::Admin::SpamSignalHelper
        before_action :get_config
        attr_reader :current_config

        def index
          @quarantine = quarantine_users.page(params[:page]).per(15)
          @form_configuration = form(ConfigForm).from_model(current_config)
          @scanner_forms = scanner_forms
          @cop_forms = cop_forms
        end

        private
          def scanner_forms
            strategies = []
            strategies << current_config.profile_scan
            strategies << current_config.comment_scan
            strategies.uniq.map do |s|
              form = Decidim::SpamSignal::Scans::ScansRepository.instance.strategy(s).form || nil
              form.new(current_config.scan_settings[s] || {}) unless form.nil?
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
              form.new(current_config.cops_settings[s] || {}) unless form.nil?
            end.reject { |f| f.nil? }
          end

          def get_config
            @current_config = Decidim::SpamSignal::Config.get_config(current_organization)
          end

          def quarantine_users
            Decidim::SpamSignal::BannedUser.quarantine_users.order(notified_at: :asc)
          end
      end
    end
  end
end

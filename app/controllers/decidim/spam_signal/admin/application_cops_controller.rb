# frozen_string_literal: true

module Decidim
  module SpamSignal
    module Admin
      class ApplicationCopsController < ApplicationController
        include FormFactory
        before_action :config
        helper Decidim::SpamSignal::Admin::SpamSignalHelper
        helper_method :cop_type, :available_cops, :current_config, :current_cop, :new_cop?
        def index; end

        def destroy
          raise "Missing id" unless cop_type

          cop_to_delete = resource_config.cop(cop_type)
          cop_name = t("decidim.spam_signal.cops.#{cop_to_delete["handler_name"]}.name")

          RemoveCopCommand.call(
            current_config,
            resource_config,
            cop_type
          ) do |_on|
            on(:invalid) { flash[:alert] = t("decidim.spam_signal.admin.cops.notices.bad_destroy", resource: cop_name) }
            on(:ok) { flash[:notice] = t("decidim.spam_signal.admin.cops.notices.destroy_ok", resource: cop_name) }
            redirect_to spam_filter_reports_path
          end
        end

        def update
          raise t("decidim.spam_signal.admin.cops.notices.not_found") unless current_cop

          cop_name = t("decidim.spam_signal.cops.#{current_cop.handler_name}.name")

          form = current_cop.form.from_params(params.require(cop_key.to_s)).with_context(
            handler_name: current_cop.handler_name,
            type: cop_type
          )
          UpdateCopCommand.call(
            current_config,
            resource_config,
            form
          ) do |_on|
            on(:invalid) { flash[:alert] = t("decidim.spam_signal.admin.cops.notices.bad_update", resource: cop_name) }
            on(:ok) { flash[:notice] = t("decidim.spam_signal.admin.cops.notices.update_ok", resource: cop_name) }
            redirect_to spam_filter_reports_path
          end
        end

        def edit
          @form = nil
          if current_cop && current_cop.form
            @form = current_cop.form.new(
              **(resource_config.cop_options(current_cop.handler_name, cop_type) || {})
            ).with_context(
              config: current_config,
              handler_name: current_cop.handler_name
            )
          elsif current_cop
            @form = Decidim::SpamSignal::NoSettingsForm.new.with_context(
              config: current_config,
              handler_name: current_cop.handler_name
            )
          end
        end

        def create
          raise t("decidim.spam_signal.admin.cops.notices.not_found") unless current_cop

          cop_name = t("decidim.spam_signal.cops.#{current_cop.handler_name}.name")

          form = current_cop.form.from_params(
            params.require(cop_type.to_s.to_sym)
          ).with_context(
            handler_name: current_cop.handler_name,
            type: cop_type
          )
          AddScannerCommand.call(
            current_config,
            resource_config,
            form
          ) do |_on|
            on(:invalid) { flash[:alert] = t("decidim.spam_signal.admin.cops.notices.bad_create", resource: cop_name) }
            on(:ok) { flash[:notice] = t("decidim.spam_signal.admin.cops.notices.create_ok", resource: cop_name) }
            redirect_to spam_filter_reports_path
          end
        end

        def resource_config
          raise Error, "Not implemented"
        end

        private

        def new_cop?
          params.permit(:new_cop)[:new_cop] == "true"
        end

        def available_cops
          cop_repository.strategies.map do |cop, _cop_klass|
            cop_repository.strategy cop
          end
        end

        def cop_repository
          Decidim::SpamSignal::Cops::CopsRepository.instance
        end

        def current_settings
          resource_config
        end

        def cop_type
          params.permit(:id)["id"] || nil
        end

        def cop_key
          params.permit(:cop)["cop"] || nil
        end

        def current_cop
          return nil unless cop_type && cop_key

          cop_repository.strategy(cop_key)
        end

        def current_config
          @current_config ||= Decidim::SpamSignal::Config.where(
            id: params.require(:config_id),
            organization: current_organization
          ).first!
        end
      end
    end
  end
end

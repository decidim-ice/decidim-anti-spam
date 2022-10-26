# frozen_string_literal: true

module Decidim
  module SpamSignal
    module Admin
      class ApplicationCopsController < ApplicationController
        include FormFactory
        before_action :config
        helper Decidim::SpamSignal::Admin::SpamSignalHelper
        helper_method :cop_type, :available_cops, :current_config, :current_cop
        def index
          output_symbols = scan_repository.strategies.map do |scan_name|
            scanKlass = scan_repository.strategy(scan_name)
            scanKlass.output_symbols
          end.flatten
        end

        def destroy
          raise "Missing id" unless cop_type
          RemoveCopCommand.call(
            current_config,
            resource_config,
            cop_type
          ) do |on|
            on(:invalid) { flash[:alert] = "Can not remove the agent" }
            on(:ok) { flash[:notice] = "Remove has been removed"  }
            redirect_to spam_filter_reports_path
          end
        end

        def update
          raise "No agent found" unless current_cop
          form = current_cop.form.from_params(params.require("#{cop_key}".to_sym)).with_context(
            handler_name: current_cop.handler_name,
            type: cop_type
          )
          UpdateCopCommand.call(
            current_config,
            resource_config,
            form
          ) do |on|
            on(:invalid) { flash[:alert] = "Can not update the agent" }
            on(:ok) { flash[:notice] = "Agent has been updated"  }
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
          raise "No scanner found" unless current_cop
          form = current_cop.form.from_params(
            params.require("#{cop_type}".to_sym)
          ).with_context(
            handler_name: current_cop.handler_name,
            type: cop_type
          )
          AddScannerCommand.call(
            current_config,
            resource_config,
            form
          ) do |on|
            on(:invalid) { flash[:alert] = "Can not create the scanner" }
            on(:ok) { flash[:notice] = "Scanner has been created"  }
            redirect_to spam_filter_reports_path
          end
        end

        def resource_config
          raise Error, "Not implemented"
        end
        private
          def available_cops
            cop_repository.strategies.map do |cop, copKlass|
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

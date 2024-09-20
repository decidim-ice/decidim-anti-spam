# frozen_string_literal: true

module Decidim
  module SpamSignal
    module Admin
      class ApplicationScansController < ApplicationController
        include FormFactory
        before_action :config
        helper Decidim::SpamSignal::Admin::SpamSignalHelper
        helper_method :available_scanners, :current_config, :current_scanner

        def new
          @form = if current_scanner && current_scanner.form
                    current_scanner.form.new(
                      **(resource_config.scan_options(current_scanner.handler_name) || {})
                    ).with_context(
                      config: current_config,
                      handler_name: current_scanner.handler_name
                    )
                  end
        end

        def update
          raise t("decidim.spam_signal.admin.scans.notices.not_found") unless current_scanner

          form = current_scanner.form.from_params(params.require(scan_key.to_s.to_sym)).with_context(handler_name: current_scanner.handler_name)
          UpdateScannerCommand.call(
            current_config,
            resource_config,
            form
          ) do |_on|
            on(:invalid) { flash[:alert] = t("decidim.spam_signal.admin.scans.notices.bad_update", resource: scan_name) }
            on(:ok) { flash[:notice] = t("decidim.spam_signal.admin.scans.notices.update_ok", resource: scan_name) }
            redirect_to spam_filter_reports_path
          end
        end

        def edit
          raise t("decidim.spam_signal.admin.scans.notices.not_found") unless current_scanner

          @form = current_scanner.form.new(
            **(resource_config.scan_options(current_scanner.handler_name) || {})
          ).with_context(
            config: current_config,
            handler_name: current_scanner.handler_name
          )
        end

        def destroy
          raise t("decidim.spam_signal.admin.scans.notices.not_found") unless current_scanner

          RemoveScannerCommand.call(
            current_config,
            resource_config,
            current_scanner.handler_name
          ) do |_on|
            on(:invalid) { flash[:alert] = t("decidim.spam_signal.admin.scans.notices.bad_destroy", resource: scan_name) }
            on(:ok) { flash[:notice] = t("decidim.spam_signal.admin.scans.notices.destroy_ok", resource: scan_name) }
          end
          redirect_to spam_filter_reports_path
        end

        def create
          raise t("decidim.spam_signal.admin.scans.notices.not_found") unless current_scanner

          form = current_scanner.form.from_params(params.require(scan_key.to_s)).with_context(handler_name: current_scanner.handler_name)
          AddScannerCommand.call(
            current_config,
            resource_config,
            form
          ) do |_on|
            on(:invalid) { flash[:alert] = t("decidim.spam_signal.admin.scans.notices.bad_create", resource: scan_name) }
            on(:ok) { flash[:notice] = t("decidim.spam_signal.admin.scans.notices.create_ok", resource: scan_name) }
            redirect_to spam_filter_reports_path
          end
        end

        def resource_config
          raise Error, "Not implemented"
        end

        private

        def scan_name
          @scan_name ||= if current_scanner
                           t("decidim.spam_signal.scans.#{current_scanner.handler_name}.name")
                         else
                           "Untitled"
                         end
        end

        def available_scanners
          available_scanner_names.map do |scan|
            scan_repository.strategy scan
          end
        end

        def available_scanner_names
          scan_repository.strategies.reject { |scan| current_settings.scans.include?(scan.to_s) }
        end

        def scan_repository
          Decidim::SpamSignal::Scans::ScansRepository.instance
        end

        def current_settings
          resource_config
        end

        def scan_key
          params.permit(:id)["id"] || nil
        end

        def current_scanner
          return nil unless scan_key

          scan_repository.strategy(scan_key)
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

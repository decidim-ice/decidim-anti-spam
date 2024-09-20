# frozen_string_literal: true

require "securerandom"

module Decidim
  module SpamSignal
    module Admin
      class ApplicationRulesController < ApplicationController
        include FormFactory
        before_action :config
        helper Decidim::SpamSignal::Admin::SpamSignalHelper
        helper_method :current_config, :current_scanner, :rule_type, :available_symbols, :uuid, :current_rule_id, :current_rule
        def new
          @form = RuleForm.new.with_context(handler_name: rule_type)
        end

        def update
          # destroy if no rules have been checked
          return destroy unless params["rules"]

          rule = params.require(:rules)
          rule_id = rule.keys.first
          raise "No rule_id given" unless rule_id

          prev_rule = resource_config.rule(rule_id)
          form = RuleForm.from_params(rules: rule.require(rule_id).permit!.to_h).with_context(handler_name: prev_rule["handler_name"])
          UpdateRuleCommand.call(
            current_config,
            resource_config,
            form,
            rule_id
          ) do |_on|
            on(:invalid) { flash[:alert] = t("decidim.spam_signal.admin.rules.notices.bad_update") }
            on(:ok) { flash[:notice] = t("decidim.spam_signal.admin.rules.notices.update_ok") }
            redirect_to spam_filter_reports_path
          end
        end

        def edit
          rule = resource_config.rule(current_rule_id)
          @form = RuleForm.from_params(rules: rule["rules"]).with_context(handler_name: rule["handler_name"], id: current_rule_id)
        end

        def destroy
          raise "No rule found" unless current_rule_id

          RemoveRuleCommand.call(
            current_config,
            resource_config,
            current_rule_id
          ) do |_on|
            on(:invalid) { flash[:alert] = t("decidim.spam_signal.admin.rules.notices.bad_destroy") }
            on(:ok) { flash[:notice] = t("decidim.spam_signal.admin.rules.notices.destroy_ok") }
          end
          redirect_to spam_filter_reports_path
        end

        def create
          return redirect_to spam_filter_reports_path unless params["rules"]

          rule = params.require(:rules)
          rule_id = rule.keys.first
          raise "No rule_id given" unless rule_id

          form = RuleForm.from_params(rules: rule.require(rule_id).permit!.to_h).with_context(handler_name: rule_type)
          AddRuleCommand.call(
            current_config,
            resource_config,
            form,
            rule_id
          ) do |_on|
            on(:invalid) { flash[:alert] = t("decidim.spam_signal.admin.rules.notices.bad_create") }
            on(:ok) { flash[:notice] = t("decidim.spam_signal.admin.rules.notices.create_ok") }
            redirect_to spam_filter_reports_path
          end
        end

        def resource_config
          raise Error, "Not implemented"
        end

        private

        def rule_name
          @rule_name ||= I18n.t("activerecord.models.decidim/spam_signal/rule", count: 1).downcase
        end

        def current_rule_id
          params.permit(:id)["id"]
        end

        def current_rule
          @current_rule ||= current_rule_id ? resource_config.rule(current_rule_id) : nil
        end

        def available_symbols
          taken_scanners.map(&:output_symbols).flatten
        end

        def taken_scanners
          taken_scanner_names.map do |scan|
            scan_repository.strategy scan
          end
        end

        def taken_scanner_names
          scan_repository.strategies.select { |scan| current_settings.scans.include?(scan.to_s) }
        end

        def scan_repository
          Decidim::SpamSignal::Scans::ScansRepository.instance
        end

        def uuid
          SecureRandom.uuid
        end

        def current_settings
          resource_config
        end

        def scan_key
          params.permit(:id)["id"] || nil
        end

        def rule_type
          params.permit(:rule)["rule"] || nil
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

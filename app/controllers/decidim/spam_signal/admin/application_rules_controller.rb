# frozen_string_literal: true

require "securerandom"

module Decidim
  module SpamSignal
    module Admin
      class ApplicationRulesController < ApplicationController
        include FormFactory
        before_action :config
        helper Decidim::SpamSignal::Admin::SpamSignalHelper
        helper_method :current_config, :current_scanner, :rule_type, :available_symbols, :uuid, :current_rule
        def new
          @form = RuleForm.new.with_context(handler_name: rule_type)
        end

        def update
          unless params["rules"]
            flash[:alert] = "Can not empty a rule, delete it instead"
            return redirect_to spam_filter_reports_path
          end
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
          ) do |on|
            on(:invalid) { |e| flash[:alert] = "Can not update the rule" }
            on(:ok) { flash[:notice] = "Rule has been updated"  }
            redirect_to spam_filter_reports_path
          end
        end

        def edit
          rule = resource_config.rule(current_rule)
          @form = RuleForm.from_params(rules: rule["rules"]).with_context(handler_name: rule["handler_name"], id: current_rule)
        end

        def destroy
          raise "No rule found" unless current_rule
          RemoveRuleCommand.call(
            current_config,
            resource_config,
            current_rule
          ) do |on|
            on(:invalid) { flash[:alert] = "error on deleting rule" }
            on(:ok) { flash[:notice] = "rule have been removed" }
          end
          redirect_to spam_filter_reports_path
        end

        def create
          unless params["rules"]
            flash[:alert] = "Can not add empty rules"
            return redirect_to spam_filter_reports_path
          end
          rule = params.require(:rules)
          rule_id = rule.keys.first
          raise "No rule_id given" unless rule_id
          form = RuleForm.from_params(rules: rule.require(rule_id).permit!.to_h).with_context(handler_name: rule_type)
          AddRuleCommand.call(
            current_config,
            resource_config,
            form,
            rule_id
          ) do |on|
            on(:invalid) { |e| flash[:alert] = "Can not add the rule" }
            on(:ok) { flash[:notice] = "Rule has been added"  }
            redirect_to spam_filter_reports_path
          end
        end

        def resource_config
          raise Error, "Not implemented"
        end

        private
          def current_rule
            rule = params.permit(:id)["id"]
          end

          def available_symbols
            taken_scanners.map do |scanKlass|
              scanKlass.output_symbols
            end.flatten
          end

          def taken_scanners
            taken_scanner_names.map do |scan|
              scan_repository.strategy scan
            end
          end

          def taken_scanner_names
            scan_repository.strategies.select { |scan| current_settings.scans.include?("#{scan}") }
          end

          def scan_repository
            Decidim::SpamSignal::Scans::ScansRepository.instance
          end

          def uuid
            uuid = SecureRandom.uuid
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

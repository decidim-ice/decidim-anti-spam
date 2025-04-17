# frozen_string_literal: true

module Decidim
  module SpamSignal
    module Admin
      class FlowsController < ApplicationController
        include Decidim::Admin::Concerns::HasTabbedMenu

        helper_method :flows, :available_flows, :blank_condition

        layout "decidim/admin/settings"

        add_breadcrumb_item_from_menu :admin_settings_menu

        def tab_menu_name = :admin_spam_signal_menu
        
        def index; end

        def new; end

        def edit
          trigger_type = flow.trigger_type.constantize
          actions_form = Decidim::SpamSignal.config.actions_registry.names.filter do |act_name|
            trigger_type.available_actions.include?(act_name)
          end
          actions_form = actions_form.map do |act_name|
            Decidim::SpamSignal.config.actions_registry.form_for(act_name).new(**flat_action_settings(flow.action_settings || {}))
          end
          @form ||= begin
            form = FlowForm.from_model(flow)
            form.action_settings = actions_form
            form
          end
        end

        def create
          trigger_type = params.require(:flow).require(:trigger_type)
          return redirect_to(
            new_flow_path, 
            alert: t("decidim.spam_signal.admin.flows.create.error")
            ) unless available_flows.include?(trigger_type)

          flow = Decidim::SpamSignal::Flow.new(organization: current_organization, trigger_type:)
          flow.save(validate: false)
          redirect_to edit_flow_path(flow), notice: t("decidim.spam_signal.admin.flows.create.success")
        end

        def update
          trigger_type = flow.trigger_type.constantize
          available_actions = Decidim::SpamSignal.config.actions_registry.names
          actions_form = available_actions.filter do |act_name|
            trigger_type.available_actions.include?(act_name)
          end
          actions_form = actions_form.map do |act_name|
            Decidim::SpamSignal.config.actions_registry.form_for(act_name).from_params(params.require(:flow).require(:action_settings))
          end
          @form = FlowForm.from_params(params)
          @form.action_settings = actions_form
          if @form.valid?
            was_new = flow.invalid?
            clear_conditions
            flow.update!(
              name: @form.name,
              action_settings: flat_action_settings(@form.action_settings),
              conditions: conditions_from_form(@form)
            )
            return redirect_to flows_path, notice: t("decidim.spam_signal.admin.flows.create.success") if was_new
              redirect_to edit_flow_path(flow), notice: t("decidim.spam_signal.admin.flows.update.success")
          else
            flash.now[:alert] = @form.errors.messages[:conditions].first
            render :edit
            #{ alert: t("decidim.spam_signal.admin.flows.update.error") }
          end
        end

        private
        def clear_conditions
          Decidim::SpamSignal::FlowCondition.where(anti_spam_flow_id: flow.id).destroy_all
        end

        def conditions_from_form(form)
          @conditions_from_form ||= form.conditions.map do |condition|
            Decidim::SpamSignal::Condition.find(condition.anti_spam_condition_id)
          end
        end

        def blank_condition
          Decidim::SpamSignal::Admin::FlowConditionForm.new(anti_spam_condition_id: flow.id)
        end

        def flat_action_settings(action_settings_form)
          return action_settings_form.attributes || {} if action_settings_form.is_a?(Decidim::Form)
          return action_settings_form.flatten.first || {} if action_settings_form.is_a?(Array)
          action_settings_form || {}
        end

        def flow
          @flow ||= Decidim::SpamSignal::Flow.find(params.require(:id))
        end

        def available_flows
          @available_flows ||= Decidim::SpamSignal.config.available_flows.map(&:name)
        end

        def flows
          @flows ||= Decidim::SpamSignal::Flow.where(organization: current_organization)
        end

        def available_conditions
          available_conditions = Decidim::SpamSignal::Condition.all
          available_conditions = available_conditions.select { |c| flow.available_conditions.include?(c.condition_type.to_sym) }
        end
      end
    end
  end
end

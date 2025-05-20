# frozen_string_literal: true

module Decidim
  module SpamSignal
    module Admin
      class FlowsController < ApplicationController
        include Decidim::Admin::Concerns::HasTabbedMenu

        helper_method :flows, :available_flows, :blank_condition, :available_conditions

        layout "decidim/admin/settings"

        add_breadcrumb_item_from_menu :admin_settings_menu

        def tab_menu_name = :admin_spam_signal_menu

        def index; end

        def pick; end

        def new
          @trigger_type = params.require(:trigger_type)
          klass = @trigger_type.constantize
          actions_form = actions(klass).map do |action_name|
            Decidim::SpamSignal.config.actions_registry.form_for(action_name).new
          end
          @form ||= begin
            form = form(FlowForm).instance
            form.action_settings = actions_form
            form
          end
        end

        def edit
          @trigger_type = flow.trigger_type
          actions_form = actions(@trigger_type.constantize).map do |action_name|
            Decidim::SpamSignal.config.actions_registry.form_for(action_name).from_params(
              {}.merge(*flow.action_settings)
            )
          end
          @form ||= begin
            form = FlowForm.from_model(flow)
            form.action_settings = actions_form
            form
          end
        end

        def create
          @trigger_type = params.require(:trigger_type)
          klass = @trigger_type.constantize
          actions_form = actions(klass).map do |action_name|
            Decidim::SpamSignal.config.actions_registry.form_for(action_name).from_params(params.require(:flow).require(:action_settings))
          end
          @form ||= begin
            form = FlowForm.from_params(params.require(:flow))
            form.action_settings = actions_form
            form.conditions = conditions_from_params
            form
          end

          if form.valid?
            @flow = Decidim::SpamSignal::Flow.create!(
              organization: current_organization,
              trigger_type: @trigger_type,
              name: form.name,
              action_settings: form.action_settings
            )
            @form.conditions.map do |condition|
              Decidim::SpamSignal::FlowCondition.create!(
                anti_spam_condition_id: condition.id,
                anti_spam_flow_id: @flow.id
              )
            end
            redirect_to flows_path(flow), notice: t(".success")
          else
            flash.now[:alert] = I18n.t("decidim.spam_signal.admin.flows.create.error")
            render :new
          end
        end

        def update
          @flow = flow
          @trigger_type = params.require(:trigger_type)
          actions_form = actions(@trigger_type.constantize).map do |action_name|
            Decidim::SpamSignal.config.actions_registry.form_for(action_name).from_params(params.require(:flow).require(:action_settings))
          end
          @form ||= begin
            form = FlowForm.from_params(params.require(:flow))
            form.action_settings = actions_form
            form.conditions = conditions_from_params
            form
          end
          if @form.valid?
            clear_conditions
            @flow.update!(
              name: @form.name,
              action_settings: @form.action_settings.map(&:attributes)
            )
            @form.conditions.map do |condition|
              Decidim::SpamSignal::FlowCondition.create!(
                anti_spam_condition_id: condition.id,
                anti_spam_flow_id: @flow.id
              )
            end
            redirect_to flows_path, notice: I18n.t("decidim.spam_signal.admin.flows.update.success")
          else
            flash.now[:alert] = I18n.t("decidim.spam_signal.admin.flows.update.error")
            render :edit
          end
        end

        def destroy
          Flows::DestroyFlow.call(flow) do
            on(:ok) do
              flash.now[:notice] = I18n.t("delete.success", scope: "decidim.spam_signal.admin.flows")
              render :index
            end
          end
        end

        private

        def actions(klass)
          Decidim::SpamSignal.config.actions_registry.names.filter do |action_name|
            klass.available_actions.include?(action_name)
          end
        end

        def conditions_from_params
          return [] if params[:conditions].blank?

          params.fetch(:conditions, {}).values.filter_map do |v|
            id = v["anti_spam_condition_id"]
            ConditionForm.new(id:) if id.present?
          end
        end

        def clear_conditions
          Decidim::SpamSignal::FlowCondition.where(anti_spam_flow_id: flow.id).destroy_all
        end

        def conditions_from_form(form)
          @conditions_from_form ||= form.conditions.map do |condition|
            Decidim::SpamSignal::Condition.find(condition.id)
          end
        end

        def blank_condition
          Decidim::SpamSignal::Admin::FlowConditionForm.new(anti_spam_condition_id: flow.id)
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
          Decidim::SpamSignal::Condition.all
        end
      end
    end
  end
end

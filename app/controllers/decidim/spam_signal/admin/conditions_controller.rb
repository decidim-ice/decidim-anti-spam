# frozen_string_literal: true

module Decidim
  module SpamSignal
    module Admin
      class ConditionsController < Decidim::SpamSignal::Admin::ApplicationController
        include Decidim::Admin::Concerns::HasTabbedMenu
        helper_method :conditions, :available_conditions

        layout "decidim/admin/settings"

        add_breadcrumb_item_from_menu :admin_settings_menu

        def tab_menu_name = :admin_spam_signal_menu

        def index; end

        def pick; end

        def new
          @form = form(ConditionForm).instance
          session[:condition_type] = condition_type = params.require(:condition_type)
          unless available_conditions.include?(condition_type.to_sym)
            return redirect_to(
              new_condition_path,
              alert: t("decidim.spam_signal.admin.conditions.create.error")
            )
          end

          @condition_form ||= Decidim::SpamSignal.config.conditions_registry.form_for(condition_type).new
        end

        def edit
          @form ||= ConditionForm.from_model(condition)
          @condition_form ||= Decidim::SpamSignal.config.conditions_registry.form_for(condition.condition_type).new(condition.settings)
        end

        def create
          @form = begin
            form = ConditionForm.from_params(params)
            form.settings = form_settings(session[:condition_type])
            form
          end
          if @form.valid?
            @condition = Decidim::SpamSignal::Condition.create!(
              organization: current_organization,
              name: @form.name,
              settings: @form.settings&.attributes,
              condition_type: session[:condition_type]
            )
            redirect_to conditions_path, notice: t(".success")
          else
            flash.now[:alert] = form.errors.messages[:settings].first
            redirect_to action: :edit
          end
        end

        def update
          @form = begin
            form = ConditionForm.from_params(params)
            form.settings = form_settings(condition.condition_type)
            form
          end
          @condition_form = form.settings
          if @form.valid?
            condition.update!(
              name: @form.name,
              settings: @form.settings&.attributes
            )
            redirect_to conditions_path, notice: I18n.t("decidim.spam_signal.admin.conditions.update.success")
          else
            flash.now[:alert] = form.errors.messages[:settings].first
            redirect_to action: :edit
          end
        end

        def destroy
          Conditions::DestroyCondition.call(condition) do
            on(:ok) do
              flash[:notice] = I18n.t("delete.success", scope: "decidim.spam_signal.admin.conditions")
              render :index
            end
          end
        end

        private

        def condition
          @condition ||= Decidim::SpamSignal::Condition.find(params.require(:id))
        end

        def available_conditions
          @available_conditions ||= Decidim::SpamSignal.config.conditions_registry.names
        end

        def conditions
          @conditions ||= Decidim::SpamSignal::Condition.where(organization: current_organization)
        end

        def form_settings(condition_type)
          settings = params.dig(:condition, :settings)
          return unless settings

          permitted_settings = settings.permitted? ? settings : settings.permit!
          Decidim::SpamSignal.config.conditions_registry.form_for(condition_type).new(permitted_settings)
        end
      end
    end
  end
end

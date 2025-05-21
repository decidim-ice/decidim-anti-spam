# frozen_string_literal: true

require "rails"
require "decidim/core"
require "deface"

module Decidim
  module SpamSignal
    # This is the engine that runs on the public interface of spam_signal.
    class Engine < ::Rails::Engine
      isolate_namespace Decidim::SpamSignal

      config.to_prepare do
        Decidim::AccountForm.include(
          Decidim::SpamSignal::Flows::ProfileFlow::ProfileValidationFormOverrides
        )
        Decidim::Comments::CommentForm.include(
          Decidim::SpamSignal::Flows::CommentFlow::CommentValidationFormOverrides
        )
        Decidim::Meetings::MeetingForm.include(
          Decidim::SpamSignal::Flows::MeetingFlow::MeetingValidationFormOverrides
        )
        Decidim::Comments::CommentsController.include(
          Decidim::SpamSignal::Overrides::CommentControllerOverrides
        )
      end

      initializer "decidim_spam_signal.webpacker.assets_path" do
        Decidim.register_assets_path File.expand_path("#{Decidim::SpamSignal::Engine.root}/app/packs")
      end

      initializer "decidim_spam_signal.register_icons" do
        Decidim.icons.register(name: "shield-line", icon: "shield-line", category: "system", description: "", engine: :spam_signal)
        Decidim.icons.register(name: "information-line", icon: "information-line", category: "system", description: "", engine: :spam_signal)
        Decidim.icons.register(name: "search-eye-line", icon: "search-eye-line", category: "system", description: "", engine: :spam_signal)
        Decidim.icons.register(name: "guide-line", icon: "guide-line", category: "system", description: "", engine: :spam_signal)
      end

      initializer "decidim_spam_signal.admin_spam_signal_menu" do
        Decidim.menu :admin_spam_signal_menu do |menu|
          menu.add_item :general,
                        I18n.t("menu.spam_signal", scope: "decidim.admin", default: "General"),
                        decidim_admin_spam_signal.generals_path,
                        icon_name: "information-line",
                        position: 1,
                        active: is_active_link?(decidim_admin_spam_signal.generals_path, :inclusive),
                        if: defined?(current_user) && current_user&.read_attribute("admin")
          menu.add_item :condition,
                        I18n.t("menu.spam_signal", scope: "decidim.admin", default: "Conditions"),
                        decidim_admin_spam_signal.conditions_path,
                        icon_name: "search-eye-line",
                        position: 2,
                        active: is_active_link?(decidim_admin_spam_signal.conditions_path, :inclusive),
                        if: defined?(current_user) && current_user&.read_attribute("admin")
          menu.add_item :flow,
                        I18n.t("menu.spam_signal", scope: "decidim.admin", default: "Flows"),
                        decidim_admin_spam_signal.flows_path,
                        icon_name: "guide-line",
                        position: 3,
                        active: is_active_link?(decidim_admin_spam_signal.flows_path, :inclusive),
                        if: defined?(current_user) && current_user&.read_attribute("admin")
        end
      end

      config.after_initialize do
        Decidim::SpamSignal.configure do |config|
          config.conditions_registry.register(
            :forbidden_tlds,
            Decidim::SpamSignal::Conditions::ForbiddenTldsSettingsForm,
            Decidim::SpamSignal::Conditions::ForbiddenTldsCommand
          )
          config.conditions_registry.register(
            :allowed_tlds,
            Decidim::SpamSignal::Conditions::AllowedTldsSettingsForm,
            Decidim::SpamSignal::Conditions::AllowedTldsCommand
          )
          config.conditions_registry.register(
            :word,
            Decidim::SpamSignal::Conditions::WordSettingsForm,
            Decidim::SpamSignal::Conditions::WordCommand
          )
          config.conditions_registry.register(
            :official_account,
            Decidim::SpamSignal::NoSettingsForm,
            Decidim::SpamSignal::Conditions::OfficialAccountCommand
          )
          config.actions_registry.register(
            :forbid_save,
            Decidim::SpamSignal::Actions::ForbidSaveSettingsForm,
            Decidim::SpamSignal::Actions::ForbidSaveActionCommand
          )
          config.actions_registry.register(
            :lock,
            Decidim::SpamSignal::Actions::LockSettingsForm,
            Decidim::SpamSignal::Actions::LockActionCommand
          )
          config.actions_registry.register(
            :report,
            Decidim::SpamSignal::Actions::ReportUserSettingsForm,
            Decidim::SpamSignal::Actions::ReportUserActionCommand
          )
        end
      end
    end
  end
end

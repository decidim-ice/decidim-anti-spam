# frozen_string_literal: true

module Decidim
  module SpamSignal
    # This is the engine that runs on the public interface of `SpamSignal`.
    class AdminEngine < ::Rails::Engine
      isolate_namespace Decidim::SpamSignal::Admin
      routes do
        resources :spam_filter_reports
        resources :config, only: [] do
          resources :comment_scans
          resources :comment_rules
          resources :comment_cops, only: [:update, :edit, :destroy]
          resources :profile_scans
          resources :profile_rules
          resources :profile_cops, only: [:update, :edit, :destroy]
        end
      end

      initializer "decidim_spam_signal.admin_mount_routes" do
        Decidim::Core::Engine.routes do
          mount Decidim::SpamSignal::AdminEngine, at: "/admin/spam_signal", as: "decidim_admin_spam_signal"
        end
      end

      initializer "decidim_spam_signal.admin_menu" do
        Decidim.menu :admin_menu do |menu|
          menu.item I18n.t("menu.spam_signal", scope: "decidim.admin", default: "Spam Filter"),
                    decidim_admin_spam_signal.spam_filter_reports_path,
                    icon_name: "shield",
                    position: 9,
                    active: is_active_link?(decidim_admin_spam_signal.spam_filter_reports_path, :inclusive),
                    if: defined?(current_user) && current_user&.read_attribute("admin")
        end
      end

      def load_seed
        nil
      end
    end
  end
end

# frozen_string_literal: true

module Decidim
  module SpamSignal
    # This is the engine that runs on the public interface of `SpamSignal`.
    class AdminEngine < ::Rails::Engine
      isolate_namespace Decidim::SpamSignal::Admin
      routes do
        resources :config, only: [] do
          resources :comment_scans
          resources :comment_rules
          resources :comment_cops, only: [:update, :edit, :destroy]
          resources :profile_scans
          resources :profile_rules
          resources :profile_cops, only: [:update, :edit, :destroy]
        end
        resources :generals, only: [:index]
        resources :conditions do
          collection do
            get :pick
          end
        end
        resources :flows do
          collection do
            get :pick
          end
        end
      end

      initializer "decidim_spam_signal.admin_mount_routes" do
        Decidim::Core::Engine.routes do
          mount Decidim::SpamSignal::AdminEngine, at: "/admin/spam_signal", as: "decidim_admin_spam_signal"
        end
      end

      initializer "decidim_spam_signal.admin_settings_menu" do
        Decidim.menu :admin_settings_menu do |menu|
          menu.add_item :spam_signal,
                        I18n.t("menu.spam_signal", scope: "decidim.admin", default: "Spam Signal"),
                        decidim_admin_spam_signal.generals_path,
                        icon_name: "shield-line",
                        position: 1.8,
                        active: is_active_link?(decidim_admin_spam_signal.generals_path, :inclusive),
                        if: defined?(current_user) && current_user&.read_attribute("admin")
        end
      end

      def load_seed
        nil
      end
    end
  end
end

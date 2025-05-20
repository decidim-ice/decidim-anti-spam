# frozen_string_literal: true

module Decidim
  module SpamSignal
    module Admin
      class GeneralsController < Decidim::SpamSignal::Admin::ApplicationController
        include FormFactory
        include Decidim::Admin::Concerns::HasTabbedMenu

        helper Decidim::SpamSignal::Admin::SpamSignalHelper

        layout "decidim/admin/settings"

        add_breadcrumb_item_from_menu :admin_settings_menu

        def tab_menu_name = :admin_spam_signal_menu

        def show
          @conditions = Decidim::SpamSignal::Condition.all
        end
      end
    end
  end
end

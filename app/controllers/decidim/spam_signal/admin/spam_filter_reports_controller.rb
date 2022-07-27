module Decidim
  module SpamSignal
    module Admin
      class SpamFilterReportsController < Decidim::SpamSignal::Admin::ApplicationController
        helper Decidim::SpamSignal::Admin::SpamSignalHelper
        def index;
          @quarantine = quarantine_users.page(params[:page]).per(15)
        end

        private
        def quarantine_users
          Decidim::SpamSignal::BannedUser.quarantine_users.order(notified_at: :asc)
        end
      end
    end
  end
end
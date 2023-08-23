# frozen_string_literal: true

require "active_support/concern"

module Decidim
  module UserBlockedChecker
    extend ActiveSupport::Concern

    included do
      before_action :check_user_not_blocked
      around_action :store_request_metadata
    end

    def store_request_metadata
      Thread.current[:current_request] = ::ActiveSupport::HashWithIndifferentAccess.new(
        real_ip: request.ip || request.headers['X-Real-IP'],
        user_agent: request.headers['User-Agent'],
        xhr: request.xhr?,
        id: request.request_id,
        remote_ip: request.remote_ip,
        referrer: request.headers['Refer'],
        country: request.headers['X-GEO-COUNTRY-CODE']
      )
      yield
      ensure
        Thread.current[:current_request] = nil
    end

    def check_user_not_blocked
      check_user_block_status(current_user)
    end

    def check_user_block_status(user)
      if user.present? && user.blocked?
        sign_out user
        flash.delete(:notice)
        flash[:error] = t("decidim.account.blocked")
        root_path
      end
      if user.present? && user.access_locked?
        sign_out user
        flash.delete(:notice)
        flash[:error] = t("decidim.account.locked")
        root_path
      end
    end
  end
end

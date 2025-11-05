# frozen_string_literal: true

module Decidim
  module SpamSignal
    module Actions
      class ActionCommand < ApplicationCommand
        attr_reader :errors, :error_keys, :config, :suspicious_user, :justification, :admin_reporter, :reportable, :current_organization, :flow

        def initialize(
          errors:,
          suspicious_user:,
          **options
        )
          @errors = errors
          @error_keys = options[:error_keys]
          @reportable = options[:reportable] || suspicious_user
          @suspicious_user = suspicious_user
          @current_organization = options[:current_organization] || suspicious_user.organization
          @flow = options[:flow]
          @justification = options[:justification]
          @admin_reporter = options[:admin_reporter] || AntiSpamUser.get(@current_organization)
          @config = options
        end

        def self.i18n_key
          "decidim.spam_signal.actions.#{handler_name}"
        end

        def normalize_locale(locale)
          locale.to_s.gsub("-", "__")
        end

        def now_tag
          "\n[#{Time.zone.now.strftime("%d/%m/%Y %H:%M")}]"
        end
      end
    end
  end
end

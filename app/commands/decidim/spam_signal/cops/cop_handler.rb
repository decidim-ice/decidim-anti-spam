# frozen_string_literal: true

module Decidim
  module SpamSignal
    module Cops
      class CopHandler < ApplicationHandler
        attr_reader :errors, :suspicious_user, :justification, :admin_reporter

        def initialize(
          errors,
          suspicious_user,
          config,
          justification = nil,
          admin_reporter = nil
        )
          @errors = errors
          @suspicious_user = suspicious_user
          @config = config
          @justification = justification
          @admin_reporter = admin_reporter || CopBot.get(suspicious_user.organization)
        end
        
        def self.i18n_key
          "decidim.spam_signal.cops.#{handler_name}"
        end

        def config
          @cop_config ||= @config.for_cop(handler_name)
        end
      end
    end
  end
end

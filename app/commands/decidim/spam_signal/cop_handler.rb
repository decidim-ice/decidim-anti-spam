# frozen_string_literal: true

module Decidim
  module SpamSignal
      class CopHandler < SpamSignalHandler
        attr_reader :suspicious_user, :justification, :admin_reporter

        def initialize(suspicious_user, config, justification = nil, admin_reporter=nil)
          @suspicious_user = suspicious_user
          @config = config
          @justification = justification
          @admin_reporter = admin_reporter || SpamCopService.get(suspicious_user.organization)
        end

        def config
          @cop_config ||= @config.for_cop(handler_name)
        end
      end
  end
end

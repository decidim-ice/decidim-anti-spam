# frozen_string_literal: true

module Decidim
  module SpamSignal
    class AntiSpamAction < Decidim::Command
      attr_reader :flow, :active_conditions, :errors, :current_organization, :suspicious_user, :suspicious_content, :error_keys

      def initialize(flow, options)
        @flow = flow
        @errors = options[:errors]
        @suspicious_user = options[:suspicious_user]
        @suspicious_content = options[:suspicious_content]
        @active_conditions = options[:active_conditions]
        @error_keys = options[:error_keys]
        @current_organization = options[:current_organization]
      end

      def call
        # Check available_actions of the flow,
        # and call them with the action_settings
        return if flow.available_actions.empty?

        flow.available_actions.each do |action_name|
          action = Decidim::SpamSignal.config.actions_registry.command_for(action_name)
          action.call(
            errors:,
            suspicious_user:,
            error_keys:,
            current_organization:,
            # Merge all the actions settings in one hash
            **{}.merge(*flow.action_settings)
          )
        end
        ::Decidim::SpamSignal.spam_actions_performed.push(*flow.available_actions)
      end
    end
  end
end

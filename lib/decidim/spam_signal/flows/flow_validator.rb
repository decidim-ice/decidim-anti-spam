# frozen_string_literal: true

module Decidim
  module SpamSignal
    module Flows
      ##
      # Common logics for all the validators
      # This module is included in validators we want to trigger,
      # for example, insert in User to validate the user profile update.
      module FlowValidator
        extend ActiveSupport::Concern
        included do
          validate :detect_spam!

          def detect_spam!
            return if skip_antispam?

            return if flows.empty?

            flows.each do |flow|
              active_conditions = run_conditions(flow.conditions, content_for_antispam)

              next if active_conditions.empty?

              before_antispam
              Decidim::SpamSignal::AntiSpamAction.call(
                flow,
                active_conditions:,
                errors:,
                suspicious_user:,
                suspicious_content: content_for_antispam,
                error_keys: spam_error_keys
              )
              after_antispam
            end
          end

          ##
          # Hooks to be implemented by the validator,
          # will be called if the flow is triggered.
          def before_antispam; end

          ##
          # Hook to be implemented by the validator,
          # will be called after the flow is triggered.
          def after_antispam; end

          ##
          # Class name of the trigger type.
          # For example, "Decidim::SpamSignal::Flows::CommentFlow"
          # We expect this class to define available_actions and available_conditions
          def antispam_trigger_type
            raise "#{self.class}#antispam_trigger_type not implemented"
          end

          ##
          # Current organization for the validator.
          # Exemple: the organization of the user or the organization of the comment.
          def current_organization
            raise "#{self.class}#current_organization not implemented"
          end

          ##
          # The user authot of the content we are validating.
          def suspicious_user
            raise "#{self.class}#suspicious_user not implemented"
          end

          ##
          # The error key to be used for the spam action.
          # Exemple: "body" for the comment body.
          # @see https://guides.rubyonrails.org/active_record_validations.html
          # @see https://www.rubydoc.info/gems/activerecord/2.3.9/ActiveRecord/Errors
          def spam_error_keys
            raise "#{self.class}#spam_error_keys not implemented"
          end

          ##
          # Text content to be validated.
          # Exemple: the body of the comment.
          # @see Decidim::SpamSignal::Extractors::CommentExtractor
          def content_for_antispam
            raise "#{self.class}#content_for_antispam not implemented"
          end

          ##
          # Model instance that can be reported.
          # Exemple: the comment.
          # @see https://github.com/decidim/decidim/blob/develop/decidim-core/lib/decidim/reportable.rb
          def reportable_content
            raise "#{self.class}#reportable_content not implemented"
          end

          ##
          # Whether we should skip the flow.
          # Exemple: if the flow should be triggered only on content updates
          # To be implemented by the validator.
          def skip_antispam?
            raise "#{self.class}#skip_antispam? not implemented"
          end

          private

          ##
          # Flows for the current_organization and trigger type.
          # @see Decidim::SpamSignal::Flow
          def flows
            @flows ||= Decidim::SpamSignal::Flow.where(
              trigger_type: antispam_trigger_type,
              organization: current_organization
            ).joins(:conditions)
          end

          ##
          # Run the conditions and return the active conditions.
          # @see Decidim::SpamSignal::FlowCondition
          def run_conditions(conditions, tested_content)
            active_conditions = conditions.map do |condition|
              result = condition.command.call(
                tested_content,
                condition.settings,
                current_organization:,
                suspicious_user:
              )
              (result || {}).keys.filter { |s| s != :ok && s != :valid }
            end
            active_conditions.flatten
          end
        end
      end
    end
  end
end

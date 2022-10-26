# frozen_string_literal: true

module Decidim
  module SpamSignal
    module Admin
      class UpdateRuleCommand < Rectify::Command
        attr_reader :form,
                    :current_config,
                    :settings_repo,
                    :id

        def initialize(config, settings_repo, form, id)
          @current_config = config
          @settings_repo = settings_repo
          @form = form
          @id = id
          raise ArgumentError, "missing current_config" unless current_config
          raise ArgumentError, "missing settings_repo" unless settings_repo
        end

        def call
          return broadcast(:invalid) if form.invalid?
          begin
            rule = {}
            rule["#{id}"] = attributes
            rule["#{id}"]["handler_name"] = form.handler_name
            settings_repo.set_rule(rule)
            current_config.save_settings
            broadcast(:ok, settings_repo)
          rescue StandardError => e
            broadcast(:invalid, e.message)
          end
        end

        private

          def form_blank?(form)
            return true if form.nil?
            attributes.blank?
          end
          def attributes
            form.attributes.filter { |_i, v| v.present? }.stringify_keys!
          end
      end
    end
  end
end

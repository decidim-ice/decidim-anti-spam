# frozen_string_literal: true

module Decidim
  module SpamSignal
    module Admin
      class UpdateCopCommand < Decidim::SpamSignal::Command
        attr_reader :form,
                    :current_config,
                    :settings_repo

        def initialize(config, settings_repo, form)
          @current_config = config
          @settings_repo = settings_repo
          @form = form
          raise ArgumentError, "missing current_config" unless current_config
          raise ArgumentError, "missing settings_repo" unless settings_repo
        end

        def call
          return broadcast(:invalid) if form.invalid?

          begin
            settings_repo.update_cop_attribute(
              { **attributes, "handler_name" => form.handler_name, "type" => form.context.type }
            )
            current_config.save_settings
            broadcast(:ok, settings_repo)
          rescue StandardError => e
            broadcast(:invalid, e.message)
          end
        end

        private

        def attributes
          return {} unless form

          form.attributes.stringify_keys!
        end
      end
    end
  end
end

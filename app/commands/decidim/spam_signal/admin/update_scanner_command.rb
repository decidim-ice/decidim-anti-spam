# frozen_string_literal: true

module Decidim
  module SpamSignal
    module Admin
      class UpdateScannerCommand < Rectify::Command
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
          return broadcast(:invalid) if attributes.blank?

          begin
            settings_repo.set_scan(
              form.handler_name,
              attributes
            )
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
            form.attributes.stringify_keys!
          end
      end
    end
  end
end

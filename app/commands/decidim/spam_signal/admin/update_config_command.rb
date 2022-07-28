# frozen_string_literal: true

module Decidim
  module SpamSignal
    module Admin
      class UpdateConfigCommand < Rectify::Command
        def initialize(form)
          @form = form
        end

        def call
          return broadcast(:invalid) if form.invalid?
          return broadcast(:invalid) if attributes.blank?

          begin
            @config = Config.get_config.update(
              attributes
            )
            broadcast(:ok, @config)
          rescue StandardError => e
            broadcast(:invalid, e.message)
          end
        end

        private

          attr_reader :form, :constraint

          def attributes
            form.attributes.filter { |_i, v| v.present? }
          end
      end
    end
  end
end

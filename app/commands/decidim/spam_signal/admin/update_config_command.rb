# frozen_string_literal: true

module Decidim
  module SpamSignal
    module Admin
      class UpdateConfigCommand < Rectify::Command
        attr_reader :form,
                    :scanner_form,
                    :cop_form,
                    :current_config,
                    :current_form

        def initialize(form, scanner_forms, cop_forms)
          @form = form
          raise ArgumentError, "scanner_forms.length > 1" if scanner_forms.length > 1
          raise ArgumentError, "cop_forms.length > 1" if cop_forms.length > 1
          @scanner_form = scanner_forms.first
          @cop_form = cop_forms.first
        end

        def call
          return broadcast(:invalid) if current_form.invalid?
          return broadcast(:invalid) if attributes.blank?

          begin
            current_config.update(
              form_attributes
            )
            broadcast(:ok, current_config)
          rescue StandardError => e
            broadcast(:invalid, e.message)
          end
        end

        private
          def current_config
            @config ||= Config.get_config(current_organization)
          end

          def find_form
            return form unless form_blank?(form)
            return scanner_form unless form_blank?(scanner_form)
            return cop_form unless form_blank?(cop_form)
            raise Error, "nothing submitted"
          end

          def current_form
            @current_form ||= find_form
          end

          def form_attributes
            return attributes unless form_blank?(form)
            return { scan_settings: new_scan_settings } unless form_blank?(scanner_form)
            return { cops_settings: new_cop_settings } unless form_blank?(cop_form)
            attributes
          end
          def new_scan_settings
            settings = current_config.scan_settings
            settings[current_form.handler_name.to_sym] = attributes
            settings
          end
          def new_cop_settings
            settings = current_config.cops_settings
            settings[current_form.handler_name.to_sym] = attributes
            settings
          end
          def form_blank?(form)
            form.attributes.filter { |_i, v| v.present? }.blank?
          end
          def attributes
            current_form.attributes.filter { |_i, v| v.present? }
          end
      end
    end
  end
end

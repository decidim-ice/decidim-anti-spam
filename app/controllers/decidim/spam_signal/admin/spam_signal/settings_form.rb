# frozen_string_literal: true

module Decidim
  module SpamSignal
    module SettingsForm
      extend ActiveSupport::Concern

      included do
        def form_attributes
          attributes.except(:id).keys
        end

        def handler_name
          context.handler_name
        end
        def model_name
          ActiveModel::Name.new(self, Decidim::SpamSignal, handler_name)
        end
      end
    end
  end
end

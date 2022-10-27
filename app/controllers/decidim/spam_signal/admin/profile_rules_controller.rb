# frozen_string_literal: true

module Decidim
  module SpamSignal
    module Admin
      class ProfileRulesController < ApplicationRulesController
        def resource_config
          current_config.profiles
        end
      end
    end
  end
end

# frozen_string_literal: true

module Decidim
  module SpamSignal
    module Admin
      class CommentRulesController < ApplicationRulesController
        def resource_config
          current_config.comments
        end
      end
    end
  end
end

# frozen_string_literal: true

module Decidim
  module SpamSignal
    module Admin
      class RemoveCopCommand < Decidim::SpamSignal::Command
        attr_reader :key,
                    :current_config,
                    :settings_repo

        def initialize(config, settings_repo, key)
          @current_config = config
          @settings_repo = settings_repo
          @key = key
          raise ArgumentError, "missing current_config" unless current_config
          raise ArgumentError, "missing settings_repo" unless settings_repo
        end

        def call
          settings_repo.rm_cop(key)
          current_config.save_settings
          broadcast(:ok, settings_repo)
        rescue StandardError => e
          broadcast(:invalid, e.message)
        end
      end
    end
  end
end

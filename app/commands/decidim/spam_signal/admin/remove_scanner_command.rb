# frozen_string_literal: true

module Decidim
  module SpamSignal
    module Admin
      class RemoveScannerCommand < Rectify::Command
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
          begin
            settings_repo.rm_scan(key)
            current_config.save_settings
            broadcast(:ok, settings_repo)
          rescue StandardError => e
            broadcast(:invalid, e.message)
          end
        end
      end
    end
  end
end

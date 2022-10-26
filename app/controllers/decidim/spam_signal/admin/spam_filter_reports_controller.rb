# frozen_string_literal: true

module Decidim
  module SpamSignal
    module Admin
      class SpamFilterReportsController < Decidim::SpamSignal::Admin::ApplicationController
        include FormFactory
        helper Decidim::SpamSignal::Admin::SpamSignalHelper
        before_action :get_config
        attr_reader :current_config
        helper_method :available_scanners

        def index
          @comment_settings = current_config.comments
          @profile_settings = current_config.profiles
        end

        private
          def available_scanners(repo_name)
            repo = current_config.comments if repo_name == "comments"
            repo = current_config.profiles if repo_name == "profiles"
            available_scanner_names(repo).map do |scan|
              scan_repository.strategy scan
            end
          end

          def available_scanner_names(repo)
            scan_repository.strategies.select { |scan| !repo.scans.include?("#{scan}") }
          end

          def scan_repository
            Decidim::SpamSignal::Scans::ScansRepository.instance
          end

          def get_config
            @current_config = Decidim::SpamSignal::Config.get_config(current_organization)
          end
      end
    end
  end
end

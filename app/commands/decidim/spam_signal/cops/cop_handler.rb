# frozen_string_literal: true

module Decidim
  module SpamSignal
    module Cops
      class CopHandler < ApplicationHandler
        attr_reader :errors, :error_key, :suspicious_user, :justification, :admin_reporter, :config, :reportable, :current_organization

        def initialize(
          errors:,
          error_key: :base,
          suspicious_user:,
          config:,
          reportable: nil,
          justification: nil,
          admin_reporter: nil
        )
          @errors = errors
          @error_key = error_key
          @reportable = reportable || suspicious_user
          @suspicious_user = suspicious_user
          @current_organization = suspicious_user.organization

          @config = config
          @justification = justification
          @admin_reporter = admin_reporter || CopBot.get(suspicious_user.organization)
        end

        def self.i18n_key
          "decidim.spam_signal.cops.#{handler_name}"
        end
        def now_tag
          "\n[#{DateTime.now.strftime("%d/%m/%Y %H:%M")}]"
        end
        def sinalize!(send_emails=true)
          is_user_reported = reportable == suspicious_user
          if is_user_reported
            moderation = Decidim::UserModeration.find_or_create_by!(user: suspicious_user) do |moderation|
              moderation.report_count = 0
            end
          else
            moderation = Decidim::Moderation.find_or_create_by!(reportable: reportable, participatory_space: reportable.participatory_space) do |moderation|
              moderation.report_count = 0
            end
          end
          is_new = moderation.report_count == 0
          moderation.update(report_count: moderation.report_count + 1)
          if is_user_reported
            user_report = Decidim::UserReport.find_or_create_by!(moderation: moderation)  do |report|
              report.moderation = moderation
              report.user = admin_reporter
              report.reason = "spam"
              report.details = "#{now_tag}#{justification}"
            end
          else
            user_report = Decidim::Report.find_or_create_by!(moderation: moderation)  do |report|
              report.moderation = moderation
              report.user = admin_reporter
              report.reason = "spam"
              report.details = "#{now_tag}#{justification}"
            end
          end
          # append the new bad things (to have a log).
          user_report.update(details: "#{user_report.details}#{now_tag} #{justification}") unless is_new
          admin_accountable = Decidim::User.where(admin: true, email: ENV.fetch("ANTISPAM_ADMIN", "")).first
          email_list = admin_accountable ? [admin_accountable] : current_organization.admins
          email_list.each do |admin| 
            Decidim::UserReportJob.perform_later(admin, admin_reporter, "spam", reportable)
          end if send_emails
        end

      end
    end
  end
end

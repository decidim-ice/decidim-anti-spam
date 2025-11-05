# frozen_string_literal: true

module Decidim
  module SpamSignal
    module Actions
      class ReportUserActionCommand < ActionCommand
        def call
          return unless config["report_user_enabled"]

          report_user!
          broadcast(:done)
        end

        private

        def report_user!
          @moderation = user_reported? ? create_user_moderation : create_moderation

          @moderation.update(report_count: @moderation.report_count + 1)

          user_report = user_reported? ? create_user_report : create_report

          return unless config["report_user_send_emails_enabled"]

          admin_accountable = Decidim::User.find_by(
            admin: true,
            email: config["report_user_send_email_to"]
          )

          Decidim::UserReportJob.perform_later(admin_accountable, user_report)
        end

        def user_reported?
          reportable == suspicious_user
        end

        def create_user_moderation
          Decidim::UserModeration.find_or_create_by!(user: suspicious_user) do |new_moderation|
            new_moderation.report_count = 0
          end
        end

        def create_moderation
          Decidim::Moderation.find_or_create_by!(reportable:, participatory_space: reportable.participatory_space) do |new_moderation|
            new_moderation.report_count = 0
          end
        end

        def create_user_report
          user_report = Decidim::UserReport.find_or_create_by!(moderation: @moderation) do |new_report|
            new_report.moderation = @moderation
            new_report.user = admin_reporter
            new_report.reason = "spam"
            new_report.details = "#{now_tag} #{justification}"
          end
          user_report.user_report_flows.create!(flow:)

          user_report
        end

        def create_report
          report = Decidim::Report.find_or_create_by!(moderation: @moderation) do |new_report|
            new_report.moderation = @moderation
            new_report.user = admin_reporter
            new_report.reason = "spam"
            new_report.details = "#{now_tag} #{justification}"
          end
          # append the new bad things (to have a log).
          report.update(details: "#{user_report.details}#{now_tag} #{justification}")

          report
        end

        def current_locale
          @current_locale ||= suspicious_user.locale || current_organization.default_locale
        end

        def justification
          @justification ||= begin
            user_defined = config["report_user_justification_#{normalize_locale(current_locale)}"]
            (user_defined.presence || I18n.t("decidim.spam_signal.report.default_justification"))
          end
        end
      end
    end
  end
end

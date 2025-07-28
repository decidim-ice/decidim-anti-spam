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

        def current_locale
          @current_locale ||= suspicious_user.locale || current_organization.default_locale
        end

        def justification
          @justification ||= begin
            user_defined = config["report_user_justification_#{normalize_locale(current_locale)}"]
            (user_defined.presence || I18n.t("decidim.spam_signal.report.default_justification"))
          end
        end

        def report_user!
          is_user_reported = reportable == suspicious_user
          moderation = if is_user_reported
                         Decidim::UserModeration.find_or_create_by!(user: suspicious_user) do |new_moderation|
                           new_moderation.report_count = 0
                         end
                       else
                         Decidim::Moderation.find_or_create_by!(reportable:, participatory_space: reportable.participatory_space) do |new_moderation|
                           new_moderation.report_count = 0
                         end
                       end
          is_new = moderation.report_count.zero?
          moderation.update(report_count: moderation.report_count + 1)
          return if Decidim::UserReport.exists?(moderation:, reason: "spam")

          user_report = if is_user_reported
                          Decidim::UserReport.find_or_create_by!(moderation:) do |new_report|
                            new_report.moderation = moderation
                            new_report.user = admin_reporter
                            new_report.reason = "spam"
                            new_report.details = "#{now_tag} #{justification}"
                          end
                        else
                          Decidim::Report.find_or_create_by!(moderation:) do |new_report|
                            new_report.moderation = moderation
                            new_report.user = admin_reporter
                            new_report.reason = "spam"
                            new_report.details = "#{now_tag}#{justification}"
                          end
                        end
          # append the new bad things (to have a log).
          user_report.update(details: "#{user_report.details}#{now_tag} #{justification}") unless is_new
          return unless config["report_user_send_emails_enabled"]

          admin_accountable = Decidim::User.find_by(
            admin: true,
            email: config["report_user_send_email_to"]
          )

          Decidim::UserReportJob.perform_later(admin_accountable, user_report)
        end
      end
    end
  end
end

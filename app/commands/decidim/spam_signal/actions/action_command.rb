# frozen_string_literal: true

module Decidim
  module SpamSignal
    module Actions
      class ActionCommand < ApplicationCommand
        attr_reader :errors, :error_keys, :config, :suspicious_user, :justification, :admin_reporter, :reportable, :current_organization

        def initialize(
          errors:,
          suspicious_user:,
          **options
        )
          @errors = errors
          @error_keys = options[:error_keys]
          @reportable = options[:reportable] || suspicious_user
          @suspicious_user = suspicious_user
          @current_organization = suspicious_user.organization

          @justification = options[:justification]
          @admin_reporter = options[:admin_reporter] || AntiSpamUser.get(suspicious_user.organization)
          @config = options
        end

        def self.i18n_key
          "decidim.spam_signal.actions.#{handler_name}"
        end

        def now_tag
          "\n[#{Time.zone.now.strftime("%d/%m/%Y %H:%M")}]"
        end

        def report_user!(send_emails: true)
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
          user_report = if is_user_reported
                          Decidim::UserReport.find_or_create_by!(moderation:) do |new_report|
                            new_report.moderation = moderation
                            new_report.user = admin_reporter
                            new_report.reason = "spam"
                            new_report.details = "#{now_tag}#{justification}"
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
          return unless send_emails

          admin_accountable = Decidim::User.find_by(admin: true, email: ENV.fetch("ANTISPAM_ADMIN", "antispam@example.org"))
          # adapt for version 0.27
          if Decidim.version.to_f >= 0.27
            Decidim::UserReportJob.perform_later(admin_accountable, user_report)
          else
            Decidim::UserReportJob.perform_later(admin_accountable, admin_reporter, "spam", reportable)
          end
        end
      end
    end
  end
end

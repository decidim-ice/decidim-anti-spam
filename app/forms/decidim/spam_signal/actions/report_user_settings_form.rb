# frozen_string_literal: true

module Decidim
  module SpamSignal
    module Actions
      class ReportUserSettingsForm < Decidim::Form
        include Decidim::SpamSignal::SettingsForm

        attribute :report_user_enabled, Boolean, default: true
        translatable_attribute :report_user_justification, String

        attribute :report_user_send_emails_enabled, Boolean, default: true
        attribute :report_user_send_email_to, String
        validate :email_present_if_enabled
        validate :email_must_be_admin

        add_conditional_display(:report_user_justification, :report_user_enabled)
        add_conditional_display(:report_user_send_email_to, :report_user_send_emails_enabled)

        private

        def email_present_if_enabled
          errors.add(:report_user_send_email_to, :blank) if report_user_send_emails_enabled && report_user_send_email_to.blank?
        end

        def email_must_be_admin
          return if !report_user_send_emails_enabled || report_user_send_email_to.blank?

          errors.add(:report_user_send_email_to, :must_be_admin) unless Decidim::User.find_by(admin: true, email: report_user_send_email_to)
        end
      end
    end
  end
end

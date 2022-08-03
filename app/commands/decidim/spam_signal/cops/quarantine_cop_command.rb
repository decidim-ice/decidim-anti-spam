# frozen_string_literal: true

module Decidim
  module SpamSignal
    module Cops
      class QuarantineCopCommand < CopHandler
        def self.form
          QuarantineSettingsForm
        end

        def call
          sinalize!
          block!
          quarantine!
          broadcast(:ok)
        end

        private
          def sinalize!
            moderation = Decidim::UserModeration.find_or_create_by!(user: suspicious_user)
            Decidim::UserReport.find_or_create_by!(moderation: moderation)  do |report|
              report.moderation = moderation
              report.user = admin_reporter
              report.reason = "spam"
              report.details = I18n.t("decidim.spam_signal.spam_signal_justification")
            end
            suspicious_comments.each do |comment|
              moderation = Decidim::Moderation.find_or_create_by!(reportable: comment) do |moderation|
                moderation.participatory_space = comment.component.participatory_space
                moderation.report_count = 1
              end
              Decidim::Report.find_or_create_by!(moderation: moderation) do |report|
                report.moderation = moderation
                report.user = admin_reporter
                report.reason = "spam"
                report.details = I18n.t("decidim.spam_signal.spam_signal_justification")
              end
            end
          end

          def block!
            # Block the User
            Decidim::Admin::BlockUser.call(
              Decidim::Admin::BlockUserForm.from_params({
                justification: I18n.t("decidim.spam_signal.spam_block_justification"),
                user_id: suspicious_user.id
              }).with_context(
                current_organization: suspicious_user.organization,
                current_user: admin_reporter
              )
            )
            # Block the comment he posted
            suspicious_comments.each do |spam|
              Decidim::Admin::HideResource.call(spam, admin_reporter)
            end
        end

          def quarantine!
            Decidim::SpamSignal::BannedUser.create!(
              removed_at: nil,
              notified_at: Time.current,
              banned_user: suspicious_user,
              admin_reporter: admin_reporter,
              justification: justification
            )
          end

          def suspicious_comments
            @suspicious_comments ||= Decidim::Comments::Comment.where(author: suspicious_user)
          end
      end
    end
  end
end
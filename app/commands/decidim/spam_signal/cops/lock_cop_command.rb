# frozen_string_literal: true

module Decidim
  module SpamSignal
    module Cops
      class LockCopCommand < CopHandler
        def self.form
          ::Decidim::SpamSignal::Cops::LockSettingsForm
        end

        def call
          errors.add(
            error_key,
            I18n.t("errors.spam",
              scope: "decidim.spam_signal",
              default: "this looks like spam."
            )
          ) unless config['forbid_creation_enabled']
          unless suspicious_user.access_locked?
            hide_comment! if config["hide_comments_enabled"]
            sinalize! if config["sinalize_user_enabled"]
            lock!
          end
          broadcast(config['forbid_creation_enabled'] ? :restore_value : :save)
        end

        private
          def hide_comment!
            suspicious_comments = Decidim::Comments::Comment.where(author: suspicious_user)
            suspicious_comments.each do |spam|
              moderation = Decidim::Moderation.find_or_create_by!(
                reportable: spam,
                participatory_space: spam.participatory_space
              )
              is_new = moderation.report_count == 0
              moderation.update(reported_content: spam.body[admin_reporter.locale]) if !moderation.reported_content && spam.body[admin_reporter.locale]
              report = Decidim::Report.find_or_create_by!(
                moderation: moderation.reload,
                user: admin_reporter) do |report|
                  report.locale = admin_reporter.locale
                  report.reason = "spam"
                  report.details = "#{now_tag}cascade: #{spam}"
              end
              report.update(details: "#{report.details}#{now_tag}cascade: #{spam}")unless is_new
              moderation.update!(report_count: moderation.report_count + 1, hidden_at: Time.current)
            end
          end

          def lock!
            suspicious_user.lock_access!(
              send_instructions: true
            )
            suspicious_user.save!(validate: false)
          end
      end
    end
  end
end

# frozen_string_literal: true

module Decidim
  module SpamSignal
    class CopBot
      def self.get(organization)
        user_bot = Decidim::User.find_or_create_by!(
          nickname: "bot"
        ) do |usr|
          usr.name = "bot"
          usr.email = ENV.fetch("USER_BOT_EMAIL", "bot@example.org")
          usr.password = usr.password_confirmation = ::Devise.friendly_token
          usr.organization = organization
          usr.confirmed_at = ::Time.current
          usr.locale = ::I18n.default_locale
          usr.admin = true

          usr.tos_agreement = true
          usr.personal_url = ""
          usr.about = ""
          usr.accepted_tos_version = organization.tos_version
          usr.admin_terms_accepted_at = ::Time.current
        end
        user_bot.update(
          blocked: false,
          email: ENV.fetch("USER_BOT_EMAIL", "bot@example.org"),
          confirmed_at: ::Time.current,
          admin: true,
          accepted_tos_version: organization.tos_version,
          admin_terms_accepted_at: ::Time.current
        )
        user_bot
      end
    end
  end
end

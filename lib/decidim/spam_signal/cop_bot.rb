# frozen_string_literal: true

module Decidim
  module SpamSignal
    class CopBot
      def self.get(organization)
        suffixe = Decidim::User.where(nickname: "bot").count
        user_bot = Decidim::User.find_or_create_by!(
          email: ENV.fetch("USER_BOT_EMAIL", "bot@decidim.org")
        ) do |usr|
          usr.name = "bot"
          usr.nickname = "bot#{suffixe if suffixe > 0}"
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
          admin: true,
          accepted_tos_version: organization.tos_version,
          admin_terms_accepted_at: ::Time.current
        )
        user_bot
      end
    end
  end
end

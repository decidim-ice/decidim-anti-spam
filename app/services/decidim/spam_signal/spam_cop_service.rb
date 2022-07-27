# frozen_string_literal: true

module Decidim
  module SpamSignal
    module SpamCopService

      def get
        user_bot = Decidim::User.find_or_create_by_email(email: user_bot_email) do |usr|
          usr.name = "bot",
          usr.nickname = "bot",
          usr.password = usr.password_confirmation = Devise.friendly_token
          usr.organization = organization,
          usr.confirmed_at = Time.current,
          usr.locale = I18n.default_locale,
          admin = false
        end

        user_bot.update(blocked: false) if user_bot.blocked?
        user_bot
      end

      private

        def user_bot_email
          raise "USER_BOT_EMAIL env not setted" unless ENV.fetch("USER_BOT_EMAIL", nil)
        end
    end
  end
end

require 'uri'

module Decidim
  module SpamSignal
    class AppSpamSignal

      attr_reader :user_bot_email, :uncheckable_email_domain
      attr_accessor :user_bot, :organization, :regex, :reports, :moderation

      def initializer
        user_bot_email = ENV.fetch("USER_BOT_EMAIL", nil)
        uncheckable_email_domain = ENV.fetch("UNCHECKABLE_EMAIL_DOMAIN", nil)
      end

      def run!
        user_bot = take_or_create_user_bot
        regex = /#{take_regex}/i

        Decidim::UserModeration.unblocked.where(decidim_users: {email: users_to_check}).includes(:reports).where("decidim_reports.moderation_id": nil).each do |moderation|
          user = moderation.user
          # do your checks
         end
        
        users_to_check.each do |user|
          unless user_signaled?(user) || user.blocked?
            signal_spammer(user) if user_about_uri?(user) && user_about_text?(user)
          end
        end
      end

      private 
        def take_or_create_user_bot
            
          user_bot = Decidim::User.find_or_create_by_email(email: user_bot_email) do |usr|
            usr.name = 'bot',
            usr.nickname = 'bot',
            usr.password = usr.password_confirmation = Devise.friendly_token
            usr.organization = organization,
            usr.confirmed_at = Time.current,
            usr.locale = I18n.default_locale,
            admin = false
          end

          user_bot.update(blocked: false) if user_bot.blocked?
          user_bot
          
        end

        def organization
          Decidim::Organization.first!
        end

        def take_regex
          Regexp.union(regex_string)
        end
        
        def regex_string
          
          [ "seo", "sex", "escort", "mmda", "$$$", "#1", "0%", "99.9%", "100%", "50% OFF", 
            "Access for free", "Access now", "Access right away", 
            "Act now", "Apply NOW", "Apply Online", "Buy Now", 
            "Buy direct", "Cancel at any time", "Make Money", "Best offer", 
            "Best price", "Earn $", "Earn extra cash", "Free investment", 
            "JACKPOT", "Lose weight", "Lose weight instantly", "Recover your debt", 
            "Unlimited", "You will not believe your eyes", "Zero percent", "Affordable",
            "Cheap", "Confidential", "Viagra", "Valium", "VIP", "babes", "Rolex", 
            "Marketing", "Meet women", "Mortgage", "Miracle", "Meet singles", "porn", 
            "Stock alert", "Call Girl", "Sexy", "Extra offering", "Call Service", "unlimited pleasure", ""
          ]
        
        end

        def users_to_check
          raise ArgumentError, "uncheckable_email_domain cannot be nil" if uncheckable_email_domain.nil?
          Decidim::User.where("email NOT LIKE ?", "%" + "#{uncheckable_email_domain}" + "%")
        end

        def user_signaled?(user)
          Decidim::UserModeration.find_by(decidim_user_id: user.id).present?
        end

        def user_about_uri?(user)
          user.about.match?(URI.regexp) unless user.about.nil?
        end

        def user_about_text?(user)
          user.about.match?(regex) unless user.about.nil?
        end

        def signal_spammer(user)
          moderation!(user)
          report!
          update_report_count!
          send_notification_to_admins!(user, 'spam')
        end

        def moderation!(user)
          Decidim::UserModeration.find_or_create_by!(user: user)
        end

        def report
          Decidim::UserReport.create!(
            moderation: moderation, 
            user: user_bot,
            reason: 'spam',
            details: 'Signeled by bot'
          )
        end

        def send_notification_to_admins!(user, reason)
          organization.admins.each do |admin|
            Decidim::UserReportJob.perform_later(admin, user_bot, reason, user)
          end
        end
    end
  end
end

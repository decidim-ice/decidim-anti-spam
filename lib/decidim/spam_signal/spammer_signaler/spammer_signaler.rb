require 'uri'

module Decidim
  module SpamSignal
    class AppSpamSignal

      def run!
        @user_bot_email = ENV.fetch("USER_BOT_EMAIL", nil)
        @uncheckable_email_domain = ENV.fetch("UNCHECKABLE_EMAIL_DOMAIN", nil)
        @user_bot = take_or_create_user_bot
        @regex = /#{take_regex}/i
        
        users_to_check.each do |user|
          unless user_signaled?(user) || user.blocked?
            signal_spammer(user) if user_about_uri?(user) && user_about_text?(user)
          end
        end
      end

      private 
        def take_or_create_user_bot
            
          raise "Organization doesn't exists" unless @organization = Decidim::Organization.first

          user_bot = Decidim::User.find_by(email: @user_bot_email) || Decidim::User.create!(
            email: @user_bot_email,
            name: 'bot',
            nickname: 'bot',
            password: 'changeme01',
            password_confirmation: 'changeme01',
            organization: organization,
            confirmed_at: Time.current,
            locale: I18n.default_locale,
            admin: true,
            tos_agreement: true,
            accepted_tos_version: organization.tos_version,
            admin_terms_accepted_at: Time.current
          )

          user_bot.update(:blocked => false) if user_bot.blocked?
          user_bot
          
        end

        def take_regex
          regex = Regexp.union(regex_string)
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
          raise ArgumentError, "uncheckable_email_domain cannot be nil" if @uncheckable_email_domain.nil?
          users_not_allowed = Decidim::User.where("email NOT LIKE ?", 
            Decidim::User.sanitize_sql_like("%" + "#{@unverifiable_email_domain}" + "%"))
        end

        def user_signaled?(user)
          user_signaled = Decidim::UserModeration.find_by(decidim_user_id: user.id).present?
        end

        def user_about_uri?(user)
          user.about.match?(URI.regexp) unless user.about.nil?
        end

        def user_about_text?(user)
          user.about.match?(@regex) unless user.about.nil?
        end

        def signal_spammer(user)
          find_or_create_moderation!(user)
          create_report!
          update_report_count!
          send_notification_to_admins!(user, 'spam')
        end

        def find_or_create_moderation!(user)
          @moderation = Decidim::UserModeration.find_or_create_by!(user: user)
        end

        def create_report!
          @report = Decidim::UserReport.create!(
            moderation: @moderation, 
            user: @user_bot,
            reason: 'spam',
            details: 'Signeled by bot'
          )
        end

        def update_report_count!
          @moderation.update!(report_count: @moderation.report_count + 1)
        end

        def send_notification_to_admins!(user, reason)
          @organization.admins.each do |admin|
            Decidim::UserReportJob.perform_now(admin, @user_bot, reason, user)
          end
        end
    end
  end
end

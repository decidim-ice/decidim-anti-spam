# frozen_string_literal: true

class CopbotEmail < ActiveRecord::Migration[5.2]
  def change
    # bot email should never be bot@decidim.org
    cop = Decidim::User.where(nickname: "bot").first
    if cop
      cop.email = ENV.fetch("USER_BOT_EMAIL", "bot@example.org")
      cop.skip_confirmation!
      cop.save
    end
    # Legacy fix, ensure no @decidim.org emails are present.
    Decidim::User.where(email: "bot@decidim.org").each do |legacy_bot|
      Decidim::UserReport.where(user: legacy_bot).update(user: cop)
      legacy_bot.destroy
    end
  end
end

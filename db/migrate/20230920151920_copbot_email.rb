# frozen_string_literal: true

class CopbotEmail < ActiveRecord::Migration[5.2]
  def change
    # bot email should never be bot@decidim.org
    cop = Decidim::User.where(nickname: "bot").first
    cop.update(email: ENV.fetch("USER_BOT_EMAIL", "bot@example.org"))
    Decidim::User.where(email: "bot@decidim.org").each |legacy_bot|
      legacy_bot.destroy
    end
  end
end

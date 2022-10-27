# frozen_string_literal: true

class AddJustificationToBannedUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :decidim_banned_users, :justification, :text
  end
end

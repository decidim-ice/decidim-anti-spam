class AddBannedUsersTable < ActiveRecord::Migration[5.2]
  def change
    create_table :decidim_banned_users do |t|
      t.references :banned_user, foreign_key: { to_table: :decidim_users }, null: false, index: true, index: { name: "decidim_banned_users_banned_user" }
      t.references :admin_reporter,foreign_key: { to_table: :decidim_users }, null: false, index: true, index: { name: "decidim_banned_users_admin_reporter" }
      t.datetime :notified_at
      t.datetime :removed_at

      t.timestamps
    end
  end
end

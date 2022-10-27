# frozen_string_literal: true

class DropQuarantine < ActiveRecord::Migration[5.2]
  def change
    drop_table :decidim_banned_users
  end
end

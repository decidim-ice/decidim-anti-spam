class CreateSpamSignalConfigTable < ActiveRecord::Migration[5.2]
  def change
    create_table :spam_signal_config_tables do |t|
      t.integer :decidim_organization_id,
                foreign_key: true,
                index: { name: "index_decidim_awesome_on_decidim_organization_id" }
      t.integer :days_before_delete
      t.boolean :validate_profile
      t.boolean :validate_comments
      t.text :stop_list_tlds
      t.text :stop_list_words
      t.timestamps
    end
  end
end

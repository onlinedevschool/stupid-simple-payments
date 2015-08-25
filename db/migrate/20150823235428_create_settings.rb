class CreateSettings < ActiveRecord::Migration
  def change
    create_table :settings do |t|
      t.string :branding_html
      t.boolean :stripe_test_mode, default: true
      t.string :stripe_test_secret_key
      t.string :stripe_test_publishable_key
      t.string :stripe_live_secret_key
      t.string :stripe_live_publishable_key

      t.timestamps null: false
    end
  end
end

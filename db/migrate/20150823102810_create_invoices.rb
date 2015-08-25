class CreateInvoices < ActiveRecord::Migration
  def change
    create_table :invoices do |t|
      t.string :email
      t.integer :minutes
      t.integer :rate
      t.text :notes

      t.timestamps null: false
    end
  end
end

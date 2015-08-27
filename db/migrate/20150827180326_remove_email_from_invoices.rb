class RemoveEmailFromInvoices < ActiveRecord::Migration
  def change
    remove_column :invoices, :email
  end
end

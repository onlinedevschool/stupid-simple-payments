class AddPayeeToInvoices < ActiveRecord::Migration
  def change
    add_column :invoices, :payee_id, :integer, index: true
    Invoice.all.each do |i|
      i.payee = Payee.find_or_create_by(email: i.email)
      i.save
    end
  end
end

class AddInvoicerToPayeesAndInvoices < ActiveRecord::Migration
  def change
    add_reference :invoices, :invoicer, index: true
    add_reference :payees, :invoicer, index: true
  end
end

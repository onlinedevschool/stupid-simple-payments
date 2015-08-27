class MigrateRecordsWithoutInvoicer < ActiveRecord::Migration
  def change
    Invoice.all.each do |i|
      i.update_attribute(:invoicer, Invoicer.first)
    end

    Payee.all.each do |p|
      p.update_attribute(:invoicer, Invoicer.first)
    end
  end
end

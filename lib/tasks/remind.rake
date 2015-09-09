desc "Remind overdue payees of late invoices"
task "send:reminders" => [:environment] do
  Invoice.unpaid.past_due_7_days.each do |invoice|
    InvoiceMailer.notify_payer(invoice).deliver
  end
end

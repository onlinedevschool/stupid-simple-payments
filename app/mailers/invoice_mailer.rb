class InvoiceMailer < ApplicationMailer
  include ActionView::Helpers::NumberHelper

  default from: 'invoices@onlinedevschool.com'

  def notify_payer(invoice)
    @payment_url = new_invoice_payment_url(invoice)
    mail to: invoice.email,
         subject: "You were invoiced for #{number_to_currency(invoice.amount)} @ ODS"
  end

  def notify_invoicer(invoice)
    @invoice = invoice
    mail to: "invoices@onlinedevschool.com",
         subject: "You just invoiced #{invoice.payee.name} for #{number_to_currency(invoice.amount)} @ ODS"
  end
end

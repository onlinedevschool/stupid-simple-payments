class ReceiptMailer < ApplicationMailer
  include ActionView::Helpers::NumberHelper

  default from: 'receipts@onlinedevschool.com'

  def notify_payer(payment)
    mail to: payment.invoice.email,
      subject: "You paid invoice ##{payment.invoice.id} for
                #{number_to_currency(payment.invoice.amount)} for ODS hourly"
  end

  def notify_invoicer(payment)
    @invoice = payment.invoice
    mail to: "invoices@onlinedevschool.com",
      subject: "#{payment.invoice.name} paid invoice ##{payment.invoice.id}
                for #{number_to_currency(payment.invoice.amount)} for ODS
                hourly"
  end
end

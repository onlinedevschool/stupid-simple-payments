class ReminderMailer < ApplicationMailer
  include ActionView::Helpers::NumberHelper

  default from: 'reminders@onlinedevschool.com'

  def notify_payer(invoice)
    @payment_url = new_invoice_payment_url(invoice)
    @invoice = invoice
    mail to: invoice.email,
      subject: "Your latest ODS invoice is past due."
  end
end

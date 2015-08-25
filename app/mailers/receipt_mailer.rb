class ReceiptMailer < ApplicationMailer
  include ActionView::Helpers::NumberHelper

  default from: 'receipts@onlinedevschool.com'

  def notify_payer(payment)
    mail to: payment.invoice.email,
         subject: "You were billed #{number_to_currency(payment.invoice.amount)} for ODS hourly"
  end
end

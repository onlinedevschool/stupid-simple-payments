class PaymentsController < ApplicationController

  def show
    payment
  end

  def new
    if payment.present?
      redirect_to [invoice, payment] and return
    end
    new_payment
  end

  def create
    Stripe.api_key = Setting.first.stripe_secret_key
    success = new_payment(payment_params).save
    if success
      new_payment.charge(payment_params[:stripe_token])
      send_emails(new_payment)
    end

    respond_to do |format|
      format.json do
        render json: new_payment.to_json, layout: nil
      end
    end
  end

private

  def invoice
    @invoice ||= Invoice.find(params[:invoice_id])
  end

  def payment
    @payment ||= invoice.payment
  end

  def new_payment(attrs={})
    @payment ||= invoice.build_payment(attrs)
  end

  def send_emails(payment)
    ReceiptMailer.notify_payer(payment).deliver
    ReceiptMailer.notify_invoicer(payment).deliver
  end

  def payment_params
    params.require(:payment).permit(:stripe_token)
  end
end

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
      ReceiptMailer.notify_payer(new_payment).deliver
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

  def payment_params
    params.require(:payment).permit(:stripe_token)
  end
end

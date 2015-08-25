class InvoicesController < ApplicationController
  before_action :authenticate_invoicer!

  def index
    invoices
  end

  def show
    invoice
  end

  def new
   new_invoice
  end

  def create
    if new_invoice(invoice_params).save
      InvoiceMailer.notify_payer(new_invoice).deliver
      redirect_to new_invoice, notice: 'Invoice was successfully created.'
    else
      render :new
    end
  end

private

  def invoices
    @invoices ||= if params.has_key?(:payee_id)
      Payee.find(params[:payee_id]).invoices
    else
      Invoice.search(params[:q])
    end
  end

  def invoice
    @invoice ||= Invoice.find(params[:id])
  end

  def new_invoice(attrs={})
    @invoice ||= Invoice.new(attrs)
  end

  def invoice_params
    params.require(:invoice).permit(:payee_id, :minutes, :rate, :notes)
  end
end

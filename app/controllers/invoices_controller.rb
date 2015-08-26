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
    session[:return_url] = request.path
  end

  def create
    if new_invoice(invoice_params).save
      send_emails(new_invoice)
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

  def send_emails(invoice)
    InvoiceMailer.notify_payer(invoice).deliver
    InvoiceMailer.notify_invoicer(invoice).deliver
  end

  def invoice_params
    params.require(:invoice).permit(:payee_id, :minutes, :rate, :notes)
  end
end

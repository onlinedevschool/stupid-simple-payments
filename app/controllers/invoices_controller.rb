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
      current_invoicer.payees.find(params[:payee_id]).invoices
    else
      current_invoicer.invoices.search(params[:q])
    end
  end

  def invoice
    @invoice ||= current_invoicer.invoices.find(params[:id])
  end

  def new_invoice(attrs={})
    @invoice ||= current_invoicer.invoices.new(attrs)
  end

  def send_emails(invoice)
    InvoiceMailer.notify_payer(invoice).deliver
    InvoiceMailer.notify_invoicer(invoice).deliver
  end

  def invoice_params
    params.require(:invoice).permit(:payee_id, :minutes, :rate, :notes)
  end
end

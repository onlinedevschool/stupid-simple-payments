class PayeesController < ApplicationController
  before_action :authenticate_invoicer!

  def index
    payees
  end

  def show
    payee
  end

  def new
   new_payee
  end

  def create
    if new_payee(payee_params).save
      redirect_to return_url_or(new_payee), notice: 'Payee was successfully created.'
    else
      render :new
    end
  end

private

  def payees
    @payees ||= Payee.recent
  end

  def payee
    @payee ||= Payee.find(params[:id])
  end

  def new_payee(attrs={})
    @payee ||= Payee.new(attrs)
  end

  def return_url_or(payee)
    if session[:return_url]
      session[:return_url] + "?yee
      payee_id=#{payee.id}"
    end
  end

  def payee_params
    params.require(:payee).permit(:email, :name)
  end
end

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :check_installation

private

  def check_installation
    if no_invoicers? && !on_setup_page?
      redirect_to :new_invoicer_registration and return
    end

    if no_settings? && !on_setup_page?
      redirect_to new_setting_path and return
    end
  end

  def no_invoicers?
    Invoicer.count == 0
  end

  def no_settings?
    Setting.count == 0
  end

  def on_setup_page?
    controller_name == "registrations" ||
      controller_name == "settings"
  end

end

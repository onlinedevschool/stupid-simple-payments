class RegistrationsController < Devise::RegistrationsController
  before_action :protect_installation

private

  def protect_installation
    redirect_to :unauthorized, if: :application_configured?
  end
end

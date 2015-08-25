class SettingsController < ApplicationController

  def new
    new_settings
  end

  def create
    if new_settings(settings_params).save
      redirect_to :authenticated_root
    else
      render :new
    end
  end

  def edit
    settings
  end

  def show
    settings
  end

  def update
    if settings.update(settings_params)
      redirect_to :authenticated_root
    else
      render :edit
    end
  end

private

  def settings
    @settings ||= Setting.first || new_settings
  end

  def new_settings(attrs={})
    @settings ||= Setting.new(attrs)
  end

  def settings_params
    params.require(:setting).permit(:stripe_test_secret_key, :stripe_test_publishable_key,
                                    :stripe_live_secret_key, :stripe_live_publishable_key,
                                    :stripe_test_mode, :branding_html)
  end
end

class Setting < ActiveRecord::Base

  with_options presence: true do |r|
    r.validates :stripe_test_secret_key
    r.validates :stripe_test_publishable_key
    r.validates :stripe_live_secret_key
    r.validates :stripe_live_publishable_key
  end

  def stripe_secret_key
    send "stripe_#{stripe_env}_secret_key"
  end

  def stripe_publishable_key
    send "stripe_#{stripe_env}_publishable_key"
  end

  def stripe_env
    stripe_test_mode? ? "test" : "live"
  end
end

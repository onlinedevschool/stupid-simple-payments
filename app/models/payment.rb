class Payment < ActiveRecord::Base
  belongs_to :invoice

  def created_on
    created_at.to_date.to_s(:short)
  end

  def charge(token)
    charge = Stripe::Charge.create(
      source: token,
      currency: 'usd',
      amount: (invoice.amount * 100).to_i,
      description: "ODS Hourly (onlinedevschool.com)"
    )
    update_attribute(:auth_code, charge.id)
  end
end

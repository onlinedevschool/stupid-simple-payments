class Invoice < ActiveRecord::Base
  belongs_to :payee
  belongs_to :invoicer

  has_one :payment, dependent: :destroy

  scope :recent, -> {
    order(created_at: :desc).limit(16)
  }

  scope :unpaid, -> {
    joins("LEFT OUTER JOIN payments ON payments.invoice_id = invoices.id").
      where("payments.invoice_id IS NULL")
  }

  scope :past_due_7_days, -> {
    unpaid.where("invoices.created_at < ?", 7.days.ago)
  }

  scope :search, ->(q) {
    return recent unless q
    recent.joins(:payee).
      where(get_sql(q))
  }

  with_options presence: true do |a|
    a.validates :payee_id
    a.validates :minutes, numericality: true
    a.validates :rate,    numericality: true
    a.validates :notes
  end

  def email
    payee && payee.email
  end

  def name
    payee && payee.name
  end

  def amount
    (minutes.to_f/60.to_f) * rate
  end

  def paid?
    payment && payment.auth_code.present?
  end

  def created_on
    created_at.to_date.to_s(:short)
  end

private

  def self.get_sql(val)
    begin
      Integer(val)
      return ["invoices.id = ? OR invoices.minutes/60 * invoices.rate = ?",
              val, val]
    rescue ArgumentError
      # wasnt an int :)
    end

    if date = Chronic.parse(val)
      ["invoices.created_at >= ? AND invoices.created_at <= ?",
       date - 1.day, date + 1.day]
    else
      ["payees.name ILIKE ? OR payees.email ILIKE ?",
        "%#{val}%", "%#{val}%"]
    end
  end

end

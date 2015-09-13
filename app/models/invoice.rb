class Invoice < ActiveRecord::Base
  belongs_to :payee
  belongs_to :invoicer

  has_one :payment, dependent: :destroy

  with_options presence: true do |a|
    a.validates :payee_id
    a.validates :minutes, numericality: true
    a.validates :rate,    numericality: true
    a.validates :notes
  end

  scope :with_amounts, -> {
    select("invoices.*, (invoices.rate * (invoices.minutes/60)) as amount")
  }

  scope :recent, -> {
    order(created_at: :desc).limit(16)
  }

  scope :paid, -> {
    joins("JOIN payments ON payments.invoice_id = invoices.id")
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

  scope :from_date, ->(date) {
    paid.where("payments.created_at > ?", date)
  }

  scope :this_year, -> {
    from = Date.today.beginning_of_year.beginning_of_month.beginning_of_day
    from_date(from)
  }

  scope :this_month, -> {
    from = Date.today.beginning_of_month.beginning_of_day
    from_date(from)
  }

  def self.ytd
    this_year.reduce(0) {|a, i| a + i.amount }
  end

  def self.mtd
    this_month.reduce(0) {|a, i| a + i.amount }
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

  def opened?
    msg = Ahoy::Message.find_by(user: self)
    msg.present? && msg.opened_at.present?
  end

  def unopened?
    !opened?
  end

  def status
    return :paid     if paid?
    return :unopened if unopened?
    :unpaid
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

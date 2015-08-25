class Payee < ActiveRecord::Base
  has_many :invoices, dependent: :destroy

  scope :recent, -> {
    joins(:invoices).order("invoices.created_at desc").
                     limit(16)
  }

  validates :name, presence: true
  validates :email, presence: true
  validates_format_of :email, with: Devise.email_regexp
end

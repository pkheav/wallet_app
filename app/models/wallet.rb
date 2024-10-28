class Wallet < ApplicationRecord
  belongs_to :owner, polymorphic: true
  has_many :credits, class_name: "Credit", foreign_key: "target_wallet_id"
  has_many :debits, class_name: "Debit", foreign_key: "source_wallet_id"

  validates :name, presence: true, length: { in: 1..30 }

  def balance
    Transactions::GetBalance.for_wallet(self)
  end
end

class Debit < Transaction
  validates :source_wallet_id, presence: true
  validates :amount, numericality: { less_than: 0 }
  validate :check_source_wallet_balance

  scope :for_wallet, ->(wallet) { where(source_wallet_id: wallet) }

  private

  def check_source_wallet_balance
    source_wallet_balance = Transactions::GetBalance.for_wallet(source_wallet_id)
    errors.add(:source_wallet, "has insufficient balance") if source_wallet_balance + amount < 0
  end
end

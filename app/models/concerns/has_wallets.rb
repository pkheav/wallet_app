module HasWallets
  extend ActiveSupport::Concern

  included do
    has_many :wallets, as: :owner
    has_many :credits, through: :wallets
    has_many :debits, through: :wallets
  end

  def transactions
    credits.or(debits)
  end

  def balance
    Transactions::GetBalance.for_owner(self)
  end
end

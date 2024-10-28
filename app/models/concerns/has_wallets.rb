module HasWallets
  extend ActiveSupport::Concern

  included do
    has_many :wallets, as: :owner
    has_many :credits, through: :wallets
    has_many :debits, through: :wallets
  end

  def transactions
    # TODO: this isn't ideal but working for the meantime
    Transaction.where(id: credits).or(Transaction.where(id: debits))
  end

  def balance
    Transactions::GetBalance.for_owner(self)
  end
end

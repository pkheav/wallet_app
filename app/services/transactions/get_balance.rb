class Transactions::GetBalance
  class << self
    # Can take both a single or collection of wallet_ids/wallets
    def for_wallet(wallet)
      credits = Credit.for_wallet(wallet)
      debits = Debit.for_wallet(wallet)
      new(credits, debits).call
    end

    def for_owner(owner)
      for_wallet(owner.wallets)
    end
  end

  attr_reader :credits, :debits

  def initialize(credits, debits)
    @credits = credits
    @debits = debits
  end

  def call
    credits.or(debits).sum(:amount).round(2)
  end
end

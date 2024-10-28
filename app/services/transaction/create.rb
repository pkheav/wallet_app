class Transaction::Create
  attr_reader :source_wallet_id, :target_wallet_id, :amount, :description

  def self.call!(source_wallet_id:, target_wallet_id:, amount:, description:)
    new(source_wallet_id:, target_wallet_id:, amount:, description:).call!
  end

  def initialize(source_wallet_id:, target_wallet_id:, amount:, description:)
    @source_wallet_id = source_wallet_id
    @target_wallet_id = target_wallet_id
    @amount = amount
    @description = description
  end

  def call!
    ActiveRecord::Base.transaction do
      if target_wallet_id
        Credit.create!(source_wallet_id:, target_wallet_id:, amount:, description:)
      end

      if source_wallet_id
        Debit.create!(source_wallet_id:, target_wallet_id:, amount: -amount, description:)
      end

      true
    end
  end

  private
end

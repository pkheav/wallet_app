class Credit < Transaction
  validates :target_wallet_id, presence: true
  validates :amount, numericality: { greater_than: 0 }

  scope :for_wallet, ->(wallet) { where(target_wallet_id: wallet) }
end

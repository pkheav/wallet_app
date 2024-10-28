class Transaction < ApplicationRecord
  belongs_to :source_wallet, class_name: "Wallet", optional: true
  belongs_to :target_wallet, class_name: "Wallet", optional: true



  
  validates :amount, presence: true, format: { with: /\A[-+]?\d+(?:\.\d{0,2})?\z/ }, numericality: { other_than: 0 }
  validates :description, length: { in: 2..255 }
end

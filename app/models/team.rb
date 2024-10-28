class Team < ApplicationRecord
  include HasWallets

  validates :name, presence: true, length: { in: 1..30 }
end

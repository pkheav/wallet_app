class User < ApplicationRecord
  include HasWallets

  has_secure_password

  validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: /\A[^@,\s]+@[^@,\s]+\.[^@,.\s]+\z/, message: "Invalid email" }
  validates :password, presence: true, length: { minimum: 8 }
end

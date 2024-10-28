# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
user1 = User.first || User.create!(email: 'test@gmail.com', password: 'password')
user1_wallet1, user1_wallet2 = user1.wallets.first(2)
user1_wallet1 ||= Wallet.create!(owner: user1, name: 'U1W1')
user1_wallet2 ||= Wallet.create!(owner: user1, name: 'U1W2')
Transaction::Create.call!(source_wallet_id: nil, target_wallet_id: user1_wallet1.id, amount: 9999.99, description: 'deposit')
Transaction::Create.call!(source_wallet_id: user1_wallet1.id, target_wallet_id: user1_wallet2.id, amount: 100.01, description: 'internal txn')

user2 = User.second || User.create!(email: 'test2@gmail.com', password: 'password')
user2_wallet1, user2_wallet2 = user2.wallets.first(2)
user2_wallet1 ||= Wallet.create!(owner: user2, name: 'U2W1')
user2_wallet2 ||= Wallet.create!(owner: user2, name: 'U2W2')
Transaction::Create.call!(source_wallet_id: user1_wallet1.id, target_wallet_id: user2_wallet2.id, amount: 200.01, description: 'external txn')

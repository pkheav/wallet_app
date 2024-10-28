require 'rails_helper'

describe Transactions::GetBalance do
  let!(:user1) { User.create!(email: 'test@gmail.com', password: '12345678') }
  let!(:user1_wallet1) { Wallet.create!(owner: user1, name: 'U1W1') }
  let!(:user1_wallet2) { Wallet.create!(owner: user1, name: 'U1W2') }

  describe '.for_wallet' do
    subject { described_class.for_wallet(user1_wallet1.id) }

    context 'when wallet has no transactions' do
      it { is_expected.to eq(0) }
    end

    context 'when wallet has an initial deposit' do
      let(:initial_deposit_amount) { 100.01 }

      before { Transaction::Create.call!(amount: initial_deposit_amount, description: 'Initial deposit', source_wallet_id: nil, target_wallet_id: user1_wallet1.id) }

      it { is_expected.to eq(initial_deposit_amount) }

      context 'when owner transfers money externally' do
        let!(:user2) { User.create!(email: 'test2@gmail.com', password: '12345678') }
        let!(:user2_wallet) { Wallet.create!(owner: user2, name: 'U2W') }

        before do
          Transaction::Create.call!(amount: 50.02, description: '50.02 from U1W1 to U2W', source_wallet_id: user1_wallet1.id,  target_wallet_id: user2_wallet.id)
        end

        it 'both wallet balances are updated' do
          expect(described_class.for_wallet(user1_wallet1)).to eq(49.99)
          expect(described_class.for_wallet(user2_wallet)).to eq(50.02)
        end
      end
    end
  end

  describe '.for_owner' do
    subject { described_class.for_owner(user1) }

    context 'when owner has no transactions' do
      it { is_expected.to eq(0) }
    end

    context 'when owner has transactions in multiple wallets' do
      before do
        Transaction::Create.call!(amount: 50, description: 'Wallet 1 initial deposit', source_wallet_id: nil, target_wallet_id: user1_wallet1.id)
        Transaction::Create.call!(amount: 70, description: 'Wallet 2 initial deposit', source_wallet_id: nil, target_wallet_id: user1_wallet2.id)
      end

      it { is_expected.to eq(120) }

      context 'when owner transfers money internally' do
        before do
          Transaction::Create.call!(amount: 69.99, description: 'Wallet 2 transfer to Wallet 1', source_wallet_id: user1_wallet2.id,  target_wallet_id: user1_wallet1.id)
        end

        it 'overall balance is the same but wallets are updated' do
          is_expected.to eq(120)
          expect(described_class.for_wallet(user1_wallet1)).to eq(119.99)
          expect(described_class.for_wallet(user1_wallet2)).to eq(0.01)
        end
      end
    end
  end
end

require 'rails_helper'

describe Transaction::Create do
  let!(:owner) { User.create!(email: 'test@gmail.com', password: '12345678') }
  let!(:owner1_wallet1) { Wallet.create!(owner:, name: 'U1W1') }
  let!(:owner1_wallet2) { Wallet.create!(owner:, name: 'U1W2') }

  describe '.call!' do
    context 'when creating a deposit' do
      let(:deposit_desc) { 'initial deposit' }
      let(:amount) { 99.99 }

      before do
        described_class.call!(source_wallet_id: nil, target_wallet_id: owner1_wallet1.id, amount:, description: deposit_desc)
      end

      it 'creates a credit txn in the target wallet' do
        expect(owner.balance).to eq(amount)
        expect(owner1_wallet1.balance).to eq(amount)

        credit_txn = owner1_wallet1.credits.last
        expect(credit_txn.amount).to eq(amount)
        expect(credit_txn.description).to eq(deposit_desc)
      end

      context 'when creating an internal transfer' do
        let(:internal_txn_desc) { 'transfer from owner1_wallet1 to owner1_wallet2' }

        before do
          described_class.call!(source_wallet_id: owner1_wallet1.id, target_wallet_id: owner1_wallet2.id, amount:, description: internal_txn_desc)
        end

        it 'creates a debit txn in source wallet and a credit txn in target wallet' do
          expect(owner.balance).to eq(amount)
          expect(owner1_wallet1.balance).to eq(0)
          expect(owner1_wallet2.balance).to eq(amount)

          debit_txn = owner1_wallet1.debits.last
          expect(debit_txn.amount).to eq(-amount)
          expect(debit_txn.description).to eq(internal_txn_desc)

          credit_txn = owner1_wallet2.credits.last
          expect(credit_txn.amount).to eq(amount)
          expect(credit_txn.description).to eq(internal_txn_desc)
        end
      end

      context 'when creating an external transfer' do
        let(:external_txn_desc) { 'transfer from owner1_wallet1 to user2_wallet' }
        let!(:user2) { User.create!(email: 'test2@gmail.com', password: '12345678') }
        let!(:user2_wallet) { Wallet.create!(owner: user2, name: 'U2W1') }

        before do
          described_class.call!(source_wallet_id: owner1_wallet1.id, target_wallet_id: user2_wallet.id, amount:, description: external_txn_desc)
        end

        it 'creates a debit txn in source wallet and a credit txn in target wallet' do
          expect(owner.balance).to eq(0)
          expect(owner1_wallet1.balance).to eq(0)
          expect(user2.balance).to eq(amount)
          expect(user2_wallet.balance).to eq(amount)

          debit_txn = owner1_wallet1.debits.last
          expect(debit_txn.amount).to eq(-amount)
          expect(debit_txn.description).to eq(external_txn_desc)

          credit_txn = user2_wallet.credits.last
          expect(credit_txn.amount).to eq(amount)
          expect(credit_txn.description).to eq(external_txn_desc)
        end
      end
    end
  end
end

class CreateTables < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :email
      t.string :password_digest

      t.timestamps
    end

    create_table :teams do |t|
      t.string :name

      t.timestamps
    end

    create_table :stocks do |t|
      t.string :name

      t.timestamps
    end

    create_table :wallets do |t|
      t.string :name
      t.belongs_to :owner, null: false, polymorphic: true

      t.timestamps
    end

    create_table :transactions do |t|
      t.string :type
      t.float :amount
      t.string :description
      t.integer :source_wallet_id
      t.integer :target_wallet_id

      t.timestamps
    end
  end
end

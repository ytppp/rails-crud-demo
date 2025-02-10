class CreateShops < ActiveRecord::Migration[7.0]
  def change
    create_table :shops do |t|
      t.string :name, null: false, default: ''
      t.index :name, unique: true
      t.integer :products_count, null: false, default: 0
      t.integer :orders_count, null: false, default: 0
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end

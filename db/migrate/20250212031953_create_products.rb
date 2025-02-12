class CreateProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :products do |t|
      t.string :title, null: false, default: ""
      t.float :price, null: false, default: 0.0
      t.integer :published, null: false, default: 1
      t.references :shop, null: false, foreign_key: true

      t.timestamps
    end
    # 这里创建了products表， 并添加了标题和商铺id的关联索引，这是因为同一家店铺内不允许商品同名，但是允许不同商铺的商品同名
    add_index :products, [:shop_id, :title]
    add_index :products, :title
  end
end

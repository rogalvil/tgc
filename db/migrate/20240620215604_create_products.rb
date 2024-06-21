class CreateProducts < ActiveRecord::Migration[7.1]
  def change
    create_table :products do |t|
      t.string :sku, null: false
      t.string :name, null: false
      t.text :description
      t.decimal :price, null: false, precision: 10, scale: 2
      t.integer :stock, null: false, default: 0

      t.timestamps
    end

    add_index :products, :sku, unique: true
  end
end

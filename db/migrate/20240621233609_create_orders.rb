class CreateOrders < ActiveRecord::Migration[7.1]
  def change
    create_enum :order_status_type, %w[pending paid shipped delivered cancelled]
    create_table :orders do |t|
      t.references :user, null: false, foreign_key: true
      t.decimal :total_price, null: false, precision: 10, scale: 2, default: 0.0
      t.datetime :completed_at

      t.timestamps
    end
    add_column :orders, :status, :order_status_type, default: 'pending', null: false
  end
end

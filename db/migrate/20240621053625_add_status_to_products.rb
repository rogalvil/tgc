class AddStatusToProducts < ActiveRecord::Migration[7.1]
  def change
    create_enum :product_status_type, %w[active inactive discontinued preorder]
    add_column :products, :status, :product_status_type, default: 'inactive', null: false
  end
end

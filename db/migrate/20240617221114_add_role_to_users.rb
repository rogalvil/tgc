class AddRoleToUsers < ActiveRecord::Migration[7.1]
  def change
    enable_extension 'plpgsql'
    create_enum :role_type, %w[customer admin]
    add_column :users, :role, :role_type, default: 'customer'
  end
end

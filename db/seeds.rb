# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
admin_attributes = {
  name: 'Admin User',
  email: 'rogalvil+admin@gmail.com',
  password: 'Adm1n+p4ssw0rD',
  role: 'admin'
}

User.create_with(
  admin_attributes
).find_or_initialize_by(email: admin_attributes[:email]).tap do |user|
  user.update!(admin_attributes)
end

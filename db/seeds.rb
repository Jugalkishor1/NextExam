# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
# Check if an admin user already exists, and only create one if it doesn't
if Rails.env.development? && AdminUser.count == 0
  AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password')
elsif Rails.env.production? && AdminUser.count == 0
  AdminUser.create!(
    email: ENV['ADMIN_EMAIL'],
    password: ENV['ADMIN_PASS'],
    password_confirmation: ENV['ADMIN_PASS']
  )
end

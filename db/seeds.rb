# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# Create default admin user
# Email: admin@openremote.local
# Password: admin123
User.find_or_create_by!(email: "admin@openremote.local") do |user|
  user.password = "admin123"
  user.password_confirmation = "admin123"
  user.admin = true
end

puts "✓ Default admin user created: admin@openremote.local / admin123"

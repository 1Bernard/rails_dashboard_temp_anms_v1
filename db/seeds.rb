# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# Truncate the tables
# Be cautions when destroying the records in the db on production.
# User.destroy_all
# UserRole.destroy_all
# Role.destroy_all
# Permission.destroy_all
# PermissionsRole.destroy_all

# Load the Rails environment and constants
require_relative '../config/environment'
require_relative '../config/initializers/constants'

# Run the Rake task to populate the permissions table
Rake::Task['permissions:permissions'].invoke

# set Super Admin Role
role = Role.new(
  name: 'ANM Super Admin',
  unique_code: ANMSADM_ROLE_UNIQUE_CODE,
  active_status: true,
  del_status: false
)

# set permissions for Super Admin
role.permissions = Permission.all

# save role
role.save!


# Create Super Admin User and associate UserRole
User.create!(
  lastname: 'Super',
  firstname: 'Appsnmobile',
  other_names: 'User',
  username: 'anmsa',
  password: 'anmsa1234',
  password_confirmation: 'anmsa1234',
  email: 'anmsa@appsnmobilesolutions.com',
  user_role: UserRole.new(
    role_unique_code: role.unique_code,
    active_status: true,
    del_status: false
  )
)

p("Seeder Executed successfully")

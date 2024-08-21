class UserRole < ApplicationRecord
  belongs_to :role, class_name: "Role", foreign_key: :role_unique_code, primary_key: :unique_code
  belongs_to :user, class_name: "User", foreign_key: :user_id
  belongs_to :entity_info, class_name: "EntityInfo", foreign_key: :entity_code, primary_key: :assigned_code

  validates :user_id, presence: true
  validates :role_unique_code, presence: true
end

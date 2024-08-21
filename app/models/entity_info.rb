class EntityInfo < ApplicationRecord
  include ShareAttrUserRole
  
  has_one :user_role, class_name: "UserRole", foreign_key: :entity_code, primary_key: :assigned_code
end

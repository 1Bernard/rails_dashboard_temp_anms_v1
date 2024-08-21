class Role < ApplicationRecord
  has_many :user_roles, class_name: "UserRole", foreign_key: :role_unique_code, primary_key: :unique_code
  has_and_belongs_to_many :permissions, foreign_key: :role_id

  validates :name, presence: { message: "Cannot be empty" }, 
                   uniqueness: { message: "already exists" },
                   format: { with: /\A[a-zA-Z_\d\s-]+\z/, message: "should include letters, hyphens, spaces, underscores, or numbers only" }

  validates :unique_code, presence: { message: "Cannot be empty" },
                    length: { maximum: 10, message: "must be at most 10 characters long" },
                    format: { with: /\A[a-zA-Z]+\z/, message: "should be letters only" },
                    uniqueness: { message: "already exists" }
end

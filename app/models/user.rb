class User < ApplicationRecord
  include ShareAttrUserRole
  include ShareAttrEntityInfo
  
  devise :database_authenticatable, :registerable, #:lockable,
         :recoverable, :timeoutable, :rememberable, :validatable

  # Associations
  belongs_to :entity_info, class_name: "EntityInfo", foreign_key: :user_id, optional: true
  has_one :user_role, -> { where del_status: false }, foreign_key: :user_id
  has_one :role, -> { where del_status: false }, class_name: "Role", through: :user_role, source: :role

  # Validations
  validates :username, presence: true
  validates :email, presence: true
  validates :other_names, presence: true
  validates :firstname, presence: true


  validate :email_taken_and_format_validation
  validate :username_taken_validation
  validate :password_length
  validate :passwords_match, if: -> { password.present? && password_confirmation.present? }

  # Override Devise's find_for_database_authentication method
  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    conditions.merge!(active_status: true, del_status: false)
    where(conditions).first
  end

  def fullname
    "#{self.firstname} #{self.lastname}"
  end

  def cap_initials
    "#{firstname&.first&.capitalize}#{lastname&.first&.capitalize}"
  end

  private

  # Custom validation methods
  def username_taken_validation
    if username.present?
      errors.add(:email, "Username  taken")  if User.exists?(username: username, active_status: true ) && new_record?
    end
  end

  def email_taken_and_format_validation
    if email.present?
      unless email.match?(/\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i)
        errors.add(:email, "is not in the correct format")
      end

      if User.exists?(email: email, active_status: true) && new_record?
        errors.add(:email, "is taken")
      end
    end
  end

  def mobile_number_format_validation
    unless mobile_number =~ /\A(233|0)\d{9}\z/
      errors.add(:mobile_number, "must be in the format '233XXXXXXXXX' or '0XXXXXXXXX'")
    end
  end

  def passwords_match
    unless password == password_confirmation
      errors.add(:password_confirmation, "doesn't match Password")
    end
  end

  def password_length
    if self.new_record?
      errors.add(:password, "is too short (minimum is 8 characters)") if password.length < 8
    else
      if password.present? && password.length < 8
        errors.add(:password, "is too short (minimum is 8 characters)")
      end
    end
  end

  def client_presence_for_specific_roles
    allowed_roles = ['ADM']
    if allowed_roles.include?(role_code) && assigned_code.blank?
      errors.add(:assigned_code, "must be present for Admin")
    end
  end
end

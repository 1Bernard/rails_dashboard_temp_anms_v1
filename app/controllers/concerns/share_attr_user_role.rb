module ShareAttrUserRole
  extend ActiveSupport::Concern
  included do
    attr_accessor :role_unique_code
  end
end
module ShareAttrRole
  extend ActiveSupport::Concern
  included do
    attr_accessor :unique_code
  end
end
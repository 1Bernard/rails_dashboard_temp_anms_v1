module ShareAttrEntityInfo
  extend ActiveSupport::Concern
  included do
    attr_accessor :assigned_code
  end
end
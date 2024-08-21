class PermissionsService < BaseService
    def self.fetch_models(conditions = {}, current_user_unique_code)
      permission_query = Permission.where(conditions)

      unless current_user_unique_code == ANMSADM_ROLE_UNIQUE_CODE
        permission_query = permission_query.where.not(subject_class: 'Role')
      end
    
      permission_query
    end

end
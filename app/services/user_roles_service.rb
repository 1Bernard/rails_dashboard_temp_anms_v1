class UserRolesService < BaseService
    def self.fetch_models(conditions = {})
        UserRole.where(conditions.merge(del_status: true)).order(created_at: :desc)
    end

    def self.fetch_model(id)
        UserRole.find_by(id: id)
    end

    def self.create_model(params)
        @user_role = UserRole.new(sanitize_params(params)) # use this line if company_code is required
        # @user_role = UserRole.new(params.except(:assigned_code))

        handle_model_errors unless @user_role.save

        @user_role
    end

    def self.update_model(id, params)
        @user_role = fetch_model(id)
        handle_model_errors unless @user_role.present? && soft_update(params)

        [@user_role, @attr_changed]
    end

    def self.toggle_model_status(id)
        @user_role = fetch_model(id)
        handle_model_errors unless @user_role.toggle_status
    
        @user_role
    end

    def self.delete_model(id)
        @user_role = fetch_model(id)
        handle_model_errors unless @user_role.soft_delete
        
        @user_role
    end

    # private

    def self.soft_update(params)
        if attributes_changed?(params)
            build_transaction do
                
                new_user_role = UserRole.new(sanitize_params(params))
                if new_user_role.valid?
                    return false unless @user_role.soft_delete_without_validating
                    new_user_role.save(validate: false)
                else
                    @user_role.errors.merge!(new_user_role.errors)
                    return false
                end
                true
            end
        end
        true
    end

    def self.attributes_changed?(params)
        transformed_attr = @user_role.attributes.slice(*params.keys).transform_values(&:to_s)
        @attr_changed = params != transformed_attr

        @attr_changed
    end

    def self.handle_model_errors
        log_message(@user_role&.error_messages || "Failed to perform operation on user role")
    end

    def self.meets_condition_to_save?(params)
        company_code_present = params[:company_code].present?
        unique_code_is_sadm = params[:unique_code] == 'SADM'
        unique_code_is_anmsadm = params[:unique_code] == ANMSADM_ROLE_UNIQUE_CODE
        company_code_empty = params[:company_code].empty?

        # Check if company code is present and unique code is not 'SADM' or 'ANMSADM_ROLE_UNIQUE_CODE'
        condition_one = company_code_present && !unique_code_is_sadm && !unique_code_is_anmsadm

        # Check if unique code is 'SADM' or 'ANMSADM_ROLE_UNIQUE_CODE' and company code is empty
        condition_two = (unique_code_is_sadm || unique_code_is_anmsadm) && company_code_empty

        condition_one || condition_two
    end

    def self.sanitize_params(params)
        if (params[:unique_code] == 'SADM') || (params[:unique_code] == ANMSADM_ROLE_UNIQUE_CODE)
            params.except(:assigned_code)
        else
            params
        end
    end

    

    class << self 
        private :attributes_changed?, :handle_model_errors
    end 
end

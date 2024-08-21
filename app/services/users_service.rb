class UsersService < BaseService
    def self.fetch_models(conditions = {}, current_user_unique_code = nil)
        user_query = User.where(conditions.reverse_merge(del_status: false)).order(created_at: :desc)

        # Exclude users with the ANMSADM_ROLE_UNIQUE_CODE unless the current user has this role
        unless current_user_unique_code == ANMSADM_ROLE_UNIQUE_CODE
            user_query = user_query.joins(:user_role).where.not(user_roles: {role_unique_code: ANMSADM_ROLE_UNIQUE_CODE})
        end

        user_query
    end

    def self.fetch_model(id)
        User.find_by(id: id)
    end

    def self.filter_models(conditions = {}, current_user_unique_code)
        joins_clause = []
        search_conditions = []
        conditions.reverse_merge!(del_status: false)

        if conditions[:unique_code]
            joins_clause << :user_role
            search_conditions << "user_roles.unique_code = '#{conditions.delete(:unique_code)}'"

            if conditions[:active_status]
                search_conditions << build_status_conditions_for_field('users.active_status', conditions.delete(:active_status))
            end

            if conditions.has_key?(:del_status)
                search_conditions << build_status_conditions_for_field('users.del_status', conditions.delete(:del_status))
            end

            if conditions[:date_range]
                created_at = set_date_range_conditions(conditions.delete(:date_range))
                search_conditions << "users.created_at BETWEEN '#{created_at.begin}' AND '#{created_at.end}'"
            end
        end

        query = User
        query = query.joins(joins_clause) if joins_clause.any?

        # Combine all search conditions
        query = query.where(build_search_condition_str(conditions, search_conditions)).order(created_at: :desc)

        # Exclude users with ANMSADM_ROLE_UNIQUE_CODE if applicable
        query = query.where.not(user_roles: { unique_code: ANMSADM_ROLE_UNIQUE_CODE }) unless current_user_unique_code == ANMSADM_ROLE_UNIQUE_CODE

        query
    end


    def self.set_models_for_create(current_user_unique_code)
        [User.new, *aux_models(current_user_unique_code)]
    end

    def self.aux_models(current_user_unique_code)
        roles = RolesService.fetch_models({active_status: true}, current_user_unique_code)
        entity_infos = EntityInfosService.fetch_models(active_status: true)
        [roles, entity_infos]
    end

    def self.set_models_for_edit(id, current_user_unique_code)
        [fetch_model(id), *aux_models(current_user_unique_code)]
    end

    def self.create_model(params)
        @user = User.new(params.except(:company_code))

        handle_model_errors(@user) unless create_nested_models(params)

        @user
    end

    def self.update_model(id, params)
        @user = fetch_model(id)
        handle_model_errors(@user) unless soft_update_nested_models(params)

        [@user, nested_models_attr_changed?]
    end

    def self.toggle_model_status(id)
        @user = fetch_model(id)
        handle_model_errors(@user) unless toggle_nested_models_status

        @user
    end

    def self.delete_model(id)
        @user = fetch_model(id)
        handle_model_errors(@user) unless soft_delete_nested_models

        @user
    end

    def self.export(ids, ext, current_user_unique_code)
        title = I18n.t(:user).pluralize
        formats = ApplicationHelper.export_formats

        case ext
        when formats.fetch(:csv)
            Export.to_csv(table_headers: struc_headers, table_rows: struc_data(fetch_models({id: ids}, current_user_unique_code)))
        when formats.fetch(:xlsx)
            Export.to_excel(table_headers: struc_headers, table_rows: struc_data(fetch_models({id: ids}, current_user_unique_code)), header_title: title)
        when formats.fetch(:pdf)
            Export.to_pdf(table_headers: struc_headers, table_rows: struc_data(fetch_models({id: ids}, current_user_unique_code)), header_title: title, header_water_mark_image_path: water_mark_image_path)
        else
            I18n.t(:unsupported_format)
        end

    end

    # private mathods
    def self.create_nested_models(params)
        build_transaction do
            return false unless validate_user_and_role_conditions(params)
            return false unless save_user_and_role(params)

            true
        end
    end

    def self.soft_update_nested_models(params)
        build_transaction do
            return false unless change_password(params.slice(*password_params))
            return false unless update_user_attributes(params.except(*password_params, *user_role_params ))
            return false unless update_user_role(params.slice(*user_role_params))

            true
        end
    end

    def self.toggle_nested_models_status
        build_transaction do
            return false unless UserRolesService.toggle_model_status(@user.user_role.id)
            return false unless @user.toggle_status

            true
        end
    end

    def self.soft_delete_nested_models
        build_transaction do
            return false unless UserRolesService.delete_model(@user.user_role.id)
            return false unless @user.soft_delete

            true
        end
    end

    def self.password_params
        [:password, :password_confirmation, :current_password]
    end

    def self.user_role_params
        [:unique_code, :company_code]
    end

    def self.validate_user_and_role_conditions(params)
        if @user.valid? && params[:unique_code].present?
            true
        else
            add_role_and_company_errors(params[:unique_code]&.empty?)
            false
        end
    end

    def self.save_user_and_role(params)
        if @user.image_path.present?
            @user.image_path = handle_image_upload(@user.image_path)
        end

        return false unless @user.save
        user_role = UserRolesService.create_model(params.slice(:company_code, :unique_code).merge(user_id: @user.id))
        if user_role.errors.any?
            @user.errors.merge!(user_role.errors)
            false
        else
            true
        end
    end

    def self.handle_image_upload(image_path)
        response = upload_image(image_path)
        if response[:error].present?
            log_message(response[:error])
            @user.errors.add(:base, "Something went wrong, could not save image")
            nil
        else
            response[:image_url]
        end
    end

    def self.add_role_and_company_errors(unique_code_not_present)
        unless @user.errors.any?
            if unique_code_not_present
                @user.errors.add(:base, "Role required")
            end
        end
    end

    def self.change_password(params)
        return true if params[:password].to_s.empty? && params[:password_confirmation].to_s.empty?

        if params[:current_password].present?
            # for update of user's password on user profile page
            update_own_password(params)
        else
            # for admin update of user password
            @user.reset_password(params[:password], params[:password_confirmation])
        end
    end

    def self.update_own_password(params)
        if @user.valid_password?(params[:current_password])
            @user.update_with_password(params)
        else
            @user.errors.add(:current_password, 'is incorrect')
            false
        end
    end

    def self.update_user_attributes(params)
        if user_attributes_changed?(params)
            if params.key?(:image_path) && attributes_changed?(params.slice(:image_path).to_h, @user)
                params[:image_path] = handle_image_upload(params[:image_path])
            end

            @user.update(params) unless @user.errors.any?

        else
            true
        end
    end

    def self.update_user_role(params)
        user_role, role_attr_changed = UserRolesService.update_model(@user&.user_role&.id, params.merge(user_id: @user.id))
        if user_role&.errors&.any?
            @user.errors.merge!(user_role.errors)
            false
        else
            @attr_changed << role_attr_changed
            true
        end
    end

    def self.user_attributes_changed?(params)
        transformed_attr = @user.attributes.slice(*params.keys).transform_values(&:to_s)
        user_attr_changed = params != transformed_attr

        @attr_changed ||= []
        @attr_changed << user_attr_changed

        user_attr_changed
    end

    def self.nested_models_attr_changed?
        result =  @attr_changed&.any?(&:itself)
       if result.nil?
         true
       else
         result
       end
    end

    def self.struc_data(data)
        data.each.with_index(1).map do |model, index|
        [
            index,
            model.created_at&.strftime("%F %R"),
            model.fullname,
            model.username,
            model.email
        ]
        end
    end

    def self.struc_headers
        [
            "S/N", I18n.t(:date_created),I18n.t(:fullname), I18n.t(:username), I18n.t(:email)
        ]
    end

    class << self
        private :create_nested_models, :soft_update_nested_models,
                :toggle_nested_models_status, :soft_delete_nested_models, :password_params,
                :user_role_params, :validate_user_and_role_conditions, :save_user_and_role,
                :handle_image_upload, :add_role_and_company_errors, :change_password,
                :update_own_password, :update_user_attributes, :update_user_role,
                :user_attributes_changed?, :struc_data, :struc_headers, :nested_models_attr_changed?
    end
end

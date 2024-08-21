class RolesService < BaseService
  def self.fetch_models(conditions = {}, current_user_unique_code)
    role_query = Role.where(conditions.reverse_merge(del_status: false)).order(created_at: :desc)

    unless current_user_unique_code == ANMSADM_ROLE_UNIQUE_CODE
      role_query = role_query.where.not(unique_code: ANMSADM_ROLE_UNIQUE_CODE)
    end

    role_query
  end

  def self.fetch_model(id)
    Role.find_by(id: id)
  end

  def self.filter_models(conditions = {}, current_user_unique_code)
     query = Role.where(build_search_condition_str(conditions))

     unless  current_user_unique_code == ANMSADM_ROLE_UNIQUE_CODE
      query = query.where.not(unique_code: ANMSADM_ROLE_UNIQUE_CODE)
     end

     query.order(created_at: :desc)
  end

  def self.set_for_create(current_user_unique_code)
    role = Role.new

    [role, *aux_models(role, current_user_unique_code)]
  end

  def self.set_for_edit(id, current_user_unique_code)
    role = fetch_model(id)

    [role, *aux_models(role, current_user_unique_code)]
  end

  def self.aux_models(role, current_user_unique_code)
    permissions = PermissionsService.fetch_models({}, current_user_unique_code)
    associated_permissions = role.permissions.pluck(:id)

    [permissions, associated_permissions]
  end

  def self.create_model(params, current_user_unique_code)
      @role = Role.new(params.except(:permission_ids))
      set_permissions(params.slice(:permission_ids).to_h, current_user_unique_code)
      handle_model_errors unless @role.save

      @role
  end

  def self.update_model(id, params, current_user_unique_code)
    @role = fetch_model(id)
    permission_ids = params[:permission_ids]

    changed = attributes_changed?(params.except(:permission_ids).to_h)
    permissions_changed = !@role.permissions.pluck(:id).sort.eql?(permission_ids.sort)

    set_permissions(permission_ids, current_user_unique_code)  if permissions_changed

    if changed || permissions_changed
      handle_model_errors unless @role.update(params.except(:permission_ids))
    end

    [@role, (changed || permissions_changed)]
  end

  def self.toggle_model_status(id)
      @role = fetch_model(id)
      handle_model_errors unless @role.toggle_status

      @role
  end

  def self.delete_model(id)
      @role = fetch_model(id)
      handle_model_errors unless @role.soft_delete

      @role
  end

  # private mathods
  def self.set_permissions(perm_ids, current_user_unique_code)
    @role.permissions = PermissionsService.fetch_models({id: perm_ids}, current_user_unique_code)
  end

  def self.attributes_changed?(params)
    transformed_attr = @role.attributes.slice(*params.keys).transform_values(&:to_s)
    params != transformed_attr
  end

  def self.handle_model_errors
      log_message(@role.error_messages)
  end

  class << self
    private :handle_model_errors, :set_permissions, :attributes_changed?
  end
end

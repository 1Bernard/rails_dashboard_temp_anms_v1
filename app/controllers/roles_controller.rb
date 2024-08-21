class RolesController < ApplicationController
  before_action :decrypt_id, only: [:edit, :update, :toggle_status, :delete]
  
  def index
    filter_main = filter_main_params
    @page_title = "Roles"
    
    if filter_main
      @show_filter_label = true
      @roles = paginate(RolesService.filter_models(filter_main.merge(del_status: false), current_user_unique_code))
    else
      @roles = paginate(RolesService.fetch_models({}, current_user_unique_code))
    end
  end
  
  def new
    @role, @permissions, @associated_permissions = RolesService.set_for_create(current_user_unique_code)

    route_to_form_page(:form)
  end

  def edit
    @role, @permissions, @associated_permissions = RolesService.set_for_edit(params[:id], current_user_unique_code)

    route_to_form_page(:form)
  end

  def create
    @role = RolesService.create_model(role_params.merge(permission_ids: params.fetch(:permission_ids, [])), current_user_unique_code)
    
    if @role.errors.any?
      set_aux_models(@role)
      route_to_form_page(:form, true)
    else
      route_to_index_page("#{@role.name} was successfully created.")
    end
  end

  def update
    @role, attr_changed = RolesService.update_model(params[:id], role_params.merge(permission_ids: params.fetch(:permission_ids, [])), current_user_unique_code)
    
    if attr_changed
      if @role.errors.any? 
        set_aux_models(@role)
        route_to_form_page(:form, true)
      else
        route_to_index_page("#{@role.name} was successfully updated.")
      end
    else
      route_to_index_page
    end
  end

  def toggle_status
    @role = RolesService.toggle_model_status(params[:id])

    if @role.errors.any?
      route_to_index_page("#{I18n.t(:role)} status update failed", true)
    else
      route_to_index_page("#{I18n.t(:role)} status updated successfully")
    end
  end

  def delete
    @role = RolesService.delete_model(params[:id])

    if @role.errors.any?
      route_to_index_page("#{I18n.t(:role)} deletion failed", true)
    else
      route_to_index_page("#{I18n.t(:role)} deleted successfully")
    end
  end

  private
    
    def set_aux_models(role)
      @permissions, @associated_permissions = RolesService.aux_models(role, current_user_unique_code)
    end

    def role_params
      keys = helpers.role_permitted_keys
      params.require(:role).permit(*keys)
    end

    def filter_main_params
      if params[:filter_main].present?
        keys = helpers.role_permitted_keys
        permitted_params = params.require(:user).permit(*keys).to_h

        remove_empty_values(permitted_params)
        
        return permitted_params if any_param_present?(permitted_params, *keys)
      end
      false
    end
end

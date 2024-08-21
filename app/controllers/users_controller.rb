class UsersController < ApplicationController
  before_action :decrypt_id, only: [:show, :edit, :update, :toggle_status, :delete]
  #load_and_authorize_resource

  def index
    filter_main = filter_main_params
    @page_title = "Users"

    if filter_main
      @show_filter_label = true
      @users = paginate(UsersService.filter_models(filter_main, current_user_unique_code))
    else
      @users = paginate(UsersService.fetch_models({}, current_user_unique_code))
    end
  end

  def show
    @user =  UsersService.fetch_model(params[:id])
  end

  def filter
    @roles, @company_infos = set_aux_models
  end

  def new
    # @user = User.new
    @user, @roles, @company_infos = UsersService.set_models_for_create(current_user_unique_code)
    route_to_form_page(:form)
  end

  def create
    handle_uploaded_file(:user, :image_path)

    @user = UsersService.create_model(user_params.to_h)

    if @user.errors.any?
      set_aux_models
      route_to_form_page(:form, true)
    else
      remove_tmp_stored_img(:user, :image_path)
      route_to_index_page("#{I18n.t(:user)}: #{@user.fullname} created successfully")
    end
  end

  def edit
    @user, @roles, @company_infos = UsersService.set_models_for_edit(params[:id], current_user_unique_code)
    route_to_form_page(:form)
  end

  def update
    handle_uploaded_file(:user, :image_path)

    @user, attr_changed = UsersService.update_model(params[:id], user_params.to_h)

    if attr_changed
      if @user.errors.any?
        set_aux_models

        respond_to do |format|
          format.js{route_to_form_page(:form, true) }
          format.html{render 'devise/registrations/edit'}
        end
      else
        remove_tmp_stored_img(:user, :image_path)

        respond_to do |format|
          format.js{route_to_index_page("#{I18n.t(:user)} updated successfully")}
          format.html do
            bypass_sign_in(@user) # Sign in the user again to update the session
            redirect_to root_path, notice: 'Update was successful.'
          end
        end

      end
    else
      route_to_index_page
    end
  end

  def toggle_status
    @user = UsersService.toggle_model_status(params[:id])

    if @user.errors.any?
      route_to_index_page("#{I18n.t(:user)} status update failed", true)
    else
      route_to_index_page("#{I18n.t(:user)} status updated successfully")
    end
  end

  def delete
    @user = UsersService.delete_model(params[:id])

    if @user.errors.any?
      route_to_index_page("#{I18n.t(:user)} delete failed", true)
    else
      route_to_index_page("#{I18n.t(:user)} deleted successfully")
    end
  end

  def export
    data_ids = JSON.parse(params[:data_ids]).map { |id| helpers.decrypt_value(id) }
    respond_to do |format|
      ApplicationHelper.export_formats.each do |sym, ext|
        format.send(sym) do
          send_data UsersService.export(data_ids, ext, current_user_unique_code), filename: "#{I18n.t(:user).pluralize}_as_at-#{DateTime.now.strftime("%F %R")}.#{ext}"
        end
      end
    end
  end

  private
    def user_params
      keys = helpers.user_permitted_keys
      params.require(:user).permit(*keys)
    end

    def filter_main_params
      if params[:filter_main].present?
        keys = helpers.user_permitted_keys
        permitted_params = params.require(:filter_main).permit(*keys, active_status: []).to_h
        permitted_params[:active_status].reject!(&:empty?) if permitted_params[:active_status].present?

        remove_empty_values(permitted_params)

        return permitted_params if any_param_present?(permitted_params, *keys)
      end
      false
    end

    def set_aux_models
       @roles, @company_infos = UsersService.aux_models(current_user_unique_code)
    end
end

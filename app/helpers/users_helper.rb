module UsersHelper
  def user_permitted_keys
    [
      :email, :username, :firstname, :lastname, :other_names, :image_path,
      :mobile_number, :role_unique_code, :assigned_code, :password, :password_confirmation, :creator_id, 
      :active_status, :del_status
    ]
  end

  def user_filter_main_params
    params.fetch(:filter_main, {}).permit(*user_permitted_keys, active_status: []).to_h
  end
end

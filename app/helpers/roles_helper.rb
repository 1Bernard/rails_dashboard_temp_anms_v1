module RolesHelper
  def role_permitted_keys
    [
      :name, :unique_code, :active_status, :del_status
    ]
  end

  def role_filter_main_params
    params.fetch(:filter_main, {}).permit(*role_permitted_keys).to_h
  end
end

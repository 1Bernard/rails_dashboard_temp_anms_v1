json.extract! entity_info, :id, :assigned_code, :entity_name, :email, :contact_number, :user_id, :active_status, :del_status, :created_at, :updated_at
json.url entity_info_url(entity_info, format: :json)

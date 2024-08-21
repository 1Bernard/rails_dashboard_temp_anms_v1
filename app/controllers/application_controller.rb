class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  protect_from_forgery with: :null_session

  # Ensure user authentication before every action.
  before_action :authenticate_user!

  # Configure permitted parameters for user sign-up and account update.
  before_action :configure_permitted_parameters, if: :devise_controller?

  # Load user permissions before every action.
  before_action :load_permissions

  # Handle CanCan access denied exceptions.
  rescue_from CanCan::AccessDenied do |e|
    log_message("ACCESS WAS DENIED HERE: #{e.inspect}")
    show_flash_alert("Sorry, you are not allowed to access the requested page!", true)

    if request.referer.present?
      redirect_to request.referer
    elsif request.format.js?
      render js: "window.location.href='#{request.referer}'"
    elsif current_user.present? && request.referer.nil?
      redirect_to root_path
    else
      redirect_to sign_in_path
    end
  end

  # # Redirect to appropriate path after user sign-in.
  # def after_sign_in_path_for(resource)
  #   if resource.is_a?(User) && session[:showed_welcome_message]
  #     super
  #   else
  #     session[:showed_welcome_message] = true
  #     show_flash_alert("Welcome, #{resource.firstname.capitalize}!")
  #     root_path
  #   end
  # end

  protected

  # Override Devise's after_sign_in_path_for method
  def after_sign_in_path_for(resource)
    if resource.active_status
      super
    else
      sign_out resource
      flash[:alert] = "Your account is not active. Please contact support."
      root_path
    end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_in) { |u| u.permit(:login, :email, :username, :password, :remember_me) }
    devise_parameter_sanitizer.permit(:account_update) { |u| u.permit(:username, :lastname, :other_names, :mobile_number, :active_status, :email, :password, :password_confirmation, :current_password) }
  end

  def set_cache_headers
    response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
    response.headers["Pragma"] = "no-cache"
  end

  # Instantiate the current user's ability.
  def current_ability
    @current_ability ||= Ability.new(current_user)
  end

  # Load the permissions for the current user.
  def load_permissions
    if current_user.present?
      @current_permissions = current_user.role&.permissions&.pluck(:subject_class, :name)
    end
  end

  # Paginates a query result.
  def paginate(query)
    set_page_and_count
    query.paginate(page: params[:page], per_page: params[:count])
  end

  # Routes to the index page of a controller action, optionally showing a flash message.
  def route_to_index_page(flash_msg = nil, error = false)
    index # calls the index function of the calling controller
    show_flash_alert(flash_msg, error)
    render :index
  end

  # Routes to the form page of a controller action, optionally displaying an error status.
  def route_to_form_page(form = :form, error = false)
    status_code = error ? :unprocessable_entity : :ok

    render form, status: status_code
  end

  # Checks if any of the specified keys are present in the parameters.
  def any_param_present?(params, *keys)
    keys.any? { |key| params[key].present? }
  end

  # Removes empty values from a hash.
  def remove_empty_values(hash)
    hash.reject! { |_, value| value.nil? || (value.respond_to?(:empty?) && value.empty?) }
  end

  # Decrypts the ID parameter, typically used for encrypted IDs in URLs.
  def decrypt_id(id = nil)
    params[:id] = helpers.decrypt_value(id.nil? ? params[:id] : id)
  end

  # Displays a flash message alert based on whether it's an error or not.
  def show_flash_alert(flash_msg, error = false)
    if flash_msg.present?
      if error == false
        flash.now[:notice] = flash_msg
      else
        flash.now[:alert] = flash_msg
      end
    end
  end

  # Handles the upload of a file, storing it temporarily in the public directory.
  def handle_uploaded_file(*attribute_keys)
    uploaded_file = params.dig(*attribute_keys)

    if uploaded_file.present? && uploaded_file.respond_to?(:original_filename) && uploaded_file.original_filename.present?
      # Directory where the file will be stored
      dir_path = Rails.root.join('public', 'tmp_images')

      # Ensure the directory exists
      FileUtils.mkdir_p(dir_path) unless Dir.exists?(dir_path)

      # Full path for the file to be saved
      file_path = dir_path.join(uploaded_file.original_filename)

      # Store preview image temporarily in the public directory
      File.open(file_path, 'wb') { |file| file.write(uploaded_file.read) }

      # Update the attribute dynamically based on the keys
      params.dig(*attribute_keys[0..-2])[attribute_keys[-1].to_sym] = uploaded_file.original_filename
    end
  end

  # Removes a temporarily stored image file from the public directory.
  def remove_tmp_stored_img(*attribute_keys)
    uploaded_file = params.dig(*attribute_keys)

    if uploaded_file.present? && !uploaded_file.respond_to?(:original_filename)
      file_path = Rails.root.join('public', 'tmp_images', uploaded_file)
      File.delete(file_path) if File.exist?(file_path)
    end
  end

  def log_message(message)
    ApplicationHelper.log_message(message)
  end

  def current_user_unique_code
    current_user.user_role.role_unique_code
  end

  private

  # Sets the page number and count for pagination.
  def set_page_and_count
    params[:count] = params[:count] == 'All' ? nil : params[:count] || 20
    params[:page] ||= 1
  end
end

module ApplicationHelper
  include Encryption
  def active_class(link_path)
    current_page?(link_path) ? 'active' : ''
  end

  def page_title
    case controller_name
    when 'dashboard'
      'Dashboard'
    when 'users'
      'Users'
    when 'roles'
      'Roles'
    when 'entity_info'
      'EntityInfo'
    # Add more cases for other controllers
    else
      ''
    end
  end

  def self.time_filters
    {
      today: I18n.t(:today),
      week: I18n.t(:this_week),
      month: I18n.t(:this_month),
      year: I18n.t(:this_year)
    }
  end

  def self.export_formats
    {
      xlsx: "xlsx",
      csv: "csv",
      pdf: "pdf"
    }
  end

  def self.handle_status(status)
    status ? I18n.t(:passed) : (status == false ? I18n.t(:failed) : I18n.t(:pending))
  end

  def self.handle_active_class(status)
    status ? I18n.t(:active) : (status == false ? I18n.t(:inactive) : I18n.t(:pending))
  end

  def self.handle_approved(status)
      # status ? "Yes" : (status == false ? "No" : I18n.t(:pending))
    status ? I18n.t(:approved) : (status == false ? I18n.t(:rejected) : I18n.t(:pending))
  end

  def self.handle_approval_status(status)
    status ? I18n.t(:approved) : (status == false ? I18n.t(:rejected) : I18n.t(:pending))
  end

  def active_class(link_path)
    current_page?(link_path) ? 'active' : ''
  end

  def text_active_class(link_path)
    current_page?(link_path) ? 'text-active' : ''
  end

  def self.prefix_with_233(number, remove_prefix = false)
    if remove_prefix
      number.to_s.sub('233', '0')
    else
      last_9_digits = number.to_s[-9..-1] # extract last 9 characters
      "233#{last_9_digits}"
    end
  end

  def self.handle_money(val)
    sprintf("%.2f", val.to_f)
  end

  def self.log_message(message)
    Rails.logger.info "###### #{message} #####"
  end

  def handle_display_image(model)
    return "svgs/image_placeholder.svg" unless model.image_path.present?

    if model.new_record? || !model.image_path.start_with?("https://res.cloudinary.com")
      "/tmp_images/#{model.image_path}"
    else
      model.image_path
    end
  end


  def current_user_can?(name, subject_class)
    @current_permissions ||= []
    @current_permissions.any? { |perm| perm[0] == subject_class.to_s && perm[1] == name.to_s }
  end

  def show_badge(notifiable_id, status)
    Notification.unread_for_notifiable(notifiable_id, current_user) && status.nil?
  end
end

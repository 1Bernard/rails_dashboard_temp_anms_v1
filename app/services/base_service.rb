class BaseService < ActiveRecord::Base

  def self.build_transaction(&block)
    ActiveRecord::Base.transaction do
      result = block.call
      raise ActiveRecord::Rollback unless result
    end
  end

  def self.struc_time_range(time_filter)
    filter = ApplicationHelper.time_filters
    current_time = Time.current
    time_ranges = {
      filter.fetch(:today) => [current_time.all_day, current_time.yesterday.all_day],
      filter.fetch(:week) => [current_time.beginning_of_week..current_time.end_of_week, (current_time - 1.week).beginning_of_week..(current_time - 1.week).end_of_week],
      filter.fetch(:month) => [current_time.beginning_of_month..current_time.end_of_month, (current_time - 1.month).beginning_of_month..(current_time - 1.month).end_of_month],
      filter.fetch(:year) => [current_time.beginning_of_year..current_time.end_of_year, (current_time - 1.year).beginning_of_year..(current_time - 1.year).end_of_year]
    }
    
    time_ranges[time_filter] || time_ranges[filter.fetch(:week)]
  end

  def self.previous_month_date_range(date_range)
    start_date, _ = date_range.split(' to ').map { |date_str| Date.strptime(date_str, '%Y-%m-%d') }
    prev_month_start = start_date.prev_month.beginning_of_month
    prev_month_end = prev_month_start.end_of_month

    "#{prev_month_start.strftime('%Y-%m-%d')} to #{prev_month_end.strftime('%Y-%m-%d')}"
  end

  # Builds a SQL condition string for a given field and a list of statuses.
  #
  # @param field [String] the database field to filter on (e.g., 'users.del_status').
  # @param statuses [Array, String] the list of statuses or a single status to filter by.
  # @return [String] the SQL condition string (e.g., "users.del_status = 'active' OR users.del_status IS NULL").
  def self.build_status_conditions_for_field(field, statuses)
    statuses = [statuses] unless statuses.is_a?(Array)
    conditions = statuses.map do |status|
      status.to_s.casecmp?('null') ? "#{field} IS NULL" : "#{field} = '#{status}'"
    end
    conditions.join(' OR ')
  end

  # Appends conditions for a specific key in the conditions hash and returns the SQL condition string.
  #
  # @param key [Symbol] the key to look for in the conditions hash (e.g., :del_status).
  # @param conditions [Hash] the hash containing key-value pairs to be converted into SQL conditions.
  # @return [String] the SQL condition string wrapped in parentheses (e.g., "(del_status = 'active' OR del_status IS NULL)").
  def self.append_conditions_for_key(key, conditions)
    return '' unless conditions.key?(key)

    values = Array(conditions.delete(key))
    conditions_str = values.map do |value|
      value.to_s.casecmp?("null") ? "#{key} IS NULL" : "#{key} = '#{value}'"
    end.join(" OR ")

    "(#{conditions_str})"
  end



  def self.build_search_condition_str(conditions, search_conditions = [])
    # Collect conditions
    search_conditions += %i[del_status active_status status processed approved].map do |key|
      append_conditions_for_key(key, conditions)
    end.reject(&:empty?) # Remove empty strings

    # Handle date range separately
    if conditions[:date_range].present?
      created_at = set_date_range_conditions(conditions[:date_range])
      if created_at
        search_conditions << "created_at BETWEEN '#{created_at.begin}' AND '#{created_at.end}'"
        conditions.delete(:date_range)
      end
    end

    # Add text search conditions
    unless conditions.empty?
      search_conditions << conditions.map { |key, condition| "#{key} ILIKE '%#{condition}%'" }.join(" AND ")
    end

    # Combine all conditions
    search_conditions&.reject(&:empty?).join(" AND ")
  end

  # def self.set_date_range_conditions(filter_value)
  #   start_date_str, end_date_str = filter_value.split(" to ")

  #   end_date_str ||= start_date_str

  #   start_date = start_date_str&.to_date
  #   end_date = end_date_str&.to_date

  #   return nil unless start_date && end_date && start_date <= end_date

  #   start_date.beginning_of_day..end_date.end_of_day
  # end

  def self.set_date_range_conditions(filter_value)
    if filter_value.is_a?(String)
      start_date_str, end_date_str = filter_value.split(" to ")
      end_date_str ||= start_date_str

      start_date = start_date_str&.to_date
      end_date = end_date_str&.to_date

      return nil unless start_date && end_date && start_date <= end_date

      start_date.beginning_of_day..end_date.end_of_day
    elsif filter_value.is_a?(Hash) && filter_value[:created_at]
      start_date_str, end_date_str = filter_value[:created_at].split(" to ")
      end_date_str ||= start_date_str

      start_date = start_date_str&.to_date
      end_date = end_date_str&.to_date

      return nil unless start_date && end_date && start_date <= end_date

      start_date.beginning_of_day..end_date.end_of_day
    else
      nil
    end
  end

  def self.log_message(message)
    ApplicationHelper.log_message(message)
  end

  def self.handle_model_errors(model)
    log_message(error_messages(model))
  end

  def self.error_messages(model)
    model&.errors&.full_messages&.join(", ")
  end

  def self.attributes_changed?(params, model)
    transformed_attr = model.attributes.slice(*params.keys).transform_values(&:to_s)
    params != transformed_attr
  end

  # def self.attributes_changed?(params, model)
  #   relevant_params = params.slice(*model.attributes.keys)
  #   model.attributes.slice(*relevant_params.keys).transform_values(&:to_s) != relevant_params.transform_values(&:to_s)
  # end


  def self.upload_image(image_path)
    if image_path.respond_to?(:original_filename) && image_path.original_filename.present?
      ImageUploader.upload_to_cloudinary(image_path)
    else
      file_path = Rails.root.join("public", "tmp_images", image_path)
      ImageUploader.upload_to_cloudinary(file_path)
    end
  end

  def self.handle_image_upload(image_path)
    response = upload_image(image_path)
    if response[:error].present?
        log_message(response[:error])
        nil
    else
        response[:image_url]
    end
  end

  def self.unavailable
    I18n.t(:unavailable)
  end

  def self.water_mark_image_path
    {
      app_logo: Rails.root.join("app/assets/images/export-logo.png"),
      company_logo: Rails.root.join("app/assets/images/appsnmobile-header.png")
    }
  end

  class << self
    private :log_message,
            :error_messages,
            :build_transaction,
            :set_date_range_conditions,
            :attributes_changed?,
            :build_search_condition_str,
            :upload_image,
            :unavailable,
            :water_mark_image_path,
            :previous_month_date_range,
            :struc_time_range,
            :append_conditions_for_key,
            :build_status_conditions_for_field,
            :handle_model_errors,
            :handle_image_upload
  end
end

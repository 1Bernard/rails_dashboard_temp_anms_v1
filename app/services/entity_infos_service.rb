class EntityInfosService < BaseService

  def self.fetch_models(conditions = {})
      EntityInfo.where({del_status: false}.reverse_merge(conditions)).order(created_at: :desc)
  end

  def self.fetch_model(id)
      EntityInfo.find_by(id: id)
  end

  def self.new_model(parmas)
    EntityInfo.new(parmas)
  end

  def self.filter_models(conditions = {})
    EntityInfo.where(build_search_condition_str(conditions.reverse_merge(del_status: false))).order(created_at: :desc)
  end

  def self.set_models_for_create
    entity_info = EntityInfo.new

    #build nested attributes
    # service = entity_info.services.build
    # service.service_ovas.build
    # service.test_numbers.build

    entity_info
  end

  def self.set_models_for_edit(id)
    fetch_model(id)
  end

  def self.validate_nested_models(params)
    entity_info = EntityInfo.new(params)
    handle_model_errors(entity_info) unless entity_info.valid?

    entity_info
  end

  def self.create_model(params)
    entity_info = EntityInfo.new(params)

    # Process test_numbers for each service
    entity_info.services.each do |service|
      service.test_numbers.each do |test_number|
        test_number.customer_number = ApplicationHelper.prefix_with_233(test_number.customer_number)
      end

      # Build entity_service_accounts for each service
      service.build_entity_service_account
    end

    if entity_info.save
      if entity_info.image_path.present?
        image_url =  handle_image_upload(entity_info.image_path)
        if image_url
          entity_info.update(image_path: image_url)
        else
          entity_info.errors.add(:base, "Failed to upload image")
        end
      end
    else
      handle_model_errors(entity_info)
    end

    entity_info
  end

  def self.update_model(id, params)
    @entity_info = fetch_model(id)
    changed = attributes_changed?(params, @entity_info)
    if changed
      handle_model_errors(@entity_info) unless soft_update_model(params)
    end

    [@entity_info, changed]
  end

  def self.toggle_model_status(id)
    @entity_info = fetch_model(id)
    handle_model_errors(@entity_info) unless toggle_nested_models

    @entity_info
  end

  def self.delete_model(id)
    @entity_info = fetch_model(id)
    handle_model_errors(@entity_info) unless soft_delete_nested_models

    @entity_info
  end

  def self.export(ids, ext)
    title = I18n.t(:entity).pluralize
    formats = ApplicationHelper.export_formats

    case ext
    when formats.fetch(:csv)
      Export.to_csv(table_headers: struc_headers, table_rows: struc_data(fetch_models(id: ids)))
    when formats.fetch(:xlsx)
      Export.to_excel(table_headers: struc_headers, table_rows: struc_data(fetch_models(id: ids)), header_title: title)
    when formats.fetch(:pdf)
      Export.to_pdf(table_headers: struc_headers, table_rows: struc_data(fetch_models(id: ids)), header_title: title, header_water_mark_image_path: water_mark_image_path)
    else
      I18n.t(:unsupported_format)
    end

  end

  # private
  def self.toggle_nested_models
    build_transaction do
      @entity_info.toggle_status
    end
  end

  def self.soft_delete_nested_models
    build_transaction do
      @entity_info.soft_delete
    end
  end



  def self.soft_update_model(params)
    if params.key?(:image_path) && attributes_changed?(params.slice(:image_path), @entity_info)
      image_url = handle_image_upload(params[:image_path])
      if image_url
        params[:image_path] = image_url
      else
        @entity_info.errors.add(:base, "Failed to upload image")
      end
    end
    @entity_info.update(params)
  end

  # def self.handle_missing_image_error(model = nil)
  #   @entity_info = EntityInfo.new if model.nil?
  #   @entity_info.errors.add(:base, 'Image required')

  #   log_message(@entity_info.error_messages)
  # end

  def self.struc_data(data)
    data.each.with_index(1).map do |transaction, index|
      [
        index,
        transaction.created_at&.strftime("%F %R"),
        transaction.entity_name,
        transaction.postal_address,
        transaction.location_address,
        transaction.email
      ]
    end
  end

  def self.struc_headers
    [
      "S/N", I18n.t(:date_created),I18n.t(:entity_name), I18n.t(:postal_address), I18n.t(:location_address),
      I18n.t(:email)
    ]
  end

  class << self
    private :struc_data, :struc_headers, :toggle_nested_models,
            :soft_delete_nested_models, :soft_update_model
  end

end

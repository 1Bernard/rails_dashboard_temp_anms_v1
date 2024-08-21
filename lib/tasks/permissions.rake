namespace 'permissions' do
  desc "Load all models and their methods in permissions table."
  task(:permissions => :environment) do
    arr = []
    
    # Gather all controller files in the app/controllers directory
    controllers = Dir.new("#{Rails.root}/app/controllers").entries
    controllers.each do |entry|
      if entry =~ /_controller/
        # Extract controller class name and add it to arr
        arr << entry.camelize.gsub('.rb', '').constantize
      elsif entry =~ /^[a-z]*$/
        # Handle namespaces by exploring subdirectories
        Dir.new("#{Rails.root}/app/controllers/#{entry}").entries.each do |x|
          if x =~ /_controller/
            # Extract namespaced controller class name and add it to arr
            arr << "#{entry.titleize}::#{x.camelize.gsub('.rb', '')}".constantize
          end
        end
      end
    end

    # Loop through each controller class
    arr.each do |controller|
      p controller
      model = get_model_name(controller)
      if model 
        # Add permission to perform CRUD operations for every model
        write_permission(model, "manage", 'manage')

        # Loop through each action method in the controller
        controller.action_methods.each do |method|
          if method =~ /^([A-Za-z\d*]+)+([\w]*)+([A-Za-z\d*]+)$/ # Matches method names like "add_user" or "Add_user"
            name, cancan_action = eval_cancan_action(method)
            # Add permission for the specific action
            write_permission(model, cancan_action, name)  
          end
        end
      end
    end

    puts "All Class methods loadded successfully. Check Permissions table"
  end
end

# Extract model name from controller class name
def get_model_name(controller)
  name = controller.name
  controller_name = name.split('::').last  # Extract the controller name, handling namespaces

  model_name = controller_name.chomp('Controller').singularize  # Remove "Controller" suffix and singularize
  model = model_name.safe_constantize  # Try to get the corresponding model class without raising an exception
  unless model
    # Log a message if no corresponding model class is found
    puts "#{name} has no corresponding #{model_name} model class. Was not added to the Permissions table"
  end
  model  # Return the model class or nil if not found
end

# Evaluate CanCan action from action method name
def eval_cancan_action(action)
  case action.to_sym
  when :index
    name = 'list'
  when :show
    name = 'show'
  when :new, :create
    name = 'create'
    cancan_action = 'create'
  when :edit, :update
    name = 'update'
    cancan_action = 'update'
  when :delete, :destroy
    name = 'delete'
    cancan_action = 'delete'
  when :toggle_status
    name = 'toggle_status'
  else
    name = action.to_s
  end
  return name, (cancan_action || action.to_s)
end

# Create or update permission record in the database
def write_permission(model, cancan_action, name)
  Permission.find_or_initialize_by(subject_class: model, action: cancan_action) do |permission|
    permission.name = name
    permission.save
  end
end

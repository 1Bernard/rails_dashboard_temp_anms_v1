class CreateUserRoles < ActiveRecord::Migration[7.1]
  def change
    create_table :user_roles do |t|
      t.string :role_unique_code
      t.string :entity_code
      t.integer :user_id
      t.boolean :active_status, default: true
      t.boolean :del_status, default: false

      t.timestamps
    end
  end
end

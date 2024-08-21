class CreatePermissionsRoles < ActiveRecord::Migration[7.1]
  def change
    create_table :permissions_roles do |t|
      t.integer :permission_id
      t.integer :role_id

      t.timestamps
    end
  end
end

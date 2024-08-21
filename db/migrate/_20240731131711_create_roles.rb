class CreateRoles < ActiveRecord::Migration[7.1]
  def change
    create_table :roles do |t|
      t.string :name
      t.string :unique_code
      t.boolean :active_status, default: true
      t.boolean :del_status, default: false

      t.timestamps
    end
  end
end

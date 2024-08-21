class CreateEntityInfos < ActiveRecord::Migration[7.1]
  def change
    create_table :entity_infos do |t|
      t.string :assigned_code
      t.string :entity_name
      t.string :email
      t.string :contact_number
      t.integer :user_id
      t.boolean :active_status, default: true
      t.boolean :del_status, default: false

      t.timestamps
    end
  end
end

class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :email
      t.string :username
      t.string :firstname
      t.string :lastname
      t.string :other_names
      t.string :image_path
      t.string :mobile_number
      t.integer :creator_id
      t.boolean :active_status, default: true
      t.boolean :del_status, default: false

      t.timestamps
    end
  end
end
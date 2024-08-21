class CreatePermissions < ActiveRecord::Migration[7.1]
  def change
    create_table :permissions do |t|
      t.string :subject_class
      t.string :action
      t.string :name

      t.timestamps
    end
  end
end

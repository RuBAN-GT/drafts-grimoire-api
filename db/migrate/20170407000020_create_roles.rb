class CreateRoles < ActiveRecord::Migration[5.0]
  def change
    create_table :roles do |t|
      t.string :name, :null => false
      t.string :display_name, :default => ''

      t.timestamps
    end

    add_index :roles, :name, :unique => true
  end
end

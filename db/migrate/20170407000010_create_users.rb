class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table(:users) do |t|
      # Bungie
      t.string :membership_id, :null => false
      t.string :display_name, :null => false
      t.string :unique_name, :null => false
      t.string :destiny_membership_id, :null => false
      t.string :membership_type, :default => '2'

      # Trackable
      t.datetime :last_request_at
      t.string   :last_request_ip

      t.timestamps
    end
  end
end

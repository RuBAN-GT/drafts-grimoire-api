class UsersHaveAndBelongToManyRoles < ActiveRecord::Migration[5.0]
  def self.up
    create_table :users_roles, :id => false do |t|
      t.references :user
      t.references :role
    end

    execute "ALTER TABLE users_roles ADD PRIMARY KEY (user_id, role_id);"
  end

  def self.down
    drop_table :users_roles
  end
end

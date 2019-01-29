Role.destroy_all

Role.create!(
  :name => 'admin',
  :display_name => 'Администратор'
) rescue nil

p 'Roles was created'

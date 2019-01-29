namespace :db do
  desc 'A full recreationg of database with new migration'
  task :rebuild => :environment do
    Rake::Task['db:drop'].invoke
    Rake::Task['db:create'].invoke
    Rake::Task['db:migrate'].invoke
    Rake::Task['db:setup'].invoke
  end
end

require 'dm-migrations'
require_relative '../lib/classless_mud'

namespace :db do
  desc 'Sets up the sqlite database with needed migrations from the data model'
  task :setup do
    ClasslessMud.setup_db!
    DataMapper.auto_upgrade!
  end
end

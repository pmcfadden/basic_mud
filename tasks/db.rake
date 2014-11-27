require_relative '../lib/classless_mud'
namespace :db do
  task :setup do
    DataMapper::Logger.new($stdout, :debug)
    db_name = YAML.load_file('conf/settings.yml')['db']['name']
    DataMapper.setup :default, "sqlite3://#{Dir.pwd}/#{db_name}"
    DataMapper.finalize
    DataMapper.auto_migrate!

  end
end

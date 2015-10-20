require 'rspec'
require 'moodle2cc'
Dir["./spec/support/**/*.rb"].sort.each {|f| require f}

RSpec.configure do |c|
  c.after :each do
    Moodle2CC::Moodle2Converter::Migrator.clear_unique_id_set!
  end
end

def fixture_path(path)
  File.join(File.expand_path("../../test/fixtures", __FILE__), path)
end

def moodle2_backup_dir
  fixture_path(File.join('moodle2', 'backup'))
end
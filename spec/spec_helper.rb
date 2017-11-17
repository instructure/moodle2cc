require 'rspec'
require 'moodle2cc'
Dir["./spec/support/**/*.rb"].sort.each {|f| require f}

RSpec.configure do |c|
  c.before :suite do
    # info log activity is logged but not printed by default, but can be
    # triggered to print by toggling the print_finalize flag
    Moodle2CC::OutputLogger.logger = SpecLogger.new
    Moodle2CC::OutputLogger.logger.print_finalize = false
  end

  c.after :each do
    Moodle2CC::Moodle2Converter::Migrator.clear_unique_id_set!
  end

  c.after :suite do
    Moodle2CC::OutputLogger.logger.finalize
  end
end

def fixture_path(path)
  File.join(File.expand_path("../../test/fixtures", __FILE__), path)
end

def moodle2_backup_dir
  fixture_path(File.join('moodle2', 'backup'))
end

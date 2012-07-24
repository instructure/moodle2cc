# Moodle2CC

moodle2cc will convert Moodle 1.9 backup files into IMS Common Cartridge 1.1
formatted files. 

Moodle information: http://moodle.org/

Common Cartridge information: http://www.imsglobal.org/cc/index.html

## Installation

### Command line-only use
Install RubyGems on your system, see http://rubygems.org/ for instructions.
Once RubyGems is installed you can install this gem:

    $ gem install moodle2cc

### For use in a Ruby application

Add this line to your application's Gemfile:

    gem 'moodle2cc'

And then execute:

    $ bundle

## Usage

### Command Line

    For Common Cartridge format
    $ moodle2cc migrate <path-to-moodle-backup> <path-to-cc-export-directory>

    For Canvas Common Cartridge format
    $ moodle2cc migrate --format=canvas <path-to-moodle-backup> <path-to-cc-export-directory>

### Ruby Application

```ruby
require 'moodle2cc'
migrator = Moodle2CC::Migrator.new moodle_zip_path, destination_bath
migrator.migrate
```

## Contributing

Run the tests:

    $ bundle exec rake

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

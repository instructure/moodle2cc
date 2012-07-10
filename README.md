# Moodle2CC

moodle2cc will convert Moodle 1.9 backup files into IMS Common Cartridge
formatted files.

## Installation

Add this line to your application's Gemfile:

    gem 'moodle2cc'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install moodle2cc

## Usage

    $ moodle2cc migrate <path-to-moodle-backup> <path-to-cc-export-directory>

## Contributing

Run the tests:

    $ bundle exec rake

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

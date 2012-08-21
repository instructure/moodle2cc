# Moodle2CC

moodle2cc will convert Moodle 1.9 backup files into IMS Common Cartridge 1.1
formatted files. 

Moodle information: http://moodle.org/

Common Cartridge information: http://www.imsglobal.org/cc/index.html

Use the [Github Issues](https://github.com/instructure/moodle2cc/issues?state=open)
for feature requests and bug reports.

## Installation/Usage

### Command line
Install RubyGems on your system, see http://rubygems.org/ for instructions.
Once RubyGems is installed you can install this gem:

    $ gem install moodle2cc

Convert a moodle .zip into Common Cartridge format

    $ moodle2cc migrate <path-to-moodle-backup> <path-to-cc-export-directory>

Or into a Canvas-enhanced Common Cartridge format

    $ moodle2cc migrate --format=canvas <path-to-moodle-backup> <path-to-cc-export-directory>

### In a Ruby application

Add this line to your application's Gemfile and run `bundle`:

    gem 'moodle2cc'

Require the library in your project and use the migrator:

```ruby
require 'moodle2cc'
migrator = Moodle2CC::Migrator.new moodle_zip_path, destination_bath
migrator.migrate
```

## Caveats

Common Cartridge (CC) does not support all of the concepts in a Moodle course. 
CC has no concepts such as assignments or wiki pages, so these things have to
fit into Common Cartridge as best they can. Here are some of the decisions we 
made about these things:

<table>
  <tr>
    <th>Moodle</th>
    <th>Common Cartridge</th>
  </tr>
  <tr>
    <td>Course Files</td>
    <td>All files are in the `web_resources` folder, links to files in HTML are 
    referenced relative to that directory with the token `$IMS_CC_FILEBASE$`.</td>
  </tr>
  <tr>
    <td>Assignments</td>
    <td>HTML pages in an `assignments` subfolder in `web_resources`. The description 
    of the assignment is the body of the page and stuff like points possible are
    in meta fields.</td>
  </tr>
  <tr>
    <td>Wiki Pages</td>
    <td>HTML pages in a `pages` subfolder in `web_resources`.</td>
  </tr>
  <tr>
    <td>Discussion Topics</td>
    <td>The titles and bodies of topics are intact in the conversion.</td>
  </tr>
  <tr>
    <td>Grade Items</td>
    <td>If the grade item is attached to an assignment its data will be in the
    meta data of the assignment's HTML page. Otherwise it isn't currently converted.</td>
  </tr>
  <tr>
    <td>Assessments (quizzes)</td>
    <td>TODO - Coming soon! Only the CC-supported question types will be converted
    to QTI as documented <a href="http://www.imsglobal.org/cc/ccv1p1/imscc_profilev1p1-Implementation.html#_Toc285616469">here</a> </td>
  </tr>
  <tr>
    <td>Question Categories</td>
    <td>TODO - Coming soon! Common Cartridge only supports having a single question bank, so all banks
    will be combined into one. <a href="http://www.imsglobal.org/cc/ccv1p1/imscc_profilev1p1-Implementation.html#_Toc285616457">CC Question Bank Docs</a> </td>
  </tr>
</table>

## Todo

 * Support exporting to CC 1.2
 * Quiz conversion
 * Question Category conversion
 * LTI configurations?
 * Convert more Moodle features as requested

## Contributing

Run the tests:

    $ bundle exec rake

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

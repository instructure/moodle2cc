require 'zip/zipfilesystem'

module TestHelper
  def create_moodle_backup_zip
    moodle_backup_path = File.expand_path("../tmp/moodle_backup.zip", __FILE__)
    Zip::ZipFile.open(moodle_backup_path, Zip::ZipFile::CREATE) do |zipfile|
      zipfile.add("moodle.xml", File.expand_path("../fixtures/moodle_backup/moodle.xml", __FILE__))
      zipfile.add("course_files/test.txt", File.expand_path("../fixtures/moodle_backup/course_files/test.txt", __FILE__))
      zipfile.add("course_files/folder/test.txt", File.expand_path("../fixtures/moodle_backup/course_files/folder/test.txt", __FILE__))
    end
    moodle_backup_path
  end

  def stub_moodle_backup
    @export_dir = File.expand_path("../tmp", __FILE__)
    @backup = Moodle2CC::Moodle::Backup.new
    @backup.backup_file = create_moodle_backup_zip
    @backup.files = ["test.txt", "folder/test.txt"]

    course = Moodle2CC::Moodle::Course.new
    course.id = 123
    course.fullname = "My Course"
    course.shortname = "EDU 101"
    course.startdate = 1339390800
    course.visible = true

    @backup.course = course

    sections = []

    section = Moodle2CC::Moodle::Section.new
    section.id = 12345
    section.number = 0
    section.summary = 'This is the Syllabus'
    section.course = course
    sections << section

    mods = []
    mod = Moodle2CC::Moodle::Section::Mod.new
    mod.instance_id = 987
    mod.indent = 0
    mod.section = section
    mods << mod
    mod = Moodle2CC::Moodle::Section::Mod.new
    mod.instance_id = 876
    mod.indent = 1
    mod.section = section
    mods << mod
    section.mods = mods

    section = Moodle2CC::Moodle::Section.new
    section.id = 23456
    section.number = 1
    section.course = course
    sections << section

    mods = []
    mod = Moodle2CC::Moodle::Section::Mod.new
    mod.instance_id = 765
    mod.indent = 0
    mod.section = section
    mods << mod
    mod = Moodle2CC::Moodle::Section::Mod.new
    mod.instance_id = 654
    mod.indent = 1
    mod.section = section
    mods << mod
    section.mods = mods

    course.sections = sections

    mods = []
    mod = Moodle2CC::Moodle::Mod.new
    mod.id = 987
    mod.mod_type = "assignment"
    mod.name = "Create a Rails site"
    mod.description = "<h1>Hello World</h1>"
    mod.course = course
    mods << mod

    mod = Moodle2CC::Moodle::Mod.new
    mod.id = 876
    mod.mod_type = "resource"
    mod.name = "About Your Instructor"
    mod.type = "file"
    mod.reference = "http://en.wikipedia.org/wiki/Einstein"
    mod.course = course
    mods << mod

    mod = Moodle2CC::Moodle::Mod.new
    mod.id = 765
    mod.mod_type = "forum"
    mod.type = "news"
    mod.name = "Announcements"
    mod.intro = "General news and announcements"
    mod.course = course
    mods << mod

    mod = Moodle2CC::Moodle::Mod.new
    mod.id = 654
    mod.mod_type = "label"
    mod.name = "label123"
    mod.content = "Section 1"
    mod.course = course
    mods << mod

    mod = Moodle2CC::Moodle::Mod.new
    mod.id = 543
    mod.mod_type = "resource"
    mod.name = "Instructor Resources"
    mod.type = "html"
    mod.alltext = "<p><strong>Instructor Resources</strong></p>"
    mod.course = course
    mods << mod

    course.mods = mods

    @converter = Moodle2CC::CC::Converter.new @backup, @export_dir
    @converter.convert
  end

  def clean_tmp_folder
    Dir[File.expand_path("../tmp/*", __FILE__)].each do |file|
      FileUtils.rm_r file
    end
  end
end

require 'zip'

class Moodle2CC::Moodle2::Extractor




  def initialize(zip_path)
    @zip_path = zip_path
  end

  def extract
    Dir.mktmpdir do |work_dir|
      extract_zip(work_dir)
      course = Moodle2CC::Moodle2::CourseParser.new(work_dir).parse
      parse_sections(work_dir, course)
      course
    end
  end

  private

  def extract_zip(work_dir)
    Zip::File.open(@zip_path) do |zip_file|
      zip_file.each do |f|
        f_path=File.join(work_dir, f.name)
        FileUtils.mkdir_p(File.dirname(f_path))
        zip_file.extract(f, f_path) unless File.exist?(f_path)
      end
    end
  end

  def parse_sections(work_dir, course)
    if sections = Moodle2CC::Moodle2::SectionParser.new(work_dir).parse
      course.sections += sections
    end
  end


end
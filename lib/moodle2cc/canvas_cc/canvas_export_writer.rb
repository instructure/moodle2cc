class Moodle2CC::CanvasCC::CanvasExportWriter

  CANVAS_EXPORT_FILE = 'canvas_export.txt'

  def initialize(work_dir)
    @work_dir = work_dir
  end

  def write
    File.open(File.join(@work_dir, Moodle2CC::CanvasCC::CartridgeCreator::COURSE_SETTINGS_DIR, CANVAS_EXPORT_FILE), 'w' )do |f|
      f.write("Q: What did the panda say when he was forced out of his natural habitat?\nA: This is un-BEAR-able")
    end
  end


end
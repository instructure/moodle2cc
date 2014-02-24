class Moodle2CC::CanvasCC::Model::CanvasFile < Moodle2CC::CanvasCC::Model::Resource

  WEB_CONTENT_TYPE = 'webcontent'
  FILE_ID_POSTFIX = '_FILE'

  attr_reader :identifier, :type, :file_path
  attr_accessor :file_location

  def initialize
    super
    @type = WEB_CONTENT_TYPE
  end

  def file_path=(file_path)
    self.href = "#{WEB_CONTENT_TYPE}/#{file_path}"
    self.files << self.href
    @file_path = file_path
  end

  def identifier=(identifier)
    @identifier = "CC_#{Digest::MD5.hexdigest(identifier.to_s)}#{FILE_ID_POSTFIX}"
  end

end
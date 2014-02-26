class Moodle2CC::CanvasCC::Model::CanvasFile < Moodle2CC::CanvasCC::Model::Resource

  WEB_CONTENT_TYPE = 'webcontent'
  WEB_RESOURCES = 'web_resources'
  FILE_ID_POSTFIX = '_FILE'

  attr_reader :identifier, :file_path
  attr_accessor :file_location

  def initialize
    super
    self.attributes[:type] = WEB_CONTENT_TYPE
  end

  def file_path=(file_path)
    self.href = "#{WEB_RESOURCES}/#{file_path}"
    self.files << self.href
    @file_path = file_path
  end

  def identifier=(identifier)
    @identifier = "CC_#{Digest::MD5.hexdigest(identifier.to_s)}#{FILE_ID_POSTFIX}"
    self.attributes[:identifier] = @identifier
  end

end
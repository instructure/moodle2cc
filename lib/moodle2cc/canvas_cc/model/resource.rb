class Moodle2CC::CanvasCC::Model::Resource

  WEB_CONTENT_TYPE = 'webcontent'

  attr_accessor :files, :href, :type
  attr_reader :identifier


  def initialize
    @files = []
  end

  def identifier=(ident)
    @identifier = "CC_#{Digest::MD5.hexdigest(ident.to_s)}"
  end

  def attributes
    {
      href: href,
      type: type,
      identifier: identifier
    }.delete_if { |_, v| v.nil? }
  end

end
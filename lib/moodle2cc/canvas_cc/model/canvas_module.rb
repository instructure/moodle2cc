class Moodle2CC::CanvasCC::Model::CanvasModule

  attr_accessor :identifier, :title, :workflow_state, :position

  def identifier=(identifier)
    @identifier = "module_#{Digest::MD5.hexdigest(identifier.to_s)}"
  end

end
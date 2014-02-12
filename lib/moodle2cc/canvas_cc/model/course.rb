class Moodle2CC::CanvasCC::Model::Course

  attr_accessor :format, :identifier, :copyright, :settings, :resources

  def initialize
    @settings = {}
    @resources = []
  end


  def method_missing(m, *args, &block)
    method = m.to_s
    if method[-1, 1] == '='
      method.chomp!('=')
      @settings[method.to_sym] = args.first
    end
    @settings[method.to_sym]
  end

end
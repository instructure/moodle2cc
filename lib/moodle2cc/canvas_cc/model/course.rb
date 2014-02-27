class Moodle2CC::CanvasCC::Model::Course

  attr_accessor :format, :identifier, :copyright, :settings, :resources, :canvas_modules, :files, :pages

  def initialize
    @settings = {}
    @resources = []
    @canvas_modules = []
    @files = []
    @pages = []
  end

  def start_at
    Moodle2CC::CC::CCHelper.ims_datetime(@settings[:start_at]) if @settings[:start_at]
  end


  def conclude_at
    Moodle2CC::CC::CCHelper.ims_datetime(@settings[:conclude_at]) if @settings[:conclude_at]
  end

  def identifier=(identifier)
    @identifier = "CC_#{Digest::MD5.hexdigest(identifier.to_s)}"
  end

  def all_resources
    @resources + @files + @pages
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
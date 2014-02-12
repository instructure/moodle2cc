class Moodle2CC::CanvasCC::Model::Resource

  attr_accessor :attributes, :files

  def initialize
    @attributes = {}
    @files = []
  end

  def method_missing(m, *args, &block)
    method = m.to_s
    if method[-1, 1] == '='
      method.chomp!('=')
      @attributes[method.to_sym] = args.first
    end
    @attributes[method.to_sym]
  end

end
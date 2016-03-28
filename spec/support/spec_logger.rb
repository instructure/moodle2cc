class SpecLogger
  LOG_TYPES = %w(debug info warn error fatal)
  attr_accessor :messages
  attr_accessor :print_finalize

  def initialize
    @messages = {}
    @print_finalize = false
  end

  # def info(msg)
  #   messages['info'] ||= []
  #   messages['info'] << msg
  # end

  LOG_TYPES.each do |name|
    class_eval <<-RUBY, __FILE__, __LINE__ + 1
      def #{name}(msg)
        messages['#{name}'] ||= []
        messages['#{name}'] << [msg, caller]
      end
    RUBY
  end

  def finalize
    return unless print_finalize
    return if messages.empty?

    puts "\n"
    LOG_TYPES.each do |name|
      if msgs = messages[name]
        puts "\n*** Messages for type #{name} ***"
        msgs.each do |msg, loc|
          puts "\n#{msg}"
          loc.reject{|l| l =~ /rspec/ }.each{|l| puts l}
        end
      end
    end
  end
end

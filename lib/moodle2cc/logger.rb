module Moodle2CC
  class Logger
    def self.logger
      Thread.current[:__moodle2cc_logger__] || ::Logger.new(STDOUT)
    end

    def self.logger=(logger)
      Thread.current[:__moodle2cc_logger__] = logger
    end

    def self.add_warning(message, exception)
      if logger.respond_to? :add_warning
        logger.add_warning(message, exception)
      elsif logger.respond_to? :warn
        log = "#{message}\n    #{exception.message}\n"
        if exception.backtrace
          exception.backtrace.each { |line| log << "    #{line}\n" }
        end
        logger.warn log
      end
    end
  end
end

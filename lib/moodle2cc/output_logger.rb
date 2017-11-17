module Moodle2CC
  # Note: the public interface for Moodle2CC::Logger is really #add_warning,
  # which tries that method on the logger and then falls back to a more
  # standard #warm method.  But it really doesn't expect the logger to
  # implement the standard logger interface. Eventually it should probably be
  # renamed to something else, and this class should be renamed to just Logger
  # (once usage of the existing logger is moved over).  OR potentially they
  # could be combined so that "warn" level has special functionality.
  class OutputLogger
    def self.logger
      Thread.current[:__moodle2cc_output_logger__] ||= ::Logger.new(STDOUT)
    end

    def self.logger=(logger)
      Thread.current[:__moodle2cc_output_logger__] = logger
    end
  end
end

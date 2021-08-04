module Cromand
  # Provides the base class for more concrete command classes. Command is a
  # generic with the type parameter dictating the type that is returned as the
  # value for the result generated when the command is executed.
  class Command(T)
    # Derived classes should override this method to implement the actual
    # functionality for the command. The output from this command should be a
    # Result instance for the command execution. Generally you would not call
    # this method directly but would instead call the #run() method which will
    # perform validation and then invoke this method if and only if validation
    # was successful.
    def execute : Crommand::Result(T)
      Crommand::Result(T).new
    end

    # Called to run the command instance. Performs validation of the Command
    # data before running the execute() method. Will not run the execute()
    # method if validation returns any errors. This method should generally
    # NOT be overridden by derived classes.
    def run : Crommand::Result(T)
      errors = validate()
      errors.empty? ? self.execute : Crommand::Result(T).new(errors)
    end

    # Derived classes should override this method to provide functionality that
    # validates the data for the command. The output from this method will be
    # an Array of Strings. If this Array is empty then validation will be
    # considered to have succeeded. If the Array is not empty then validation
    # will be considered to have failed and the String's contained in the
    # Array will be used to create Cromand::Error instance for the Result
    # generated.
    def validate : Array(String)
      Array(String).new
    end
  end
end

module Crommand
  # A struct representing an error that occurred during the execution of a
  # Command instance.
  struct Error
    getter message : String

    def initialize(@message : String)
    end
  end

  # This class represents the results of running a command. It can be used
  # to test the outcome of the command execution and retrieve errors in the
  # case of failure.
  class Result(T)
    # Instance data.
    getter errors : Array(Error) = [] of Error
    @value : T? = nil

    # Create a new Result instance with no errors and a nil value.
    def initialize
    end

    # Create a new Result instance with no errors and the value specified.
    def initialize(@value : T)
    end

    # Create a Result instance with the errors and values specified.
    def initialize(@errors : Array(Error))
    end

    # Create a Result instance with the errors and values specified.
    def initialize(@errors : Array(Error), @value : T)
    end

    # Create a Result instance with the errors and values specified.
    def initialize(errors : Array(String))
      @errors = errors.map { |e| Error.new(e) }
    end

    # Create a Result instance with the errors and values specified.
    def initialize(errors : Array(String), @value : T)
      @errors = errors.map { |e| Error.new(e) }
    end

    # Tests whether a Result contains any errors.
    def failed? : Bool
      errors.size > 0
    end

    # Fetches a list of the error strings for a Result instance.
    def messages : Array(String)
      failed? ? errors.map(&.message) : Array(String).new
    end

    # Tests whether a Result contains no errors.
    def success? : Bool
      errors.size == 0
    end

    # Fetches the value associated with a Result instance.
    def value : T?
      value { }
    end

    # Fetches the value associated with a Result instance. If a block is given
    # then this block will be invoked if and only if the value for the Result
    # is not nil.
    def value : T?
      yield(@value) if !@value.nil?
      @value
    end
  end
end

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

    def initialize
    end

    def initialize(@value : T)
    end

    def initialize(@errors : Array(Error))
    end

    def initialize(errors : Array(String))
      @errors = errors.map { |e| Error.new(e) }
    end

    def failed? : Bool
      errors.size > 0
    end

    def messages : Array(String)
      failed? ? errors.map(&.message) : Array(String).new
    end

    def success? : Bool
      errors.size == 0
    end

    def value : T?
      value { }
    end

    def value : T?
      yield(@value) if !@value.nil?
      @value
    end
  end
end

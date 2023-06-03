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
    getter returned : Crommand::Optional(T)

    # Create a new Result instance with no errors and a nil value.
    def initialize
      @returned = Crommand::Nothing(T).new
    end

    # Create a new Result instance with no errors and the value specified.
    def initialize(value : T)
      @returned = Crommand::Something.new(value)
    end

    # Create a Result instance with the errors and values specified.
    def initialize(@errors : Array(Error))
      @returned = Crommand::Nothing(T).new
    end

    # Create a Result instance with the errors and values specified.
    def initialize(@errors : Array(Error), value : T)
      @returned = Crommand::Something(T).new(value)
    end

    # Create a Result instance with the errors and values specified.
    def initialize(errors : Array(String))
      @returned = Crommand::Nothing(T).new
      @errors = errors.map { |e| Error.new(e) }
    end

    # Create a Result instance with the errors and values specified.
    def initialize(errors : Array(String), value : T)
      @returned = Crommand::Something(T).new(value)
      @errors = errors.map { |e| Error.new(e) }
    end

    # Tests whether a Result contains any errors.
    def failed? : Bool
      errors.size > 0
    end

    # Tests whether the result contains a returned value.
    def has_value? : Bool
      returned.set?
    end

    # Invokes a supplied block, passing it the value returned through the
    # result if a value has been set. Does nothing if a value has not been
    # set.
    def if_set : Result(T)
      with self yield(value) if returned.set?
      self
    end


    # Invokes a supplied block if a value has not been set. Does nothing if
    # a value has been set.
    def if_unset : Result(T)
      with self yield if !returned.set?
      self
    end

    # Fetches a list of the error strings for a Result instance.
    def messages : Array(String)
      failed? ? errors.map(&.message) : Array(String).new
    end

    # Tests whether a Result contains no errors.
    def success? : Bool
      errors.size == 0
    end

    # Shortcut mechanism for accessing the value returned through the result.
    # This will raise an exception if called for a result with no value.
    def value : T
      returned.value
    end

    # Shortcut mechanism for accessing the value returned through the result.
    # If the result has a value set then it will be returned, otherwise this
    # method returns nil.
    def value? : T|Nil
      returned.set? ? returned.value : nil
    end

    # Creates a Result with a value type of T from a set of errors.
    def self.fail(errors : Array(String))
      Result(T).new(errors)
    end
  end
end

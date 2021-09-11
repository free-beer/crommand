module Crommand
  # An abstract base class for the optional types. An optional represents a
  # value that may or may not have been set.
  abstract class Optional(T)
    # Used to test whether the optional has a value available or not. THis
    # default implementation returns false.
    def set? : Bool
      false
    end

    # Calling this method and passing it a block will result in the mthod
    # yielding the optional value if and only it it has been set. This method
    # returns self to allow for chaining.
    def if_set(&block) : Optional
      with self yield value if set?
      self
    end

    # Calling this method and passing it a block will result in the mthod
    # yielding to the block if and only it it has not been set. This method
    # returns self to allow for chaining.
    def if_unset : Optional
      with self yield if !set?
      self
    end

    # An abstract method that derived classes must provide an implementation
    # for.
    abstract def value : T
  end

  # An implementation of the Optional class that represents an optional with no
  # value set.
  class Nothing(T) < Optional(T)
    # This method always raises an exception to indicate that you should not be
    # requesting a value from a Nothing.
    def value : T
      raise OptionalError.new("Value requested from a Nothing optional.")
    end
  end

  # An implementation of the Optional class the represents an optional with
  # a value set.
  class Something(T) < Optional(T)
    # Instance data.
    @value : T

    # Constructor that takes the value to be set.
    def initialize(@value : T)
    end

    # Always returns true.
    def set? : Bool
      true
    end

    # Retrieves the value associated with the Something instance.
    def value : T
      @value
    end
  end
end

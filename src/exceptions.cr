module Crommand
  # A base type for the exceptions that the Crommand library can generate.
  class CrommandException < ::Exception
  end

  # An exception type used by the library optional functionality.
  class OptionalError < CrommandException
  end
end

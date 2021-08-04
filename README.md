# crommand

Crommand is an implementation of the Command design pattern for the Crystal
programing language. Crommand draws inspiration from the
[mutations](https://github.com/cypriss/mutations) Ruby library, adapting it
to the Crystal way of doing things.

The Command pattern allows you to encapsulate the code for handling a specific
piece of functionality so that you gain the following advantages...

 - You decouple the invocation location from the functional implementation.
 - You can re-use the command across multiple locations or even different
   applications.
 - You incorporate the verification functionality for the command data with
   the command itself (while still keeping it separate from the actual code
   that the command does).

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     crommand:
       github: free-beer/crommand
   ```

2. Run `shards install`

## Usage

You first need to require the library into your source...

```crystal
require "crommand"
```

Once there you can use the library to create a Command classes that encapsulate
aspects of functionality. For example, say you had a requirement to receive in
a collection of data artifacts which need to be verified before they are then
used to create a number of database records and finally return the id for one of
the records created, you might do something like this...

```crystal
  class MyCommand < Command(Int64)
    # Command instance data.
    getter account_no : String
    getter email : String
    getter first_name : String
    getter last_name : String
    getter telephone : String

    def initialize(@account_no, @email, @first_name, @last_name, @telephone)
    end

    def execute
       # ... actual work of record creation done here ...
       Crommand::Result.new(record.id)
    end

    def validate()
      errors = Array(String).new
      # Check the email address provided.
      errors << "Email address cannot be blank." if email.blank?
      errors << "Invalid email address specified." if !EMAIL_PATTERN.match?(email)
      # ... more validations ...
      errors
    end
  end
```

Here we've defined a command that accepts a number of data elements (account_no,
email, first_name etc.). These are passed to the Command instance when it is
constructed and will be the focus of the ``validate()`` method were we check
that the data provided meets the needs of the functionality to be executed
_before_ it gets executed. Finally the ``execute()`` method would contain the
core functionality for the Command.

To make use of this we would instantiate the Command and then invoked the
``run()`` method on it. Command is a generic class that takes a type that will
be the value returned from the Command execution (if such is needed). To run the
Command you would do something like this...

```crystal
  command = MyCommand.new("123456789", "some.one@somewhere.com", "John", "Smith", "+3531234567")
  result = command.run
  if result.success?
    # ... run code for successful execution here ...
  else
    # ... run error handler code here ...
  end
```

As mentioned, a Command can return a value as part of it's output and this too
can be accessed via the Result received from a call to ``run()``. This output
can be accessed via a call to the ``value()`` method on the Result object. The
type of this value is based on the type specified when defining your Command
class. There is always the possibility for this value to be ``nil`` (there may
be no result in the case of failure for example). If you want to run code if and
only if this value has been set then you can do so by passing a block to the
``value()`` method and this block will only be invoked if the Result value is
not nil, like this...

```crystal
   result = command.run
   result.value do |v|
     # ... v will not be nil here ...
   end
```

If you simply do not wish to pass anything back from the execution of your
Command class you can create a Result instance using the default constructor
to create a success result with a nil value like this...

```crystal
  Crommand::Result.new
```

## Contributing

1. Fork it (<https://github.com/free-beer/crommand/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Peter Wood](https://github.com/free-beer) - creator and maintainer

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
  class MyCommand < Crommand::Command(Int64)
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
       success(record.id)
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
can be accessed via a call to the ``returned()`` method on the Result object.
THis will be an instance of the Crommand::Optional class which may or may not
contain an actual value. To test if a value is present you can call the ``set?()``
method. A shortcut mechanism is provided for this on the ``Result`` class itself.
You can call the ``value()`` method to access the value within the ``Result``
instance but this will raise an exception if a value has not been set. Alternatively
you can call the ``value?()`` method that returns the value if one is set or ``nil``
otherwise.

Another option would be to use either or both of the ``#if_set()`` or ``#if_unset()``
methods. Both of these method accept a block and the block will only get invoked
if the result has a set value or doesn't have a set value respectively. The block
for the ``if_set()`` method will be passed the value set as a parameter. Both of these
method return a reference to the result itself, allowing for chaining. So, if you
want to run code based on whether you received a result value you could do so like
this...

```crystal
   result = command.run
   result.if set {|v| # ... v will be the value set ...}.if_unset {...}
```

If you simply do not wish to pass anything back from the execution of your
Command class you can create a Result instance using the default constructor
to create a success result with a nil value like this...

```crystal
  Crommand::Result(Int32).new
```

This approach requires you to explicitly specify the return type for the ``Result``
instance. Alternatively there are some convenience methods within the ``Command``
class that allow for the generation of an appropriate ``Result`` value that can then
be returned from your ``execute()`` method. Some examples of these are shown below...

```crystal
  success                   # Create a result with no set value.
  success(1234)             # Create a result with a value of 1234.
  fail("Error message.")    # Create a fail result with the given error message.
  fail(["First error.",     # Create a fail result with the given error messages.
        "Second error."])
```

## Contributing

1. Fork it (<https://github.com/free-beer/crommand/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Peter Wood](https://github.com/free-beer) - creator and maintainer

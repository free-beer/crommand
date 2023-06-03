require "./spec_helper"

Spectator.describe Crommand::Result do
  describe "construction" do
    describe "with no parameters" do
      it "creates a new Result with a nil value and no errors" do
        result = Crommand::Result(Int32).new
        expect(result.returned.set?).to be_false
        expect(result.errors.empty?).to be_true
      end
    end

    describe "with a value parameter" do
      it "creates a new Result with the specified value and no errors" do
        result = Crommand::Result(Int32).new(123)
        expect(result.returned.value).to eq 123
        expect(result.errors.empty?).to be_true
      end
    end

    describe "with an array of Crommand::Error instances" do
      describe "and no value parameter" do
        it "creates a new Result with a nil value and the specific errors" do
          result = Crommand::Result(Int32).new([Crommand::Error.new("A test error.")])
          expect(result.returned.set?).to be_false
          expect(result.errors.empty?).to be false
          expect(result.errors.first.message).to eq "A test error."
        end
      end

      describe "and specifying the value parameter" do
        it "creates a new Result with the specified value and the specific errors" do
          result = Crommand::Result(Int32).new([Crommand::Error.new("A test error.")], 456)
          expect(result.returned.value).to eq 456
          expect(result.errors.empty?).to be false
          expect(result.errors.first.message).to eq "A test error."
        end
      end
    end

    describe "with an array of Strings" do
      describe "and no value parameter" do
        it "creates a new Result with a nil value and the errors for each string specified" do
          result = Crommand::Result(Int32).new(["A test error."])
          expect(result.returned.set?).to be_false
          expect(result.errors.empty?).to be false
          expect(result.errors.first.message).to eq "A test error."
        end
      end

      describe "and specifying the value parameter" do
        it "creates a new Result with the specified value and the errors for each string specified" do
          result = Crommand::Result(Int32).new(["A test error."], 987)
          expect(result.returned.value).to eq 987
          expect(result.errors.empty?).to be false
          expect(result.errors.first.message).to eq "A test error."
        end
      end
    end

    describe "using the #fail() class method" do
      it "returns a failed result with the errors specified" do
        result = Crommand::Result(Int32).fail(["First message.", "Second message.", "Third message."])
        expect(result.has_value?).to eq false
        expect(result.errors.empty?).to eq false
        expect(result.messages).to eq ["First message.", "Second message.", "Third message."]
      end
    end
  end

  describe "#failed?()" do
    it "returns true for a Result instance that has errors" do
      result = Crommand::Result(Int32).new([Crommand::Error.new("A test error.")])
      expect(result.failed?).to be_true
    end

    it "returns false for a Result instance that has no errors" do
      result = Crommand::Result(Int32).new
      expect(result.failed?).to be_false
    end
  end

  describe "#messages()" do
    it "returns an empty array for a successful result" do
      result = Crommand::Result(Int32).new
      expect(result.messages.empty?).to be_true
    end

    it "returns an array of error message strings for a failed result" do
      result = Crommand::Result(Int32).new([Crommand::Error.new("First error."), Crommand::Error.new("Second error.")])
      expect(result.messages.size).to eq 2
      expect(result.messages.first).to eq("First error.")
      expect(result.messages.last).to eq("Second error.")
    end
  end

  describe "#success?()" do
    it "returns true for a Result instance that has no errors" do
      result = Crommand::Result(Int32).new
      expect(result.success?).to be_true
    end

    it "returns false for a Result instance that has errors" do
      result = Crommand::Result(Int32).new([Crommand::Error.new("A test error.")])
      expect(result.success?).to be_false
    end
  end

  describe "#returned()" do
    it "returns nil for a failed result" do
      result = Crommand::Result(Int32).new([Crommand::Error.new("First error."), Crommand::Error.new("Second error.")])
      expect(result.returned.set?).to be_false
    end

    it "returns the value specified for a sucess result" do
      result = Crommand::Result(Int32).new(432)
      expect(result.returned.value).to eq(432)
    end

    it "returns nil where an explicit result was not specified" do
      result = Crommand::Result(Int32).new
      expect(result.returned.set?).to be_false
    end
  end

  describe "#has_value?()" do
    it "returns true when a result has a value" do
      result = Crommand::Result(Int32).new(1234)
      expect(result.has_value?).to eq true
    end

    it "returns false when a result has a value" do
      result = Crommand::Result(String).fail(["Error message."])
      expect(result.has_value?).to eq false
    end
  end

  describe "#value()" do
    it "returns the contain value where one is available" do
      result = Crommand::Result(Int32).new(1234)
      expect(result.value).to eq(1234)
    end

    it "raises an exception where a value is not available" do
      result = Crommand::Result(Float64).fail(["Error message."])
      expect_raises {
        result.value
      }
    end
  end
end

require "./spec_helper"

Spectator.describe Crommand::Result do
  describe "construction" do
    describe "with no parameters" do
      it "creates a new Result with a nil value and no errors" do
        result = Crommand::Result(Int32).new
        expect(result.value).to be_nil
        expect(result.errors.empty?).to be_true
      end
    end

    describe "with a value parameter" do
      it "creates a new Result with the specified value and no errors" do
        result = Crommand::Result(Int32).new(123)
        expect(result.value).to eq 123
        expect(result.errors.empty?).to be_true
      end
    end

    describe "with an array of Crommand::Error instances" do
      it "creates a new Result with a nil value and the specific errors" do
        result = Crommand::Result(Int32).new([Crommand::Error.new("A test error.")])
        expect(result.value).to be_nil
        expect(result.errors.empty?).to be false
        expect(result.errors.first.message).to eq "A test error."
      end
    end

    describe "with an array of Strings" do
      it "creates a new Result with a nil value and the errors for each string specified" do
        result = Crommand::Result(Int32).new(["A test error."])
        expect(result.value).to be_nil
        expect(result.errors.empty?).to be false
        expect(result.errors.first.message).to eq "A test error."
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

  describe "#value()" do
    it "returns nil for a failed result" do
      result = Crommand::Result(Int32).new([Crommand::Error.new("First error."), Crommand::Error.new("Second error.")])
      expect(result.value).to be_nil
    end

    it "returns the value specified for a sucess result" do
      result = Crommand::Result(Int32).new(432)
      expect(result.value).to eq(432)
    end

    it "returns nil where an explicit result was not specified" do
      result = Crommand::Result(Int32).new
      expect(result.value).to be_nil
    end

    describe "when called with a block" do
      it "yields to the block if the value is not nil" do
        output = ""
        result = Crommand::Result(String).new("RESULT!")
        result.value { |v| output = v }
        expect(output).to eq "RESULT!"
      end

      it "does not yield to the block of the value is nil" do
        output = ""
        result = Crommand::Result(String).new
        result.value { |v| output = v }
        expect(output).to eq ""
      end
    end
  end
end

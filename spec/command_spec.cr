require "./spec_helper"

class BaseTestCommand < Crommand::Command(Int32)
  getter executed : Bool = false

  def execute
    @executed = true
    Crommand::Result(Int32).new(0)
  end
end

class TestFailValidation < BaseTestCommand
  def validate : Array(String)
    ["Validation failed"]
  end
end

class TestPassValidation < BaseTestCommand
  def validate : Array(String)
    Array(String).new
  end
end

Spectator.describe Crommand::Command do
  describe "#run()" do
    it "invokes the #execute() method when validation succeeds" do
      command = TestPassValidation.new
      result = command.run
      expect(result.success?).to be_true
      expect(command.executed).to be_true
      expect(result.returned.value).to eq 0
    end

    it "does not invokes the #execute() method when validation succeeds" do
      command = TestFailValidation.new
      result = command.run
      expect(result.failed?).to be_true
      expect(command.executed).to be_false
    end
  end

  describe "#fail()" do
    it "returns a failed Result instance with specified errors set" do
      command = TestFailValidation.new
      result  = command.fail(["Error message."])
      expect(result.messages).to eq ["Error message."]
    end

    it "raises an exception if given an empty array" do
      command = TestFailValidation.new
      expect_raises {
        command.fail([] of String)
      }
    end
  end

  describe "#success()" do
    it "returns a successful Result instance with no value" do
      command = TestPassValidation.new
      expect(command.success.has_value?).to be false
    end
  end

  describe "#success()" do
    it "returns a successful Result instance with the given value" do
      command = TestPassValidation.new
      expect(command.success(123).has_value?).to be true
      expect(command.success(123).value).to eq 123
    end
  end
end

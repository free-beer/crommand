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
end

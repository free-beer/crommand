require "./spec_helper"

Spectator.describe Optional do
  describe Crommand::Nothing do
    let(option) {
      Crommand::Nothing(Int32).new
    }

    describe "#set?()" do
      it "always returns false" do
        expect(option.set?).to be_false
      end
    end

    describe "#value()" do
      it "always raises an exception" do
        expect {
          option.value
        }.to raise_error
      end
    end

    describe "#if_set()" do
      it "never yields to the provided block" do
        extracted = -1
        option.if_set { |v| extracted = v }
        expect(extracted).to eq(-1)
      end
    end

    describe "#if_unset()" do
      it "yields to the provided block" do
        extracted = -1
        option.if_unset { extracted = 1 }
        expect(extracted).to eq(1)
      end
    end
  end

  describe Crommand::Something do
    let(option) {
      Crommand::Something.new(1234)
    }

    describe "#set?()" do
      it "always returns true" do
        expect(option.set?).to be_true
      end
    end

    describe "#value()" do
      it "returns the expect value" do
        expect(option.value).to eq 1234
      end
    end

    describe "#if_set()" do
      it "yields the value to the provided block" do
        extracted = -1
        option.if_set { |v| extracted = v }
        expect(extracted).to eq(option.value)
      end
    end

    describe "#if_unset()" do
      it "never yields to the provided block" do
        extracted = -1
        option.if_unset { extracted = 1 }
        expect(extracted).to eq(-1)
      end
    end
  end
end

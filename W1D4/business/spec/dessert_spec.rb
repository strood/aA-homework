require "dessert"
require "rspec"
require "drink"

describe Dessert do
  subject(:brownie) { Dessert.new("brownie", 50) }
  let(:milk) { double("milk") } #Drink.new("milk") <= double abvoids this instantiation

  describe "#initialize" do
    it "takes in a type" do
      expect(brownie.type).to eq("brownie")
    end

    it "takes in an amount" do
      expect(brownie.amount).to eq(50)
    end

    context "has a huge amount" do
      subject(:brownie) { Dessert.new("brownie", 100000) }

      it "sets the type to the giant version" do
        expect(brownie.type).to eq("giant brownie")
      end
    end

    it "raises an error if the amount is not a number" do
      expect { Dessert.new("brownie", "big") }.to raise_error("Amount must be a number")
    end
  end

  describe "#eat" do
    it "calls #dip on the accompanying drink" do
      expect(milk).to receive(:dip).with(brownie)
      brownie.eat(milk)
    end
  end
end

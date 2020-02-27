require "sloth"

describe Sloth do
  subject(:sloth) { Sloth.new("Steve") }
  describe "#initialize" do
    it "assigns a name" do
      expect(sloth.name).to eq("Steve")
    end

    it "starts with an empty array of foods" do
      expect(sloth.foods).to eq([])
    end
  end

  describe "#eat" do
    it "adds a new food to the foods array" do
      expect(sloth.foods).to_not include("leaves")
      sloth.eat("leaves")
      expect(sloth.foods).to include("leaves")
    end
  end

  describe "#drinks" do
    before(:each) { sloth.drink("lemonade", 10) }
    it "adds the drink as a kew to the drinks hash" do
      expect(sloth.drinks).to have_key("lemonade")
    end

    it "adds the amount as a valie to the drinks hash" do
      expect(sloth.drinks).to have_value(10)
    end
  end

  describe "#run" do
    it "returns a sting that includes the direction" do
      expect(sloth.run("west")).to include("west")
    end

    it "raises an Arguement Error if the direction is invalid" do
      expect { sloth.run("all over the place") }.to raise_error(ArgumentError)
    end
  end
  #Can not test private methods with rspec
  describe "#secret_sloth" do
    it "returns a string with secret" do
      expect(sloth.secret_sloth).to include("secret")
    end
  end
end

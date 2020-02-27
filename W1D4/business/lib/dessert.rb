class Dessert
  attr_reader :type, :amount

  def initialize(type, amount)
    # @type = type
    raise "Amount must be a number" unless amount.is_a?(Integer)
    @amount = amount

    @type = amount > 100 ? "giant #{type}" : type
    # set type to amount. If greater than 100, set to "giant #{type}" else, just to type
  end

  def eat(drink)
    drink.dip(self)
  end
end

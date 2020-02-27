class Sloth
  attr_reader :name, :foods, :drinks, :run
  DIRECTIONS = %w(north south east west)

  def initialize(name)
    @name = name
    @foods = []
    @drinks = {}
  end

  def eat(food)
    @foods << food
  end

  def drink(beverage, amount)
    @drinks[beverage] = amount
  end

  def run(direction)
    raise ArgumentError unless DIRECTIONS.include?(direction)
    "I'm running #{direction} at 0.000001 miles per hour"
  end

  private

  #Cannot be tested in rspec, throws error
  def secret_sloth
    "Super secret string here"
  end
end

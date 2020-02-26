# PHASE 2
def convert_to_int(str)
  begin
    Integer(str)
  rescue StandardError => e
    puts "Something went wrong: #{e.message}"
  ensure
    nil
  end
end

# PHASE 3
FRUITS = ["apple", "banana", "orange"]

class CoffeeError < StandardError
end

def reaction(maybe_fruit)
  if FRUITS.include? maybe_fruit
    puts "OMG, thanks so much for the #{maybe_fruit}!"
  elsif maybe_fruit == "coffee"
    raise CoffeeError.new "Throwing a Coffee Error"
  else
    raise StandardError.new "Non coffee error"
  end
end

def feed_me_a_fruit
  puts "Hello, I am a friendly monster. :)"

  puts "Feed me a fruit! (Enter the name of a fruit:)"
  maybe_fruit = gets.chomp

  reaction(maybe_fruit)
rescue CoffeeError => e
  puts e.message
  retry
rescue StandardError => e
  puts e.message
end

# PHASE 4
class BestFriend
  def initialize(name, yrs_known, fav_pastime)
    raise StandardError.new "Not enough years known" if yrs_known < 5
    raise StandardError.new "Need string for name" if name.length < 1
    raise StandardError.new "Past time required" if fav_pastime.length < 1
    @name = name
    @yrs_known = yrs_known
    @fav_pastime = fav_pastime
  end

  def talk_about_friendship
    puts "Wowza, we've been friends for #{@yrs_known}. Let's be friends for another #{1000 * @yrs_known}."
  end

  def do_friendstuff
    puts "Hey bestie, let's go #{@fav_pastime}. Wait, why don't you choose. 😄"
  end

  def give_friendship_bracelet
    puts "Hey bestie, I made you a friendship bracelet. It says my name, #{@name}, so you never forget me."
  end
end

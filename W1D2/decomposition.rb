#-----------------------Decomposition into Objects

#This far in programming problems, we have been breaking problems into methods. Small
# bits of code that do one thing. his helps us manage the complexity of a complex task
# by breaking it into smaller, easily understood and digested tasks.

#Object oriented design is another way to decompose complex problems. Imagine a
# simulation of minnows and sharks: each "turn", the minnow swim away from the shark,
# the shark swims after the closest minnow.

#When decomposing a problem into objects, we look for the nouns; those are good
# candidates to use as a class (the verbs often end up as methods). Here, we could
# create a Minnow class and a Shark clas

#A Minnow and a Shark swim differently. They should both have a #swim method, but
# they should do different things.

#Finally, each Minnow and Shark have a position in the aquarium:
class Minnow
  attr_reader :position

  def initialize(initial_position)
    # save the minnow's initial position
    @position = initial_position
  end

  def swim
    # swim away from any sharks; update @position
  end
end

class Shark
  attr_reader :position

  def initialize(initial_position)
    # save the shark's initial position
    @position = initial_position
  end

  def swim
    # swim toward closest fish; update @position
  end
end

#Notice what we've done here: each Minnow or Shark keeps track of its own position.
# Stored information like a Minnow's position is called the state of an object.
# Minnows and Sharks have their own way of doing things (they both #swim differently);
# this is called behavior.

#Object oriented design is about breaking a complex problem down into classes,
# each of which is responsible for its own state and behavior. This lets us write our
# Minnow code mostly in isolation of code for the Shark or an Aquarium or Fisherman.
# Writing code in this way not only makes it more modular (and thus extensible), but
# breaking the problem down into sub-problems makes each piece easier to reason about.

#-----------------------------Choosing the right level of granularity

#We've said that we should "look for the nouns" when deciding what classes to define.
# But how do we choose the nouns? In our Shark/Minnow problem, why is Shark and Minnow
# the right level of granularity, and not an Aquarium class that is responsible for
# modeling both sharks and fishes?

#Each class should do one thing. An Aquarium tries to do two things: model fish and
# model sharks.

#How do we decide what a single responsibility is? The best way to think about it is
# this: you should define classes at the level of abstraction that you want to make
# changes at. You might want to make changes to the minnows, but not the sharks, so
# they should be separate classes.

#Rule of thumb: a large class is >125 lines of code. Sometimes that's not a design
# mistake, but it's suspicious after that. 300+ lines is a behemoth. You should start
# looking for ways to break down a class that large.

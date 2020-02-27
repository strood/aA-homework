#------------------------Exception Basics

def sqrt(num)
  unless num >= 0
    raise ArgumentError.new "Cannot take sqrt of negative number"
  end
  p "I did stuff to the num"
  # code to calculate square root...
end

#Since we can't take the square root of a negative number, we raise an
# exception instead of returning an answer. When an exception is raised,
# the method stops executing. Instead of returning, an exception is thrown.
# The method's caller then gets a chance to handle the exception:

def main
  # run the main program in a loop
  while true
    # get an integer from the user
    puts "Please input a number"
    num = gets.to_i

    begin
      sqrt(num)
    rescue ArgumentError => e
      puts "Couldn't take the square root of #{num}"
      puts "Error was: #{e.message}"
    end
  end
end

main

#If the calling method doesn't rescue (we also say catch or handle) an
# exception, it continues to bubble up the call stack. So the caller's
# caller gets a chance, then their caller, then...

#If no method throughout the entire call stack catches the exception, the
# exception is printed to the user and the program exits.

#--------------------Ensure

#Sometimes there is important code that must be executed whether an
# exception is raised or otherwise. In this case, we can use ensure.

begin
  a_dangerous_operation
rescue StandardError => e
  puts "Something went wrong: #{e.message}"
ensure
  puts "No matter what, make sure to execute this!"
end

#A common example is closing files:
f = File.open
begin
  f << a_dangerous_operation
ensure
  # must. close. file.
  f.close
end

#-----------------Rety

#A common response to an error is to try, try again.
def prompt_name
  puts "Please input a name:"
  # split name on spaces
  name_parts = gets.chomp.split

  if name_parts.count != 2
    raise "Uh-oh, finnicky parsing!"
  end

  name_parts
end

def echo_name
  begin
    fname, lname = prompt_name

    puts "Hello #{fname} of #{lname}"
  rescue
    puts "Please only use two names."
    retry
  end
end

#The retry keyword will cause Ruby to repeat the begin block from the
# beginning. It is useful for "looping" until an operation completes
# successfuly.

#-------------------------Implicit Begin Blocks

#Method and class definitions are implicitly wrapped in a begin/end block,
# so if your error handling applies to the whole method, all you have to
# add is rescue.

def slope(pos1, pos2)
  (pos2.y - pos1.y) / (pos2.x - pos1.x)
rescue ZeroDivisionError
  nil
end

#The method from the retry example could also be written this way.
def echo_name
  fname, lname = prompt_name

  puts "Hello #{fname} of #{lname}"
rescue
  puts "Please only use two names."
  retry
end

#---------------------Exception Hierarchy
# There are a number of predefined exception classes in Ruby.
# found here: http://blog.nicksieger.com/articles/2006/09/06/rubys-exception-hierarchy
#You should try to choose an appropriate class. One of the more common
# exceptions to use is ArgumentError, which signals that an argument
# passed to a method is invalid. RuntimeError is used for generic errors;
# this is probably your other goto.

#When creating an exception, you can add an error message so the user knows
# what went wrong:

raise RuntimeError.new("Didn't try hard enough")

#If you want your user to be able to distinguish different failure types
# (perhaps to handle them differently), you can extend StandardError and
# write your own:
class EngineStalledError < StandardError
end

class CollisionOccurredError < StandardError
end

def drive_car
  # engine may stall, collision may occur
end

begin
  drive_car
rescue EngineStalledError => e
  puts "Rescued from engine stalled!"
rescue CollisionOccurredError => e
  puts "Rescued from collision!"
ensure
  puts "Car stopped."
end

#-----Don't go crazy

#However, writing hardened code like this is tedious and slow. There are
# always many, many things that could go wrong, and you could spend a ton
# of time writing exception classes, raise errors, making sure to catch
# them, etc.

#For this reason, raise exceptions sparingly until you are hardening a
# project. Focus on driving out the functionality first. And don't waste
# your time imagining perverse scenarios;

#----------------How to make a Hash map-------

#Review:

#------Set (ADT)

# Denoted within hashes, {}, unique elements, not nesiscariyl ordered

# Set: [1, 2, 'hi', 0]
# .include? - O(n) -all run in O(n) as you must pass at least once trhough teh whole thing to perform the methods.
# .insert   - O(n)
# delete - O(n)

#-----Int Set
#more limited set for better runtime, could be implemented with mpore contraints, and diff data type
# Set: {2, 1, 4, 0} - only nums, no dupes allowed, how to implement?
# [T, T, T, F, T] - index represents range of number in set. true if presernt, false if not
# Indexing into an array to update/check status of number is constant time, which is quicker than scanning
# through an array

#Why indexing into an array only O(1) time? - constant time

#array is contiguously stored data in physical memory, sinlge chunk block
#if you know the first memory address of the arrray, it is a simple arithmitic operation
# to find your desired index. (ie. first mem is 908. 908 + 8*i = index i mem block) <-This op in O(1) time.
# this is called pointer arithmatic and it is efficient in computing.
#fOR AN ARRAY, BECAUSE OF THIS GUARANTEE, IT IS EFFICIEN TTO DO THIS LOOKUP IN MEMORY.

#- INSERT - O(1) time
# include - O(1)time
# delete - O(1) time

# IS THIS  NOW GOOD???????

#NOOOOOOOOOOOOOOOOOOOO

# AS n grows, or you want to use non-ints, it does not work. But with a large n, it can be bad.

# This takes up HUUUUGGEEE SPACE potentilly. {0, 10^20} <- space complexity is ruined. WAAAYY to big

#-------Fixed Set -Wont depend on range of elemtyns, work witha fixed size to save space complexity
# but still utilizing the indexing,

#{1,4,6,64,128,129} <- Not fixed
#[ , , , ,] <- Fixed
#-----------V
#{1,4,6,64,128,129} <- Want to figure out how to take these elemts and put in buckets below, and always
# be able to get them back out 100%
#[ , , , ,] <-

# Might be able to accomplish this with the % operator. Seperate them based on the differences.
# Range of this modulo function is (0....n) so if i mod them each by the number of buckets i have, i will
# end up with a range of outcomes between (0...buckets n)

#[(4,64,128), (1,129), (6), ()] <- 4 buckets with all 6 elements sorted.

#This way if you need to search for a number in the set, just modulo it by the number of buckets, then the r
# result of that is the index you then search, this narraows the search down to just thata rray at that index.
# and limits our data size on memory to 4 elements, which is better, (we still grow within each index however)

#What is the time complexity now?
# Well we still index the array at O(1), however now we still earch an array as we did before, whcih sets us back
# as we will have an average of n/k(buckets) in each array. So each array grows ot be 1/4 the size of the initial array
# this still sets us back to that initial O(n) time.

# What was our problem here? ---- Well n gets too big for k in n/k, since k doesnt grow with n
# Could you maybe gor k with n, so you could get n/n ie 1, O(1)

# {1,4,6,3,8,9,11}
#[(),(),(),()]
#  1  2  3  4

# mod each by 4,
##[(4),(1),(6),(3)]
#once you reach the bucket capacity k, ie 4.
# we will then trigger a resize, and up the number of buckets to 5
# This will require you to rehash each of the elements in the existing hash, as we would lose track otherwise.
#[(),(1,6),(),(8,3),(4)]

#Since we have to rehash, insert is now :O(n)
# But, we have increasing buckety size, so we dont have k getrting  outpaced.
# This gives us include?:O(1) and delete:O(1) - n%k , then search buket, bucket avg is <= 1, as our n/k == 1

# Could you save yourself on the insert, and insert a multiple of buckets?
# IE doubel your array on an insert?
# The amortized cost of the multiplying of the set, makes you average out to a constant amount
# By taking a long time every so often refactoring big, we get enough frr spaces to make it worth it,
# this makes us both efficiesnt at O(1) for insert, include delete.

# KEEP IN MIND. THESE STRUCTURES CAN BE CORRUPTED BY DATA THAT POSSIBLY IS NOT RANDOM AND HAS A TREND TO IT>

# Now what if we want to add non-interger values to our dataset too?

#---------------------------------HASHING
# What is it, what is a hash funct?

# Takes input, spits out an output. Any arbitrary input will hash out, and you will get the same output for that
# valuue everytime.

# We can make it so the random junk that is spit out of the function has the same length, and they are all strings,
# no matter what the input.

#Desired in a hashing function?:
# DETERMINISTIC- Everytime you hash the perticular input, you will get the EXACT SAME output.
# UNIFORM - No clumping, things not ending up in same bucket sort of scenario avoided.
# One-way, Highly sensitive. - You should get very different input, even with evry similar input. You should not
# know what the input was from the output. There are no trends, or patterns in any way shape or form.

# Types out in the wild?
# -Speed & efficiency hashesh
# Murmurhash
# Cityhash
# CRC32 Checksum
# -cryptographic hash functs: (slower than above, minimize collisions, very hard to reverse engineer.)
# MD5
# SHA52 Checksum
# - Blowfish

# Sidenote: In ruby every single object in ruby has a hash taht is implemented iwth murmurhash.
# We will call .hash on various objects to organize them.

#--------------------------------------HASH SET
#We will now bring it all together, resize our set by multiple when filled, and modulo the HASH of each object,
# in order to organize it, instead of modulo the interger, now everythign can be organized.

#{2,4,8,16,'hello','dolly'}
# take each element from above, hash it, then modulo that hash by the num of buckets.
#2 = q83947q29374 % 4 = 0
#[(2),(),(),()]\
#4 = asiufwary47 % 4 = 3
#[(2),(),(4),()]
#ect.....

# goal of the hash is to uniformly distribute inputs into buckets,(minimize collisions), (not be similar), and
# be deterministic.

# Set.new in ruby has a set implemented in this way!

# ----------Before we can fully make our Hashmap, we need one last thing

#--------------------------------------LINKED LIST

# [3]->[4]->[6]->[10] -singly linked list. one val, and one pointer(@next) on each node
# tail is the point it points at nil

# bychaining these together you can find all your elemtns.

#class Node
# def initialize(val, next = nil)
#       @val = val
#       @next = next

#operations on a singly linked list
# find(val) => iterate through until found, linear time O(n)
# push(val) => iterate through to add ot last elen, linear time O(n) -(Maybe optimize to O(1) if you save @tail)
# unshift => O(1) - easy to drop head, and just go to 2nd.

# In order to make effective changes to the linked list, need to make it DOUBLY LINKED LIST
# add @prev to the node, that way we know the before and after nodes in the list given a specific node

#this allows us to redirect pointers to delete or add nodes. Once a node not pointed to, it will be garbage collected

# With this optimizations, inser and delete O(1) time.
# If you setup your doubly linked ;ist to always have each node including a val, prev and next,
# then encase that in a val= head and val= tail to always be the defauly start or end of list so you can
# even mor eeasily traverse.

# In A Hashm,ap we need a Key and Val

# {K=>V,
#  K=>V}

# so slightly adjust your node, to now have more that val, prev, next, have:
# class Node
#     def initialize(prev, next, key, val)
#         @prev = prev
#         @next = next
#         @key = key
#         @val - val

#Hash set => Hash Map

# Instead of arrays for buskets, we will have linked lists.

#{[],[],[],[],[]}
## We will take the @key, mod by the number of buckets, then put it in the bucket, but appemnding a link to the
# linked list that is that bucket.

# This allows lookup and insert hash[k] = val operate at O(1) time as well, because we keep all the same
# benefits from the set and hash/

# Array would work almost the same as a linked list, why did we use the linked lsit? (Answer below)

# ----------------------------------------------Caching

#Simple Ex Super mario bros:
# mario running across your screen/viewport. many objects in and out of frame like
# clouds, cooins, goombas, lives. This scrrenscape must be updated consistently
# based on viewport position on marios position. This would be relly inefficient
# if we had to recalculate and redo all the elemts for each pixel.

# Biggest part of this is deciding what gets stored and what does not get used in chache
# Popular method to do is, LRU -Least Recently Used
# Cache size is 4, so as we increase things in mem, we delete things as they ar ethe oldest if we need
# more space.
# could add timestamps to each k=>k pair, so we know which one has the oldest timestamp will be the
# next to be deleted.

# Insert, enject becomes slow, read is fast, because nothig is ordered, so we need to order things.

# Could use a linked list to do this, always updating the end item as the most recently used item, swapping
# items each operastion to make sure this is maintained.
# This method gives us fast ejection and insertion, but slow read because you traverse whole ll'

# Best of both works is our cumlination. Hash map + Linked list

#---------------------------------------LRU Cache

#{mario=> [mar], bowser => [bow], goomba => [goom] }
# This makes ejection, insertion and read to all be O(1) time. Add new things to head, delete things from end
# and point to nil.
# Value of the elinked list is that it is a stable object that can always be referred in reference to other links
# so they will not lose index, and can be treated like a list at the same time.

# XOR (Exclusive OR)
# Definition
# Like AND and OR, XOR (short for 'exclusive OR') is a logical operator.

# AND means 'Both A and B'.
# OR means 'Either A or B or both'.
# XOR means 'Either A or B, but not both'.
# The 'but not both' clause is what differentiates XOR from OR. In ruby, XOR is written as ^.

# Let's look at a few examples of using XOR:

# true ^ false # true
# false ^ true # true

# false ^ false # false
# true ^ true # false

# # Compare the last example against using OR
# true || true # true
# Bit-wise XOR with numbers
# When you XOR two numbers, Ruby converts them to binary and evaluates each their corresponding digits
# (i.e. bits) using XOR where 1 is true and 0 is false. Ruby then converts the binary result back into an integer.

# For example,

# a = 2
# b = 6
# c = a ^ b # 4
# Let's examine what ruby is doing under-the-hood.

# # Converts the operators to binary
# a.to_s(2) # "10"
# b.to_s(2) # "110"

# # Bit-wise operation
# # a = 010
# # b = 110
# # xor ---
# # c = 100

# # Converts the result back to an integer
# "100".to_i(2) # 4

# # Thus,
# c == 4 # true
# In Ruby, Integer#to_s(2) converts a number to binary and String#to_i(2) converts a binary string to a number!

# Using XOR to hash
# Recall the properties of a hashing function:

# Determinism: Its output is directly determined by the input data.
# Comprehensiveness: It uses all the input data.
# Uniformity: Its possible return values are evenly distributed.
# Continuity: It returns similar values for similar inputs.
# Bit-wise XOR is often used in hashing functions because it promotes high determinism, comprehensiveness,
# and uniformity. It also has high continuity, which may need to be offset with other methods where a hashing
# function needs to have a more unpredictable 'spread' of hashed values.

# What separates XOR from other bit-wise operators is uniformity - Only XOR returns 1 and 0 in equal probability,
# given any two inputs (see truth table below). This allows it to produce more uniformly distributed values,
# distinguishing it as a desirable hashing method.

# Truth Table for Bitwise Operations
# a	b	AND	OR	XOR
# 0	0	0	0	0
# 1	0	0	1	1
# 0	1	0	1	1
# 1	1	1	1	0

## NOTES ON REGULAR EXPRESSIONS ##
- Taken from going through https://regexone.com/lesson/

REMEMBER:
- Everything is essentially a character, the goal is to write a pattern to match a specific set of characters.

Characters include normal letters, but digits as well. In fact, numbers 0-9 are also just characters and if you look at an ASCII table, they are listed sequentially.

#Backreferencing
many systems allow you to reference your captured groups by using \0 (usually the full matched text), \1 (group 1), \2 (group 2), etc. This is useful for example when you are in a text editor and doing a search and replace using regular expressions to swap two numbers, you can search for "(\d+)-(\d+)" and replace it with "\2-\1" to put the second captured number first, and the first captured number second for example.

## METACHARACTERS -denoted with the backslash \
---\ \d-  can be used in place of any digit from 0 to 9.
---\ \D - specify non-digit characters
---\ \w - can be used in place of alphanumeric characters
---\ \W - specify non-alphanumeric characters
---\ \b - boundary between word and non word char(ie \w+\b to capture full word)
--- \. the dot is a wildcard, matches any single char
---\ \s - Special whitespace matcher (Match all \t \n *space* \r(carriage rtn))
---\ \S - specify non-whitespace chars(ie punctuation)
---\ ^ , $ - start and end of line denoters. (Allows very specific line conds)
---\ () -capture group parentesis, allows extraction of string for more prcessng
---\ (()) -nested capture groups to pull out layered info, accessed outside in
---\ (|) - pipe aka logical or. give diff options of sets of characters to match


## METHODS
---\ [] -square brackets specifies just single chars
---\ [^] -square brackets w/ hat excludes chars, searching for all others
---\ [-] -add a dash to capture a range of numbers or values to exclude or incl
---\ {} -curly braces specify repetition, times item before {} occurs in row
---\ {1,3} -specify min and max range when comma added to {}
---\ * , + - represents either 0 or more or 1 or more of a char
---\ ? - Optionality of the preceding character.(Escaped w slash for finding ?)

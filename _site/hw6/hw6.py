# Name: Jake Woodlee
#
# UID: 962385088
#
# Others With Whom I Discussed Things:
#
# Other Resources I Consulted:
#
#

import sys
# DO NOT IMPORT ANYTHING OTHER THAN SYS

# Homework 6: a python query language (PyQL)
#
# In this assignment, we will use python to implement a little query
# language for CSV files. We'll write a bunch of little query objects
# that compose nicely to form larger more interesting queries.
#
# Our database is a CSV file, which forms a table similar to an Excel
# spreadsheet. Each line in the file is a row, and each row is
# separated into cells by commas.
#
# The first row contains the headers, which are the names of data
# stored in the corresponding cell of each subsequent row. In other
# words, the headers give names to each column in the table.
#
# Here's an example of a CSV table containing 2 rows of data about
# some people:
#
# Name,Age,Hair
# Steve,25,Blonde
# Bob,33,No
# Alice,27,Brown
#
# Interpretation:
# The person named Steve is 25 years old and has Blonde hair.
# The person named Bob is 33 years old and has no hair.
# The person named Alice is 27 years old and has Brown hair.
#
# I've included three CSV files to work with: people.csv,
# player_career.csv and player_career_short.csv. people.csv is
# the 3 line example shown above. The others are basketball
# statistics taken from http://www.databasebasketball.com/.
# The short version is just the first 10 lines of the first,
# which may be useful for testing).
#
# In case you're interested, the header abbreviations are
# described on the page:
# http://basketballreference.com/about/aboutstats.htm

# In the tradition of a scripting language, I've provided a
# framework for you that defines the query interface and
# implements some of the code for running queries.

# Converting between CSV rows and dictionaries
def rowStringToDict(headers, ln):
    """
    Converts a line of data a CSV to a dictionary
    mapping the column header to each column cell.
    The keys and values of the dictionary should all be strings.

    Example:

    # heads = ['Name','Age','Hair']
    # ln    = 'Steve,25,Blonde'
    # rowStringToDict(heads, ln)
    {'Name' : 'Steve', 'Age' : '25', 'Hair' : 'Blonde'}

    # Note: dictionaries are unordered, so the order of the keys could
    #       could be different than the above.
    """
    cols = ln.split(',')
    row = {}
    for i in range(len(headers)):
      try:
        row[headers[i]] = cols[i]
      except:
        # somehow we expected more columns than we got.
        # we'll just default those to the empty string ''
        row[headers[i]] = ''
    return row

def rowDictToString(headers, dict):
    """
    Converts a dictionary representation of a row back to string in CSV format.
    The headers argument determines the order of the values.

    Example:

    # heads = ['Name','Age',Hair']
    # row   = {'Name' : 'Steve', 'Age' : '25', 'Hair' : 'Blonde'}
    # rowDictToString(heads, row)
    'Steve,25,Blonde'
    """
    return ','.join((str(dict[h]) for h in headers))

#################### Running queries ########################
# The runQuery function runs a query on a CSV file.
#
# The following demonstrates everything you need to know about files
# for this homework. This prints the contents of the file "filename.txt"
# to standard output.
#
# f = open("filename.txt") # opens the file "filename.txt".
# for ln in f:             # iterate over the lines in the file.
#   ln = ln[:-1]           # remove the last character of the line, which is a newline.
#   print(ln)
#
# The for loop uses the file f as an *iterator*. File objects in python
# implement the iterator "interface". Each iteration of the loop assigns the
# next line in the file to the variable "ln".
#
# We'll talke more about iterators in class, or can read more about them at
# http://anandology.com/python-practice-book/iterators.html

def runQuery(query, lns):
    """
    This helper function runs a query, and *yields* the lines in the result.
    Yield is a special keyword in python, which allows us to easily define
    new iterators. Yield is sort of like return in that it provides a value
    to the caller. However, yield does not exit the function. Thus, we can
    yield multiple values before exiting the function, which we use here.
    This lets us use runQuery in a for loop, to iterator over the yielded
    values (see printQuery below). What's cool is that after each yield,
    runQuery is suspended and printQuery gets to run until it needs another
    value. Then runQuery runs again until it yields the next value.

    We'll discuss this stuff more in class.  :)
    """

    # yield the query's output headers.
    yield ','.join(query.output_headers)

    # process each input line
    for ln in lns:
      input_row = rowStringToDict(query.input_headers, ln)
      output_row = query.process_row(input_row)
      if(output_row != None):
          yield rowDictToString(query.output_headers, output_row)

    # did the query do any aggregation?
    # if yes, return the aggregate table
    if len(query.aggregate_headers) > 0:
      yield ''  # blank line
      yield ','.join(query.aggregate_headers)

      # only 1 row
      yield rowDictToString(query.aggregate_headers, query.get_aggregate())

def printQuery(query,lns):
    for ln in runQuery(query,lns):
        print(ln)

def openCSVFile(filename):
    f = open(filename)

    # get the input headers
    headers = f.readline().strip().split(',')

    # remove the newline from each line
    lns = (ln[:-1] for ln in f)

    return (headers,lns)


#####################  Queries ##########################
# You will define multiple small queries, which can
# be composed into larger queries. Each query works by
# processing multiple rows one by one. The query can
# update the row (by adding/removing/changing columns),
# delete the entire row, or leave it unchanged.
# The query can also do an aggregation by updating its state.
# Once all rows have been processed, we can get the result of
# the aggregation. The aggregate is always single row containing
# zero or more columns.
#
# The query interface consists of the following methods and properties:
#
# methods:
#   process_row:       ---   Process an input row (in dictionary form).
#                            Returns an updated row or None if the row
#                            is to be deleted.
#   get_aggregate:     ---   Once all input rows have been processed,
#                            return the row of aggregated values.
#
# properties:
#   input_headers      ---   the headers (column names; dictionary keys)
#                            of the query's input rows
#   output_headers     ---   the headers of the query's output rows
#   aggregate_headers  ---   the headers of the query's aggregate row
#
# Query constructors take two inputs: the input_headers of the table
# it will be operating on, and a list of arguments.
###########################################################

# Here are two example queries (Identity and Count) I've provided for you.

class Identity:
    """
    Do nothing. Takes no arguments. Returns each row unchanged and does no aggregation.
    """

    def __init__(self, in_headers, args):
        self.input_headers = in_headers
        self.output_headers = in_headers
        self.aggregate_headers = []

    def process_row(self,row):
        # Do nothing; return the row unchanged.
        return row

    def get_aggregate(self):
        # No aggregation, return an empty row.
        return {}

def testIdentity():
    """
    $ python3
    # from hw6 import *
    # testIdentity()
    Name,Age,Hair
    Steve,25,Blonde
    Bob,33,No
    Alice,27,Brown
    """
    (in_headers,lns) = openCSVFile('people.csv')
    printQuery(Identity(in_headers,[]), lns)

class Count:
    """
    An example of a simple aggregator that counts the number of rows.
    Each row is unchanged, but an aggregate table with a Count column
    is shown.
    """

    def __init__(self, in_headers, args):
        self.input_headers = in_headers
        self.output_headers = in_headers
        self.aggregate_headers = ['Count']

        # state for the aggregation
        self.count = 0

    def process_row(self,row):
        # update the state
        self.count += 1

        # return the row unchanged
        return row

    def get_aggregate(self):
        # return the aggregate row
        return {'Count' : self.count}

def testCount():
    """
    $ python3
    # from hw6 import *
    # testCount()
    Name,Age,Hair
    Steve,25,Blonde
    Bob,33,No
    Alice,27,Brown

    Count
    3
    """
    (in_headers,lns) = openCSVFile('people.csv')
    printQuery(Count(in_headers,[]), lns)

#################### STEP 1 : Implementing Queries ###############
# Now comes your part!
# You're going to implement a bunch of small query classes. Yes!
##################################################################

class Rename:
    """
    Rename a column. That is, change the header of a column. Does no aggregation.

    Consumes two arguments from the front of args: the old header name and the new one.

    Check that the old header is in the input headers.
    Check that the new header is not in the input headers.

    Tip: Make sure input_headers != output_headers
    Tip: Use list(someList) to make a copy of someList.
    Tip: Use the index method on lists. See: help([].index)

    Example: rename the 'Name' column to 'FirstName'
    """

    def __init__(self, in_headers, args):
        raise Exception("TODO")

    def process_row(self,row):
        raise Exception("TODO")

    def get_aggregate(self):
        raise Exception("TODO")

#################### Test it! ####################

def testRename():
    (in_headers,lns) = openCSVFile('people.csv')
    query = Rename(in_headers, ['Name','FirstName'])
    printQuery(query, lns)

class Swap:
    """
    Swap the positions of two columns. Does no aggregation.

    Consumes two arguments from the front of args: the two header names to be swapped.

    Tip: Make sure input_headers != output_headers
    Tip: Use list(someList) to make a copy of someList.
    Tip: Use the index method on lists. See: help([].index)
    """

    def __init__(self, in_headers, args):
        raise Exception("TODO")

    def process_row(self,row):
        raise Exception("TODO")

    def get_aggregate(self):
        raise Exception("TODO")

#################### Test it! ####################

def testSwap():
    """
    Example: Swap the firstname and lastname columns.

    $ python3
    # from hw6 import *
    # testSwap()
    Age,Name,Hair
    25,Steve,Blonde
    33,Bob,No
    27,Alice,Brown
    """
    (in_headers,lns) = openCSVFile('people.csv')
    query = Swap(in_headers, ['Name', 'Age'])
    printQuery(query, lns)


#################### Next! ####################

class Select:
    """
    Select a subset of columns to be included in the output. Does no aggregation.

    The arguments are the headers to be included in the output. You should check
    that each is in in_headers.
    """

    def __init__(self, in_headers, args):
        raise Exception("TODO")

    def process_row(self, row):
        raise Exception("TODO")

    def get_aggregate(self):
        raise Exception("TODO")

#################### Test it! ####################

def testSelect():
    """
    $ python3
    # from hw6 import *
    # testSelect()
    Age,Hair
    25,Blonde
    33,No
    27,Brown
    """

    (in_headers,lns) = openCSVFile('people.csv')

    # build the query
    query = Select(in_headers, ['Age','Hair'])

    # run it.
    printQuery(query, lns)

#################### Keep going! You're doing great! ##########

class Filter:
    """
    Return only the rows that pass a check. Takes a single argument in args, which
    is a python expression. For each row, check whether that row should be in the output
    by evaluating the expression. If the expression evaluates to True, then return the
    row unchanged. If the expression evaluates to False, return None.

    Does no aggregation.

    Tip: use python's eval function to evaluate a string of python source code.
         See help(eval)

    Examples of eval:
        eval('1 + 2')   # evaluates to 3

    eval can take in an environment as its second argument, which binds values to variables
    in the expression. Use this feature to allow the expression to refer to the columns by name.

        eval('x + y', {'x' : 1, 'y' : 2})   # evaluates to 3
    """

    def __init__(self, in_headers, args):
        raise Exception("TODO")

    def process_row(self,row):
        raise Exception("TODO")

    def get_aggregate(self):
        raise Exception("TODO")

#################### Test it! ####################

def testFilter():
    """
    Selects players from player_career_short.csv that played at least 500 games.

    $ python3
    # from hw6 import *
    # testFilter()
    id,firstname,lastname,leag,gp,minutes,pts,oreb,dreb,reb,asts,stl,blk,turnover,pf,fga,fgm,fta,ftm,tpa,tpm
    ABDULKA01 ,Kareem,Abdul-jabbar,N,1560,57446,38387,2975,9394,17440,5660,1160,3189,2527,4657,28307,15837,9304,6712,18,1
    ABDULMA01 ,Mahmo,Abdul-rauf,N,586,15633,8553,219,868,1087,2079,487,46,963,1107,7943,3514,1161,1051,1339,474
    ABDURSH01 ,Shareef,Abdur-rahim,N,830,28883,15028,1869,4370,6239,2109,820,638,2136,2324,11515,5434,4943,4006,519,154
    """

    (in_headers,lns) = openCSVFile('player_career_short.csv')
    query = Filter(in_headers, ['int(gp) >= 500'])
    printQuery(query,lns)


class Update:
    """
    Updates the values of a column. Expects two arguments in args: a column name
    and a python expression. Evaluate the expression using eval (as for Filter),
    and assign the result to the designated column. Raise an exception if the
    column is not in in_headers.

    Does no aggregation.

    Tip: use "x in l" to check if x is an element of l. See help('in').
    """

    def __init__(self, in_headers, args):
        raise Exception("TODO")

    def process_row(self,row):
        raise Exception("TODO")

    def get_aggregate(self):
        raise Exception("TODO")

#################### Test it! ####################

def testUpdate():
    """
    Example: Convert firstname to lower case.

    $ python3
    # from hw6 import *
    # testUpdate()
    id,firstname,lastname,leag,gp,minutes,pts,oreb,dreb,reb,asts,stl,blk,turnover,pf,fga,fgm,fta,ftm,tpa,tpm
    ABDELAL01 ,alaa,Abdelnaby,N,256,3200,1465,283,563,846,85,71,69,247,484,1236,620,321,225,3,0
    ABDULKA01 ,kareem,Abdul-jabbar,N,1560,57446,38387,2975,9394,17440,5660,1160,3189,2527,4657,28307,15837,9304,6712,18,1
    ABDULMA01 ,mahmo,Abdul-rauf,N,586,15633,8553,219,868,1087,2079,487,46,963,1107,7943,3514,1161,1051,1339,474
    ABDULTA01 ,tariq,Abdul-wahad,N,236,4808,1830,286,490,776,266,184,82,309,485,1726,720,529,372,76,18
    ABDURSH01 ,shareef,Abdur-rahim,N,830,28883,15028,1869,4370,6239,2109,820,638,2136,2324,11515,5434,4943,4006,519,154
    ABERNTO01 ,tom,Abernethy,N,319,5434,1779,374,637,1011,384,185,60,129,525,1472,724,443,331,2,0
    ABLEFO01  ,forest,Able,N,1,1,0,0,0,1,1,0,0,0,1,2,0,0,0,0,0
    ABRAMJO01 ,john,Abramovic,N,56,0,533,0,0,0,37,0,0,0,171,855,203,185,127,0,0
    ACKERAL01 ,alex,Acker,N,30,234,81,9,20,29,16,6,4,11,13,92,34,10,5,25,8
    """
    (in_headers,lns) = openCSVFile('player_career_short.csv')
    query = Update(in_headers, ['firstname', 'firstname.lower()'])
    printQuery(query,lns)

class Add:
    """
    Add a new column to the database. Like Update, Add consumes two arguments
    from args: a column name and a python expression. Raise an exception if
    the column is in in_headers.

    Tip: use "x not in l" to check if x is *not* an element of l.
         "not (x in l)" also works.
    """

    def __init__(self, in_headers, args):
        raise Exception("TODO")

    def process_row(self,row):
        raise Exception("TODO")

    def get_aggregate(self):
        raise Exception("TODO")

#################### Test it! ####################

def testAdd():
    """
    Example: compute the points per game for each player

    $ python3
    # from hw6 import *
    # testAdd()
    id,firstname,lastname,leag,gp,minutes,pts,oreb,dreb,reb,asts,stl,blk,turnover,pf,fga,fgm,fta,ftm,tpa,tpm,ppg
    ABDELAL01 ,Alaa,Abdelnaby,N,256,3200,1465,283,563,846,85,71,69,247,484,1236,620,321,225,3,0,6
    ABDULKA01 ,Kareem,Abdul-jabbar,N,1560,57446,38387,2975,9394,17440,5660,1160,3189,2527,4657,28307,15837,9304,6712,18,1,25
    ABDULMA01 ,Mahmo,Abdul-rauf,N,586,15633,8553,219,868,1087,2079,487,46,963,1107,7943,3514,1161,1051,1339,474,15
    ABDULTA01 ,Tariq,Abdul-wahad,N,236,4808,1830,286,490,776,266,184,82,309,485,1726,720,529,372,76,18,8
    ABDURSH01 ,Shareef,Abdur-rahim,N,830,28883,15028,1869,4370,6239,2109,820,638,2136,2324,11515,5434,4943,4006,519,154,18
    ABERNTO01 ,Tom,Abernethy,N,319,5434,1779,374,637,1011,384,185,60,129,525,1472,724,443,331,2,0,6
    ABLEFO01  ,Forest,Able,N,1,1,0,0,0,1,1,0,0,0,1,2,0,0,0,0,0,0
    ABRAMJO01 ,John,Abramovic,N,56,0,533,0,0,0,37,0,0,0,171,855,203,185,127,0,0,10
    ACKERAL01 ,Alex,Acker,N,30,234,81,9,20,29,16,6,4,11,13,92,34,10,5,25,8,3
    """
    (in_headers,lns) = openCSVFile('player_career_short.csv')
    query = Add(in_headers, ['ppg', 'round(int(pts)/int(gp))'])
    printQuery(query,lns)

class MaxBy:
    """
    An aggregation that shows one column (the display column) of the player
    with a maximum value for another column (the value column). Assume the value column
    contains the string representation of an int. Use int() to convert each entry in the
    column to an int before the comparison.

    process_row returns each row unchanged.

    aggregate_headers should contain one column name, of the form:
      "Max <name of display column> By <name of value column>"

    """
    def __init__(self, in_headers, args):
        raise Exception("TODO")

    def process_row(self,row):
        raise Exception("TODO")

    def get_aggregate(self):
        raise Exception("TODO")

#################### Test it! ####################

def testMaxBy():
    """
    Example: return the id of the player with the most minutes of play time.

    $ python3
    # from hw6 import *
    # testMaxBy()
    id,firstname,lastname,leag,gp,minutes,pts,oreb,dreb,reb,asts,stl,blk,turnover,pf,fga,fgm,fta,ftm,tpa,tpm
    ABDELAL01 ,Alaa,Abdelnaby,N,256,3200,1465,283,563,846,85,71,69,247,484,1236,620,321,225,3,0
    ABDULKA01 ,Kareem,Abdul-jabbar,N,1560,57446,38387,2975,9394,17440,5660,1160,3189,2527,4657,28307,15837,9304,6712,18,1
    ABDULMA01 ,Mahmo,Abdul-rauf,N,586,15633,8553,219,868,1087,2079,487,46,963,1107,7943,3514,1161,1051,1339,474
    ABDULTA01 ,Tariq,Abdul-wahad,N,236,4808,1830,286,490,776,266,184,82,309,485,1726,720,529,372,76,18
    ABDURSH01 ,Shareef,Abdur-rahim,N,830,28883,15028,1869,4370,6239,2109,820,638,2136,2324,11515,5434,4943,4006,519,154
    ABERNTO01 ,Tom,Abernethy,N,319,5434,1779,374,637,1011,384,185,60,129,525,1472,724,443,331,2,0
    ABLEFO01  ,Forest,Able,N,1,1,0,0,0,1,1,0,0,0,1,2,0,0,0,0,0
    ABRAMJO01 ,John,Abramovic,N,56,0,533,0,0,0,37,0,0,0,171,855,203,185,127,0,0
    ACKERAL01 ,Alex,Acker,N,30,234,81,9,20,29,16,6,4,11,13,92,34,10,5,25,8

    Max id By minutes
    ABDULKA01
    """
    (in_headers,lns) = openCSVFile('player_career_short.csv')
    query = MaxBy(in_headers, ['id', 'minutes'])
    printQuery(query,lns)

class Sum:
    """
    An aggregation that sums all entries of a column. Takes one argument, the header
    of the column to be summed. Produces an aggregate row containing one column, with
    header "<header> Sum" where <header> is the argument.
    """

    def __init__(self, in_headers, args):
        raise Exception("TODO")

    def process_row(self,row):
        raise Exception("TODO")

    def get_aggregate(self):
        raise Exception("TODO")

#################### Test it! ####################

def testSum():
    """
    Example: Compute the total number of turnovers.

    $ python3
    # from hw6 import *
    # testSum()
    id,firstname,lastname,leag,gp,minutes,pts,oreb,dreb,reb,asts,stl,blk,turnover,pf,fga,fgm,fta,ftm,tpa,tpm
    ABDELAL01 ,Alaa,Abdelnaby,N,256,3200,1465,283,563,846,85,71,69,247,484,1236,620,321,225,3,0
    ABDULKA01 ,Kareem,Abdul-jabbar,N,1560,57446,38387,2975,9394,17440,5660,1160,3189,2527,4657,28307,15837,9304,6712,18,1
    ABDULMA01 ,Mahmo,Abdul-rauf,N,586,15633,8553,219,868,1087,2079,487,46,963,1107,7943,3514,1161,1051,1339,474
    ABDULTA01 ,Tariq,Abdul-wahad,N,236,4808,1830,286,490,776,266,184,82,309,485,1726,720,529,372,76,18
    ABDURSH01 ,Shareef,Abdur-rahim,N,830,28883,15028,1869,4370,6239,2109,820,638,2136,2324,11515,5434,4943,4006,519,154
    ABERNTO01 ,Tom,Abernethy,N,319,5434,1779,374,637,1011,384,185,60,129,525,1472,724,443,331,2,0
    ABLEFO01  ,Forest,Able,N,1,1,0,0,0,1,1,0,0,0,1,2,0,0,0,0,0
    ABRAMJO01 ,John,Abramovic,N,56,0,533,0,0,0,37,0,0,0,171,855,203,185,127,0,0
    ACKERAL01 ,Alex,Acker,N,30,234,81,9,20,29,16,6,4,11,13,92,34,10,5,25,8

    turnover Sum
    6322
    """
    (in_headers,lns) = openCSVFile('player_career_short.csv')
    query = Sum(in_headers, ['turnover'])
    printQuery(query,lns)

class Mean:
    """
    An aggregation that computes the mean of all entries in a column. Round
    it to the nearest whole number.

    """

    def __init__(self, in_headers, args):
        raise Exception("TODO")

    def process_row(self,row):
        raise Exception("TODO")

    def get_aggregate(self):
        raise Exception("TODO")

def testMean():
    """
    $ python3
    # from hw6 import *
    # testMean()
    id,firstname,lastname,leag,gp,minutes,pts,oreb,dreb,reb,asts,stl,blk,turnover,pf,fga,fgm,fta,ftm,tpa,tpm
    ABDELAL01 ,Alaa,Abdelnaby,N,256,3200,1465,283,563,846,85,71,69,247,484,1236,620,321,225,3,0
    ABDULKA01 ,Kareem,Abdul-jabbar,N,1560,57446,38387,2975,9394,17440,5660,1160,3189,2527,4657,28307,15837,9304,6712,18,1
    ABDULMA01 ,Mahmo,Abdul-rauf,N,586,15633,8553,219,868,1087,2079,487,46,963,1107,7943,3514,1161,1051,1339,474
    ABDULTA01 ,Tariq,Abdul-wahad,N,236,4808,1830,286,490,776,266,184,82,309,485,1726,720,529,372,76,18
    ABDURSH01 ,Shareef,Abdur-rahim,N,830,28883,15028,1869,4370,6239,2109,820,638,2136,2324,11515,5434,4943,4006,519,154
    ABERNTO01 ,Tom,Abernethy,N,319,5434,1779,374,637,1011,384,185,60,129,525,1472,724,443,331,2,0
    ABLEFO01  ,Forest,Able,N,1,1,0,0,0,1,1,0,0,0,1,2,0,0,0,0,0
    ABRAMJO01 ,John,Abramovic,N,56,0,533,0,0,0,37,0,0,0,171,855,203,185,127,0,0
    ACKERAL01 ,Alex,Acker,N,30,234,81,9,20,29,16,6,4,11,13,92,34,10,5,25,8

    turnover Mean
    702
    """
    (in_headers,lns) = openCSVFile('player_career_short.csv')
    query = Mean(in_headers, ['turnover'])
    printQuery(query,lns)


#################### STEP 2 : Composing Queries ####################
# Each of our little queries is neat, but they become much more
# powerful when we can combine them to build larger queries.
##################################################################


class ComposeQueries:
    """
    Compose two queries into a larger query.

    The rows are composed in a series: the output of the first query's process_row
    method is the input to the second queries process_row method. Note that the
    first query could drop the row by returning None (Filter). In this case, you
    should not call the second query's process_row.

    You should "typecheck" the composition by checking that the first query's
    output_headers match the second query's input_headers.

    The input_headers of the composite are the input_headers of the first query.
    The output_headers of the composite are the output_headers of the second query.

    The aggregate row of the composite is the concatenation of the aggregates from
    the first and second query.

    You should ensure that the aggregate_headers of each input query are *distinct* --
    they should have no common elements.

    Tip: use the update method on dictionaries to combine two dictionaries.
         d = {'a' : 1, 'b' : 2}
         d.update({'c' : 3, 'd' : 4})
         print(d) # prints {'d': 4, 'b': 2, 'c': 3, 'a': 1}

    Note that ComposeQueries.__init__ does not take in_headers or args as input!
    q1 and q2 have already been constructed. We're simply combining them.

    Once you can compose two queries, you should be able to compose any number of queries!

    """
    def __init__(self, q1, q2):
        raise Exception("TODO")

    def process_row(self,row):
        raise Exception("TODO")

    def get_aggregate(self):
        raise Exception("TODO")

#################### Test it! ####################

def testComposite():
    """
    Example: Show id of the player with the maximum steals per game.

    $ python3
    # from hw6 import *
    # testComposite()
    id,firstname,lastname,leag,gp,minutes,pts,oreb,dreb,reb,asts,stl,blk,turnover,pf,fga,fgm,fta,ftm,tpa,tpm,stealsPerGame
    ABDELAL01 ,Alaa,Abdelnaby,N,256,3200,1465,283,563,846,85,71,69,247,484,1236,620,321,225,3,0,0.27734375
    ABDULKA01 ,Kareem,Abdul-jabbar,N,1560,57446,38387,2975,9394,17440,5660,1160,3189,2527,4657,28307,15837,9304,6712,18,1,0.7435897435897436
    ABDULMA01 ,Mahmo,Abdul-rauf,N,586,15633,8553,219,868,1087,2079,487,46,963,1107,7943,3514,1161,1051,1339,474,0.8310580204778157
    ABDULTA01 ,Tariq,Abdul-wahad,N,236,4808,1830,286,490,776,266,184,82,309,485,1726,720,529,372,76,18,0.7796610169491526
    ABDURSH01 ,Shareef,Abdur-rahim,N,830,28883,15028,1869,4370,6239,2109,820,638,2136,2324,11515,5434,4943,4006,519,154,0.9879518072289156
    ABERNTO01 ,Tom,Abernethy,N,319,5434,1779,374,637,1011,384,185,60,129,525,1472,724,443,331,2,0,0.5799373040752351
    ABLEFO01  ,Forest,Able,N,1,1,0,0,0,1,1,0,0,0,1,2,0,0,0,0,0,0.0
    ABRAMJO01 ,John,Abramovic,N,56,0,533,0,0,0,37,0,0,0,171,855,203,185,127,0,0,0.0
    ACKERAL01 ,Alex,Acker,N,30,234,81,9,20,29,16,6,4,11,13,92,34,10,5,25,8,0.2

    Max id By stealsPerGame
    ABDELAL01
    """
    f = open('player_career_short.csv')

    # get the input headers
    in_headers = f.readline().strip().split(',')

    # build the first query
    q1 = Add(in_headers, ['stealsPerGame', 'int(stl)/int(gp)'])

    # the input of second query is the output of first query
    next_in_headers = q1.output_headers

    q2 = MaxBy(next_in_headers, ['id', 'stealsPerGame'])

    # build the composite query.
    query = ComposeQueries(q1,q2)

    # run it.
    printQuery(query, f)

##### Try out that fancy CLI. #####
# $ python hw6.py -Add stealsPerGame int(stl)/int(gp) -MaxBy id stealsPerGame -MaxBy stealsPerGame stealsPerGame -Filter False
# id,firstname,lastname,leag,gp,minutes,pts,oreb,dreb,reb,asts,stl,blk,turnover,pf,fga,fgm,fta,ftm,tpa,tpm,stealsPerGame
#
# Max id By stealsPerGame,Max stealsPerGame By stealsPerGame
# ARTESRO01 ,2

################# STEP 3 : Command-line Interface ####################
# Next, you'll implement a nice command line interface (CLI) for
# building and running composite queries.
######################################################################

# We store all the query classes in a dictionary, so constructing
# any query is easy: use the flag to lookup the query class, then
# apply the class like a function.
#
# Example: construct an instance of the Identity class.
#
# queries['Identity'](in_headers,args)

queries = {
    'Identity' : Identity,
    'Rename'   : Rename,
    'Select'   : Select,
    'Swap'     : Swap,
    'Filter'   : Filter,
    'Update'   : Update,
    'Add'      : Add,
    'Count'    : Count,
    'MaxBy'    : MaxBy,
    'Sum'      : Sum,
    'Mean'     : Mean
    }

def splitArgs(args):
    """
    Take a list of command line arguments for a composite query, and break it
    into multiple lists, so that each contains arguments for a single atomic
    query.

    Each flag (a string starting with '-') in args indicates the beginning of
    the arguments for a new atomic query. The flag indicates the class of
    the query. You should include the flag as the first argument of the query.

    Example:
    # splitArgs(['-Add', 'stealsPerGame', 'int(stl)/int(gp)', '-MaxBy', 'id', 'stealsPerGame'])
    [['-Add', 'stealsPerGame', 'int(stl)/int(gp)'], ['-MaxBy', 'id', 'stealsPerGame']]

    We will use this to build composite queries from the command line:

    # python hw6.py player_career.csv -Add stealsPerGame int(stl)/int(gp) -MaxBy id stealsPerGame
    """
    raise Exception("TODO")

def buildQuery(in_headers, args):
    """
    Build the composite query.

    Use splitArgs to break args into a list of arguments. Use the first argument
    (the flag) to lookup the query class from queries. Then construct an instance
    of that query class using the rest of the arguments.

    Then compose all the atomic queries into one big composite.
    """
    raise Exception("TODO")


def queryFile(fname,args):
    """
    I'm providing this one for you: given a filename and a list of arguments
    (for buildQuery), build the query and run it on the file!
    """
    # Open that file!
    (in_headers,lns) = openCSVFile(fname)

    # build the query
    query = buildQuery(in_headers, args)

    # run the query.
    printQuery(query, lns)


#################### STEP 4: Experiments ####################
# In this part, you'll design a number of queries on the full database.
# Use queryFile!

def mostPointsPerMinute():
    """
    Write a query that returns the full name (fistname + ' ' + lastname)
    of the player who has the most points per minute.
    """
    raise Exception("TODO")

def mostStealsPerGame():
    """
    Write a query that returns the full name of the player who has the
    most steals per game.
    """
    raise Exception("TODO")

def mosts():
    """
    Write a query that returns the full name of the player with the highest
    total number (over their career) in each category: gp, minutes, pts,
    oreb, dreb, reb, asts, stl, blk, turnover, pf, fga, fgm, fta, ftm, tpa, tpm.
    Only show the aggregate table row. The main results table can show a header row,
    but no data row.
    """
    raise Exception("TODO")

def bestPercentages():
    """
    Write a query that returns the full name of each player with the highest field
    goal percentage (fgm/fga), free-throw percentage (ftm/fta), and three-point
    percentage (tpm/tpa).
    """
    raise Exception("TODO")

def count50Percents():
    """
    Write a query that returns the number of players that made over 50
    percent of all of their shots (field goals, free-throws and
    three-point shots).
    """
    raise Exception("TODO")

##############################################################

def main():
    # arguments start from position 1, since position 0 is always 'hw6.py'
    args = sys.argv[1:]

    # first argument is the input file. see help(list.pop)
    fname = args.pop(0)
    queryFile(fname,args)

if __name__ == "__main__":
    main()

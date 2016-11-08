from hw6 import *

def test(nm, thunk, expected):
  try:
    if thunk() == expected:
      print(nm + ": OK")
    else:
      print(nm + ": FAILED")
  except Exception as e:
    if e.args[0] == "TODO":
      print(nm + ": TODO")
    elif e == expected:
      print(nm + ": OK")
    else:
      print(nm + ": EXCEPTION")
      print(e)

def testQuery(nm, filename, mkQuery, expected):
  (in_headers,lns) = openCSVFile(filename)
  test(nm, lambda: '\n'.join(runQuery(mkQuery(in_headers),lns)), expected)

testHeaders = ['Name','Age','Hair']
testHeaderRow = 'Name,Age,Hair'

testRows = [
    'Steve,25,Blonde'
  , 'Bob,33,No'
  , 'Alice,27,Brown'
  ]

test("rowStringToDict",
     lambda: rowStringToDict(testHeaders, testRows[0]),
     {'Name' : 'Steve', 'Age' : '25', 'Hair' : 'Blonde'})

test("rowDictToString",
     lambda: rowDictToString(testHeaders, {'Name' : 'Steve', 'Age' : '25', 'Hair' : 'Blonde'}),
     testRows[0])

testQuery("Identity", "people.csv",
         lambda in_headers: Identity(in_headers,[]),
         """\
Name,Age,Hair
Steve,25,Blonde
Bob,33,No
Alice,27,Brown\
""")

testQuery("Count", "people.csv",
          lambda headers: Count(headers, []),
          """\
Name,Age,Hair
Steve,25,Blonde
Bob,33,No
Alice,27,Brown

Count
3\
""")

testQuery("Rename", "people.csv",
          lambda headers: Rename(headers, ['Name', 'FirstName']),
          """\
FirstName,Age,Hair
Steve,25,Blonde
Bob,33,No
Alice,27,Brown\
""")

testQuery("Swap", "people.csv",
          lambda headers: Swap(headers, ['Name', 'Age']),
          """\
Age,Name,Hair
25,Steve,Blonde
33,Bob,No
27,Alice,Brown\
""")

testQuery("Select", "people.csv",
          lambda headers: Select(headers, ['Age', 'Hair']),
          """\
Age,Hair
25,Blonde
33,No
27,Brown\
""")

testQuery("Filter", "player_career_short.csv",
          lambda headers: Filter(headers, ['int(gp) >= 500']),
          """\
id,firstname,lastname,leag,gp,minutes,pts,oreb,dreb,reb,asts,stl,blk,turnover,pf,fga,fgm,fta,ftm,tpa,tpm
ABDULKA01 ,Kareem,Abdul-jabbar,N,1560,57446,38387,2975,9394,17440,5660,1160,3189,2527,4657,28307,15837,9304,6712,18,1
ABDULMA01 ,Mahmo,Abdul-rauf,N,586,15633,8553,219,868,1087,2079,487,46,963,1107,7943,3514,1161,1051,1339,474
ABDURSH01 ,Shareef,Abdur-rahim,N,830,28883,15028,1869,4370,6239,2109,820,638,2136,2324,11515,5434,4943,4006,519,154\
""")

testQuery("Filter", "people.csv",
          lambda headers: Filter(headers, ['int(Age) >= 30']),
          """\
Name,Age,Hair
Bob,33,No\
""")

testQuery("Update", "player_career_short.csv",
          lambda headers: Update(headers, ['firstname', 'firstname.lower()']),
          """\
id,firstname,lastname,leag,gp,minutes,pts,oreb,dreb,reb,asts,stl,blk,turnover,pf,fga,fgm,fta,ftm,tpa,tpm
ABDELAL01 ,alaa,Abdelnaby,N,256,3200,1465,283,563,846,85,71,69,247,484,1236,620,321,225,3,0
ABDULKA01 ,kareem,Abdul-jabbar,N,1560,57446,38387,2975,9394,17440,5660,1160,3189,2527,4657,28307,15837,9304,6712,18,1
ABDULMA01 ,mahmo,Abdul-rauf,N,586,15633,8553,219,868,1087,2079,487,46,963,1107,7943,3514,1161,1051,1339,474
ABDULTA01 ,tariq,Abdul-wahad,N,236,4808,1830,286,490,776,266,184,82,309,485,1726,720,529,372,76,18
ABDURSH01 ,shareef,Abdur-rahim,N,830,28883,15028,1869,4370,6239,2109,820,638,2136,2324,11515,5434,4943,4006,519,154
ABERNTO01 ,tom,Abernethy,N,319,5434,1779,374,637,1011,384,185,60,129,525,1472,724,443,331,2,0
ABLEFO01  ,forest,Able,N,1,1,0,0,0,1,1,0,0,0,1,2,0,0,0,0,0
ABRAMJO01 ,john,Abramovic,N,56,0,533,0,0,0,37,0,0,0,171,855,203,185,127,0,0
ACKERAL01 ,alex,Acker,N,30,234,81,9,20,29,16,6,4,11,13,92,34,10,5,25,8\
""")

testQuery("Add", "player_career_short.csv",
          lambda headers: Add(headers, ['ppg', 'round(int(pts)/int(gp))']),
          """\
id,firstname,lastname,leag,gp,minutes,pts,oreb,dreb,reb,asts,stl,blk,turnover,pf,fga,fgm,fta,ftm,tpa,tpm,ppg
ABDELAL01 ,Alaa,Abdelnaby,N,256,3200,1465,283,563,846,85,71,69,247,484,1236,620,321,225,3,0,6
ABDULKA01 ,Kareem,Abdul-jabbar,N,1560,57446,38387,2975,9394,17440,5660,1160,3189,2527,4657,28307,15837,9304,6712,18,1,25
ABDULMA01 ,Mahmo,Abdul-rauf,N,586,15633,8553,219,868,1087,2079,487,46,963,1107,7943,3514,1161,1051,1339,474,15
ABDULTA01 ,Tariq,Abdul-wahad,N,236,4808,1830,286,490,776,266,184,82,309,485,1726,720,529,372,76,18,8
ABDURSH01 ,Shareef,Abdur-rahim,N,830,28883,15028,1869,4370,6239,2109,820,638,2136,2324,11515,5434,4943,4006,519,154,18
ABERNTO01 ,Tom,Abernethy,N,319,5434,1779,374,637,1011,384,185,60,129,525,1472,724,443,331,2,0,6
ABLEFO01  ,Forest,Able,N,1,1,0,0,0,1,1,0,0,0,1,2,0,0,0,0,0,0
ABRAMJO01 ,John,Abramovic,N,56,0,533,0,0,0,37,0,0,0,171,855,203,185,127,0,0,10
ACKERAL01 ,Alex,Acker,N,30,234,81,9,20,29,16,6,4,11,13,92,34,10,5,25,8,3\
""")

testQuery("MaxBy", "player_career_short.csv",
          lambda headers: MaxBy(headers, ['id', 'minutes']),
          """\
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
ABDULKA01 \
""")

testQuery("Sum", "player_career_short.csv",
          lambda headers: Sum(headers, ['turnover']),
          """\
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
6322\
""")

testQuery("Mean", "player_career_short.csv",
          lambda headers: Mean(headers, ['turnover']),
          """\
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
702\
""")

def buildComposite(headers):
  q1 = Add(headers, ['stealsPerGame', 'int(stl)/int(gp)'])
  q2 = MaxBy(q1.output_headers, ['id', 'stealsPerGame'])
  return ComposeQueries(q1,q2)

testQuery("ComposeQueries", "player_career_short.csv",
          lambda headers: buildComposite(headers),
          """\
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
ABDURSH01 \
""")

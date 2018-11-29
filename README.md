# football_betting

A script investigating betting in football. The script tries to identify possible bias from the bookies odds, and utilize it to produce a betting strategy most profitable. The idea was inspired by the book "Soccermatics", written by David Sumpter. 

# Requirements

Script is done in Matlab. The dataset used, that contains historical odds and results, is downloaded from: http://www.football-data.co.uk/. The files should be in folder "./data" and be named for instance "E0 (1).csv" (E-> English, 0 -> Premier League, (i) -> could be the ith latest season).

# Details

By running the script with ExamineData=1, one obtains plots visualizing the difference in probability estimated by the bookies, and the realized probabilities of winning. One can notice some bias in the bookies setting of odds.

By running the script with TestHypothesis=1, one obtains a graphical visualization of the profit made, had one betted according to the strategy during the seasons examined.

# Results

There seems to exist betting strategies that would be profitable. This is however only based on historical data and no guarantee can be given regarding the future.

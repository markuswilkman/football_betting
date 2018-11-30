# football_betting

A script investigating betting in football. The script tries to identify possible bias from the bookies odds, and utilize it to produce a betting strategy most profitable. The idea was inspired by the book "Soccermatics", written by David Sumpter. 

# Requirements

Script is done in Matlab. The dataset used, that contains historical odds and results, is downloaded from: http://www.football-data.co.uk/. The files should be in folder "./data" and be named for instance "E0 (1).csv" (E-> English, 0 -> Premier League, (i) -> could be the ith latest season).

# Details

Use MAIN.m to run the different functions.

By running the script with examine_data=1, one obtains plots visualizing the difference in probability estimated by the bookies, and the realized probabilities of winning. One can notice some bias in the bookies setting of odds. One can choose to save the logistic regression models created according to the data read.

By running the script with test_hypothesis=1, one obtains a graphical visualization of the profit made, had one betted according to the strategy during the seasons examined. The strategy in question is largely the same as in "Soccermatics". The simplified version of the betting is the following: based on data some bias in the bookies odds has been found, in certain settings. Based on the data read, one can set/use tresholds for when one should bet. One then makes sure that the expected profit of a bet is positive (based on the logistic regression model mentioned earlier). The betsize can be determined as a function of bettable money, or as a standard one. Simulating this, one obtains the profit that would have been made, using this approach.

# Results

There seems to exist betting strategies that would be profitable. This is however only based on historical data and no guarantee can be given regarding the future. The following plots depict the (possible) difference in the probabilities that the bookies give (BLUE) and the historically realized outcomes (RED) and the treshold (BLACK). In other words, when the red line is above the blue, one should have made a bet, and the black line is an estimate of the boundrary (for H and A: bet on the right, for D: bet on the left). The H, D and A depict home win, draw and away win.

The following result is obtained using the English Premier League seasons 17-18, 16-17 and 15-16, running the MAIN with examine_data = 1.

<img src="/figures/diff_H.png" width="400">
<img src="/figures/diff_D.png" width="400">
<img src="/figures/diff_A.png" width="400">

The following result is obtained using the English Premier League seasons 17-18, 16-17 and 15-16, running the MAIN with testing_hypothesis = 1.

<img src="/figures/profit_by_bet.png" width="400">
<img src="/figures/profit.png" width="400">

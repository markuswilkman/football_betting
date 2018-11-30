function [ performance_metrix, ratio_between_profit_and_bets ] = ...
    testing( Odds, Outcome, prob, bettable_money, strategy_enabled, tresh )
%%% TEST strategy

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% VARIABLES

performance_metrix = {'outcome', 'n correct', 'n bets', ...
    '%correct', 'sum bets', 'profit', 'E[profit/bet]'};

[m, n] = size(Odds);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% CALCULATIONS

[ bets, type, max_odd ] = bet( Odds, prob, bettable_money, ...
    strategy_enabled, tresh );

% TOTAL
correct_vec = ( type == Outcome );
n_correct_total = sum( correct_vec );
n_bets_total = sum( type > 0 );
perc_total_correct = n_correct_total / n_bets_total;
balance_total = bets .* correct_vec .* max_odd + ...
    (correct_vec - 1) .* bets;
profit_total = sum( balance_total );
sum_bet_total = sum( bets );
performance_metrix = [performance_metrix; {'TOT', n_correct_total, ...
    n_bets_total, perc_total_correct, sum_bet_total, profit_total, ...
    profit_total / n_bets_total}];

% HOME
inst_H = ( type == 1 ); % instance of bets placed on 1 (H)
inst_correct_H = ( inst_H .* correct_vec );
n_correct_H = sum( inst_correct_H );
n_bets_H = sum( inst_H );
sum_bet_H = bets.' * inst_H;
perc_H_correct = n_correct_H / n_bets_H;
balance_H = inst_correct_H .* bets .* max_odd + ...
    (inst_correct_H - inst_H).* bets;
profit_H = sum( balance_H );
performance_metrix = [performance_metrix; {'H', n_correct_H, n_bets_H, perc_H_correct, ...
    sum_bet_H, profit_H, profit_H / n_bets_H}];

% DRAW
inst_D = ( type == 2 ); % instance of bets placed on 2 (D)
inst_correct_D = ( inst_D .* correct_vec );
n_correct_D = sum( inst_correct_D );
n_bets_D = sum( inst_D );
sum_bet_D = bets.' * inst_D;
perc_D_correct = n_correct_D / n_bets_D;
balance_D = inst_correct_D .* bets .* max_odd + ...
    (inst_correct_D - inst_D).* bets;
profit_D = sum( balance_D );
performance_metrix = [performance_metrix; {'D', n_correct_D, n_bets_D, perc_D_correct, ...
    sum_bet_D, profit_D, profit_D / n_bets_D}];

% AWAY
inst_A = ( type == 3 ); % instance of bets placed on 3 (A)
inst_correct_A = ( inst_A .* correct_vec );
n_correct_A = sum( inst_correct_A );
n_bets_A = sum( inst_A );
sum_bet_A = bets.' * inst_A;
perc_A_correct = n_correct_A / n_bets_A;
balance_A = inst_correct_A .* bets .* max_odd + ...
    (inst_correct_A - inst_A).* bets;
profit_A = sum( balance_A );
performance_metrix = [performance_metrix; {'A', n_correct_A, n_bets_A, perc_A_correct, ...
    sum_bet_A, profit_A, profit_A / n_bets_A}];


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% CONCLUSION

% PERFORMANCE metrix
assert( profit_total + 1 >= sum(balance_H + balance_D + balance_A) && ...
    profit_total - 1 <= sum(balance_H + balance_D + balance_A) );
assert( sum_bet_total + 1 >= sum_bet_H + sum_bet_D + sum_bet_A && ... 
    sum_bet_total - 1 <= sum_bet_H + sum_bet_D + sum_bet_A );
ratio_between_profit_and_bets = profit_total / sum_bet_total;

% PLOTS
figure
subplot(3,1,1)
plot(1:m, cumsum(balance_H))
title('H')
ylabel('money')
subplot(3,1,2)
plot(1:m, cumsum(balance_D))
ylabel('money')
title('D')
subplot(3,1,3)
plot(1:m, cumsum(balance_A))
title('A')
ylabel('money')
xlabel('number of games')

figure
plot(1:m, bettable_money + cumsum(sum([ balance_D, ...
    balance_H, balance_A ], 2)))
ylabel('money')
xlabel('number of games')



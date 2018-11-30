function [ bets, type, max_odd ] = bet( Odds, prob, bettable_money, ...
    strategy_enabled, tresh )
% function to assess wheather to bet and in that case check p > 1/o and
%   calculate betsize
%   output: betsize and type ( m x 2 )
%       bets : size of bet placed
%       type : 123 (HDA)
    
    [m, n] = size(Odds);
    idxH = 1:3:n;
    idxD = 2:3:n;
    idxA = 3:3:n;
    
    prob_H = mean(prob(:, idxH),2);
    prob_D = mean(prob(:, idxD),2);
    prob_A = mean(prob(:, idxA),2);
    
    bets = zeros(m,1);
    type = zeros(m,1);
    max_odd = zeros(m,1);
    
    for i = 1:m
        % HOME
        if( mean(prob(i,idxH) - prob(i,idxA) > tresh(3)) ...
                >= tresh(4) )
            [odd_H, ~] = max(Odds(i, idxH));
            bet_size = betSize( odd_H, prob_H(i), ...
                bettable_money, strategy_enabled, m ); % prob_H : mean should it be from logreg function?
            bet_if = betIf( prob_H(i), prob_H(i) - prob_A(i), odd_H, 'H' );
            bets(i) = bet_size * bet_if;
            type(i) = 1; % corresponding to 'H'
            max_odd(i) = odd_H;
        end
        % DRAW
        if (  mean( abs(prob(i,idxA) - prob(i,idxH) ) < tresh(1)  ) ...
                >= tresh(2) )
            [odd_D, ~] = max(Odds(i, idxD));
            bet_size = betSize( odd_D, prob_D(i), ...
                bettable_money, strategy_enabled, m );
            bet_if = betIf( prob_D(i), abs( prob_H(i) - prob_A(i) ), odd_D, 'D' );
            bets(i) = bet_size * bet_if;
            type(i) = 2; % corresponding to 'D'
            max_odd(i) = odd_D;
        end
        % AWAY
        if( mean(prob(i,idxA) - prob(i,idxH) > tresh(3) ) ...
                >= tresh(4) )
            [odd_A, ~] = max(Odds(i, idxA));
            bet_size = betSize( odd_A, prob_A(i), ...
                bettable_money, strategy_enabled, m );
            bet_if = betIf( prob_A(i), prob_A(i) - prob_H(i), odd_A, 'A' );
            bets(i) = bet_size * bet_if;
            type(i) = 3; % corresponding to 'A'
            max_odd(i) = odd_A;
        end
    end
end


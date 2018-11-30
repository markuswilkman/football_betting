function [ bet_size ] = betSize( odd, prob, bettable_money, ...
    bet_strategy_enabled, m )
    % BETSIZE bet expected return / UK bet (= EU - 1) * total sum
    
    if (bet_strategy_enabled)
        uk_odd = odd - 1;
        bet_size = max( 0.1, (uk_odd .* prob - (1 - prob)) ./ ...
            uk_odd * bettable_money );
    else
        bet_size = ones(1,1);
    end



end


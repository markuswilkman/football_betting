function [ probab ] = scaled_probabilities( odds )
    
    odds_inv = 1 ./ odds;
    cum_sum = cumsum(odds_inv,2);
    odds_inv_sum_help = cum_sum(:,3:end) - ...
        [zeros(size(odds,1),1) cum_sum(:,1:end-3)];
    odds_inv_sum = repelem(odds_inv_sum_help(:,1:3:size(odds,2)), 1, 3);
    probab = odds_inv ./ odds_inv_sum;

end


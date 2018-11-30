function [ h ] = RBF( prob_i, outcome_i, sigma, xspan )
% Perform kernel smoothing to the realized data
%   xspan.' : row vector, prob_i : column vector
    
    K = exp( -0.5*(xspan - prob_i).^2 / sigma^2 );
    h = outcome_i.' * K ./ sum(K,1);
   
end


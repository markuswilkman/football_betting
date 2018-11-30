function [ out ] = betIf( p, p_diff, odd, result )
% Bet if p > 1/o e.g. predict(probability) (according to LogReg) > 1/odd
    
    struct = getModels; %get models
    
    if (result == 'H')
        out = sum([ predict(struct.model_H, p), predict(struct.model_diff_H, p_diff) ] > 1/odd);
    elseif (result == 'D')
        out = sum([ predict(struct.model_D, p), predict(struct.model_diff_D, p_diff) ] > 1/odd);
    elseif (result == 'A')
        out = sum([ predict(struct.model_A, p), predict(struct.model_diff_A, p_diff) ] > 1/odd);
    end
    
    return        
end


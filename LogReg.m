function [ model ] = LogReg( prob, labels )
    
    model = fitglm(prob, labels, 'Distribution', 'binomial');

end


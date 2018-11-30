function [ empty_i, freq_i, empty_diff_i, freq_diff_i, prob_i_vec, prob_new ] ...
    = frequencies( prob_i, prob_diff_i, outcome_i, n_ivals, ival, sign, ...
    sigma_diff, xspan_diff )
% calculate "frequencies" (over an interval)

    freq_i = zeros(n_ivals-1, 1);
    empty_i = [];
    freq_diff_i = zeros(n_ivals-1, 1);
    empty_diff_i = [];
    prob_i_vec = zeros(n_ivals-1, 1);

    for i = 1:n_ivals-1
        inst_i = ( prob_i >= ival(i) ) .* ( prob_i < ival(i + 1) );
        if(sum(inst_i) == 0)
            empty_i(end+1) = i;
        end
        freq_i(i) = inst_i.' * outcome_i / sum(inst_i);

        inst_i2 = ( sign*prob_diff_i >= ival(i) ) .* ( sign*prob_diff_i < ival(i + 1) );
        if(sum(inst_i2) == 0)
            empty_diff_i(end+1) = i;
        end
        freq_diff_i(i) = inst_i2.' * outcome_i / sum(inst_i2);
        prob_i_vec(i) = inst_i2.' * prob_i / sum(inst_i2);
    end
    prob_new = RBF(sign*prob_diff_i, prob_i, sigma_diff, xspan_diff);
end


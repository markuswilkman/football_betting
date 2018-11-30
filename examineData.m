function [model_H, model_diff_H, model_D, model_diff_D, model_A, model_diff_A] ...
                    = examineData( Outcome, prob, tresh )
    %%% STATISTICS FROM FOOTBALL BETTING

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%% VARIABLES

    % FOR RBF
    sigma = 0.06;
    xspan = [0:0.03:1];

    % FOR "frequency" computation and RBF of probabilities from odds
    n_ival_bins = 31;
    n_ival_D_bins = 51;
    xspan_diff = 0:0.05:1;
    sigma_diff = 0.1;
    ival = linspace(0,1,n_ival_bins);
    ival_D = linspace(0,1,n_ival_D_bins);
    plot_points = (ival(1:end-1) + 1 / (n_ival_bins - 1) / 2).';
    plot_points_D = (ival_D(1:end-1) + 1 / (n_ival_D_bins - 1) / 2).';


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%% CALCULATIONS

    % INDICES and probab
    [~, n] = size(prob);
    idxH = 1:3:n;
    idxD = 2:3:n;
    idxA = 3:3:n;

    % MEAN of probabs and outcome vector
    prob_H_mean = mean(prob(:,idxH), 2);
    outcome_H = ( Outcome == 1 ); % corresponds to Outcome = 1
    prob_D_mean = mean(prob(:,idxD), 2);
    outcome_D = ( Outcome == 2 );
    prob_A_mean = mean(prob(:,idxA), 2);
    outcome_A = ( Outcome == 3 );

    % PROBAB difference
    prob_diff = prob_H_mean - prob_A_mean;
    prob_diff_D = abs(prob_diff);

    % RBF: Gaussian kernel smoothing
    smooth_H = RBF(prob_H_mean, outcome_H, sigma, xspan);
    smooth_diff_H = RBF(prob_diff, outcome_H, sigma, xspan);
    smooth_D = RBF(prob_D_mean, outcome_D, sigma, xspan);
    smooth_diff_D = RBF(prob_diff_D, outcome_D, sigma, xspan);
    smooth_A = RBF(prob_A_mean, outcome_A, sigma, xspan);
    smooth_diff_A = RBF(-1*prob_diff, outcome_A, sigma, xspan);

    % GET "frequencies"
    [empty_H, freq_H, empty_diff_H, freq_diff_H, prob_H_vec, prob_H_new] = ...
        frequencies(prob_H_mean, prob_diff, outcome_H, n_ival_bins, ival, 1, ...
        sigma_diff, xspan_diff);
    [empty_A, freq_A, empty_diff_A, freq_diff_A, prob_A_vec, prob_A_new] = ...
        frequencies(prob_A_mean, prob_diff, outcome_A, n_ival_bins, ival, -1, ...
        sigma_diff, xspan_diff);
    [empty_D, freq_D, empty_diff_D, freq_diff_D, prob_D_vec, prob_D_new] = ...
        frequencies(prob_D_mean, prob_diff_D, outcome_D, n_ival_D_bins, ival_D, 1, ...
        sigma_diff, xspan_diff);

    % LOGISTIC REGRESSION fit and prediction
    model_H = LogReg(prob_H_mean, outcome_H);
    pred_H = predict(model_H, plot_points);
    model_A = LogReg(prob_A_mean, outcome_A);
    pred_A = predict(model_A, plot_points);
    nneg_idx = prob_diff >= 0;
    model_diff_H = LogReg(prob_diff(nneg_idx,:), outcome_H(nneg_idx));
    pred_diff_H = predict(model_diff_H, plot_points);
    npos_idx = prob_diff <= 0;
    model_diff_A = LogReg(-prob_diff(npos_idx,:), outcome_A(npos_idx));
    pred_diff_A = predict(model_diff_A, plot_points);
    model_D = LogReg(prob_D_mean, outcome_D);
    pred_D = predict(model_D, plot_points_D);
    model_diff_D = LogReg(prob_diff_D, outcome_D);
    pred_diff_D = predict(model_diff_D, plot_points_D);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%% PLOTS

    % FIGURE H
    % plot_points, freq_H, 'rx', ...
    figure
    plot( ...
        ival, ival, 'b', ...
        xspan, smooth_H, ':r', ...
        plot_points, pred_H, 'r')
    xlim([0,1])
    title('H')
    legend('1:1', 'RBF-smoothed', 'logistic regression')
    xlabel('prob(H)')

    figure
    hold on
    plot( ...
        plot_points, prob_H_vec, 'b', ...
        xspan_diff, prob_H_new, ':b', ...
        xspan, smooth_diff_H, ':r', ...
        plot_points, pred_diff_H, 'r')
    plot([tresh(3), tresh(3)], get(gca, 'ylim'), 'k');
    title('diff H')
    xlabel('prob(H) - prob(A)')
    legend('bins', 'bin+RBF', 'RBF-smoothed', 'logistic regression','treshold')

    % FIGURE D
    figure
    plot(...
        ival_D, ival_D, 'b', ...
        xspan, smooth_D, ':r', ...
        plot_points_D, pred_D, 'r')
    xlim([0, 0.5])
    title('D')
    legend('1:1', 'RBF-smoothed', 'logistic regression')
    xlabel('prob(D)')

    figure
    hold on
    plot( ...
        plot_points_D, prob_D_vec, 'b', ...
        xspan_diff, prob_D_new, ':b', ...
        xspan, smooth_diff_D, ':r', ...
        plot_points_D, pred_diff_D, 'r')
    plot([tresh(1), tresh(1)], get(gca, 'ylim'), 'k');
    title('diff D')
    xlabel('| prob(H) - prob(A) |')
    legend('bins', 'bin+RBF', 'RBF-smoothed', 'logistic regression','treshold')

    % FIGURE A
    figure
    plot( ...
        ival, ival, 'b', ...
        xspan, smooth_A, ':r', ...
        plot_points, pred_A, 'r')
    xlim([0,1])
    title('A')
    legend('1:1', 'RBF-smoothed', 'logistic regression')
    xlabel('prob(A)')

    figure
    hold on
    plot( ...
        plot_points, prob_A_vec, 'b', ...
        xspan_diff, prob_A_new, ':b', ...
        xspan, smooth_diff_A, ':r', ...
        plot_points, pred_diff_A, 'r')
    plot([tresh(3), tresh(3)], get(gca, 'ylim'), 'k');
    title('diff A')
    xlabel('prob(A) - prob(H)')
    legend('bins', 'bin+RBF', 'RBF-smoothed', 'logistic regression','treshold')
end
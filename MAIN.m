%%%%%% MAIN %%%%%%%
%% data
seasons = [1,2,3]; % [1,2,3,4,5,6,7,8,9,10]
leagues = ['E'];
[Odds, Outcome] = getHistoricalData(seasons, leagues);

%% script
close all
clearvars -except Odds Outcome;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% PRACTICAL VARIABLES

% change plots
examine_data = 1;
    save_new_models = 0;
test_hypotesis = 0;
    bettable_money = 100;
    bet_size_strategy_enabled = 1;

D_perc_interval = 0.25;
perc_of_betsites_stsf_D = 0.6;
W_perc_interval = 0.4;
perc_of_betsites_stsf_W = 0.6;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% ACTIONS

% scaled probabs vector
prob = scaled_probabilities(Odds);
% tresholds
treshold = [D_perc_interval, perc_of_betsites_stsf_D, W_perc_interval, perc_of_betsites_stsf_W];

if examine_data
    [model_H, model_diff_H, model_D, model_diff_D, model_A, model_diff_A] = ...
                        examineData( Outcome, prob, treshold );
    if save_new_models
        save('./models.mat', 'model*');
    end
end
if test_hypotesis
    loadModels('models.mat');
    perf = testing( Odds, Outcome, prob, bettable_money, bet_size_strategy_enabled, treshold )
end

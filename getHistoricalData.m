function [ odds_out, outcome_out ] = getHistoricalData( seasons, leagues )

% 1: Div,Date,HomeTeam,AwayTeam,FTHG,FTAG,FTR,HTHG,HTAG,HTR,
% 11: Referee,HS,AS,HST,AST,HF,AF,HC,AC,HY,AY,HR,AR,
% 24: B365H,B365D,B365A,
% 27: BWH,BWD,BWA,
% 30: IWH,IWD,IWA,
% 33: LBH,LBD,LBA,
% 36: PSH,PSD,PSA,
% 39: WHH,WHD,WHA,
% 42: VCH,VCD,VCA,
% 45: Bb1X2,BbMxH,BbAvH,BbMxD,BbAvD,BbMxA,BbAvA,BbOU,BbMx>2.5,BbAv>2.5,BbMx<2.5,BbAv<2.5,BbAH,BbAHh,BbMxAHH,BbAvAHH,BbMxAHA,BbAvAHA,PSCH,PSCD,PSCA

    path = '.\data\';
    odds_out = [];
    outcome_out = [];
    outcome_column = 7;
    odds_from_column = 24;
    odds_to_column = 44;
    n = odds_to_column - odds_from_column + 1;
    idxH = 1:3:n;
    idxD = 2:3:n;
    idxA = 3:3:n;
    for s = seasons
        for l = leagues
            file =  strcat(path, l, '0', ' (', num2str(s), ').csv');
            table = readtable(file);
            
            % odds
            odds = table2array(table(:, odds_from_column:odds_to_column));
            % outcome
%             outcome = table(:, outcome_column);
            outcome_H = 1*(cell2mat(table2array(table(:, outcome_column))) == 'H');
            outcome_D = 2*(cell2mat(table2array(table(:, outcome_column))) == 'D');
            outcome_A = 3*(cell2mat(table2array(table(:, outcome_column))) == 'A');
            m = size(odds,1);
                % i) NaNs -> mean
                while(sum(sum(isnan(odds))))
                    a = find(isnan(odds));
                    row = mod(a(1), m);
                    if (row == 0)
                        row = m;
                    end
                    means = [ nanmean(odds(row, idxA)), ...
                        nanmean(odds(row, idxH)), ...
                        nanmean(odds(row, idxD)) ];
                    for i = 1:n
                        if(isnan(odds(row, i)))
                            odds(row,i) = means(mod(i,3) + 1);
                        end  
                    end
                end
                % ii) NaNs -> discard
%                 while(sum(sum(isnan(odds))))
%                     a = find(isnan(odds));
%                     row = mod(a(1), m);
%                     odds(row, :) = [];
%                     outcome(row,:) = [];
%                 end
            odds_out = [ odds_out; odds ];
            outcome_out = [ outcome_out; outcome_H + outcome_D + outcome_A ];
        end
    end
end


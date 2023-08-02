function [ output_args ] = masterScriptRandomWithIndifference( )
% Author: Niree Kodaverdian 


cd('/Users/nireekodaverdian/Desktop/transitivity_experiment');
mkdir('records_randomWithIndifference');
randomDataFolder = '/Users/nireekodaverdian/Desktop/transitivity_experiment/records_randomWithIndifference/'; % define path of folder holding pre-processed files
generalFolder = '/Users/nireekodaverdian/Desktop/transitivity_experiment/General/'; % define path of 'General' folder
addpath /Users/nireekodaverdian/Desktop/transitivity_experiment/

cd(generalFolder);
cd('Sets');
load('triplets.mat');  % load the 'triplets' file which includes all possible triplets (35 of them) for the 7 options
load('Treatment1.mat');
cd('../../');
cd(randomDataFolder);

violationSummaryTV = zeros(1,1);
loop = 1;
subjID = length(violationSummaryTV);
choices = zeros(21,1);

for j = 1:21
indifferentProb = (j-1)*(0.05);
subjID = 1;
while subjID < 100001
    
    % for each "subject," generate two vectors of random numbers. This will
    % determine their "choices"
    rng('shuffle') % shuffles seed so that random is more random
    randomNumber1 = rand(1,21);
    randomNumber2 = rand(1,21);

    % generate 21 "choices" based on the random numbers
    for i = 1:21
        if randomNumber1(i) < (1-indifferentProb)
            if randomNumber2(i) < 0.5;
                choices(i) = 1;
            elseif randomNumber2(i) >= 0.5;
                choices(i) = 2;
            end
        elseif randomNumber1(i) >= (1-indifferentProb);
            choices(i) = 0;
        end
    end

    if mod(subjID,10000) == 0
        sprintf('%s\t%d\n%s\t%d','subjID',subjID)
    end

    [violation] = violationCounter_randomWithIndifference(triplets, Treatment1, choices, violationSummaryTV);

    violationSummaryTV(subjID,j) = sum(violation); 
    subjID = subjID + 1;
end
violationSummaryMeans(j,1) = indifferentProb;
violationSummaryMeans(j,2) = mean(violationSummaryTV(:,j));
end

save('violationSummaryTV.mat','violationSummaryTV');
save('violationSummaryMeans.mat','violationSummaryMeans');
end

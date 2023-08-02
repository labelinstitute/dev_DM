function [ output_args ] = masterScriptRandom( )
% Author: Niree Kodaverdian 


cd('/Users/nireekodaverdian/Desktop/transitivity_experiment');
mkdir('records_random');
randomDataFolder = '/Users/nireekodaverdian/Desktop/transitivity_experiment/records_random/'; % define path of folder holding pre-processed files
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
subjID = 1;
choices = ones(21,1);


while subjID < 2097153 %when we only consider left and right (no indifference) there are 2097152 possible combinations of 21 choices 
    % the case of choosing the left option ("1") always is not included in code (which would
    % give transitivity violation score of 0) and - I believe - the case of
    % choosing the right option ("2") always is also not included (which
    % would also give a TV score of 0) ... thus, resulting output is of
    % length 2097150 instead of 2097152
    combinations = nchoosek(1:21,loop);     % combinations of size 'loop' of the 21 trials
    forLength = length(combinations);
    for i = 1:forLength
        choices = ones(21,1);
        subjectsDone = length(violationSummaryTV);
        if mod(subjID,10000) == 0
            sprintf('%s\t%d\n%s\t%d','subjID',subjID,'length',forLength)
        end
        for j = 1:length(combinations(1,:))  % always will be same length for a given loop
            choices(combinations(i,j)) = 2;
        end
        [violationSummaryTV] = violationCounter_random(subjID, subjectsDone, triplets, Treatment1, choices, violationSummaryTV);
        subjID = subjID + 1;
    end
    save('violationSummaryTV.mat','violationSummaryTV');
    loop = loop + 1;
end


% unfinished... trying to do it for the case where it is equally likely to
% press left, right, or indifferent buttons
% while subjID < 10460353203 
%     combinations = nchoosek(1:21,loop);     % combinations of size 'loop' of the 21 trials
%     forLength = length(combinations);
%     for i = 1:forLength
%         subjectsDone = length(violationSummaryTV);
%         if mod(subjID,10000) == 0
%             sprintf('%s\t%d\n%s\t%d','subjID',subjID,'length',forLength)
%         end
%         for j = 1:length(combinations(1,:))  % always will be same length for a given loop
%             choices(combinations(i,j)) = 2;
%         end
%         [violationSummaryTV] = randomTVviolations(subjID, subjectsDone, triplets, Treatment1, choices, violationSummaryTV);
%         choices = randomChoices;
%         subjID = subjID + 1;
%     end
%     save('violationSummaryTV.mat','violationSummaryTV');
%     loop = loop + 1;
% end

end
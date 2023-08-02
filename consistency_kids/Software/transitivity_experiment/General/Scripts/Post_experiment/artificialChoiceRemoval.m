function [ loop, remainingChoices ] = artificialChoiceRemoval( treatment,preProcessedFolder,triplets,tripletSetIndex,subjects,folder )
% Author: Niree Kodaverdian

cd('../../');
cd(preProcessedFolder);
cd(subjects(folder).name);
load('preProcessed.mat');
load('violations.mat');

if treatment == 1               % load choice file, for given subject
    choices = preProcessed.treat1.choices(1:21,1);
elseif treatment == 2
    choices = preProcessed.treat2.choices(1:21,1);
elseif treatment == 3
    choices = preProcessed.treat3.choices(1:21,1);
end

completedProcess = 0;  
loop = 1;
set = preProcessed.settings.treat1.Set;
remainingTriplets = triplets;
remainingChoices = choices;
    
while completedProcess == 0
        combinations = nchoosek(1:length(choices),loop);% combinations of size 'loop' of the 21 trials
    for i = 1:length(combinations)

        tripletsToRemove = tripletSetIndex(combinations(i,:),:);   % row of 5 entries corresponding to triplets that will have to be removed
        remainingTriplets(tripletsToRemove,:) = [];   % remove at least 5 rows from 'remainingTriplets' vector
        
        index1 = zeros(length(remainingTriplets),1); % vector of zeros. made so that 'index1' does not change size with each loop and in turn, produce annoying squiggly red lines under the word in the loop
        index2 = zeros(length(remainingTriplets),1); % same as above
        index3 = zeros(length(remainingTriplets),1); % same as above
    
        for m = 1:length(remainingTriplets)
            first = remainingTriplets(m,1); % first element of a given row m
            second = remainingTriplets(m,2); % second element of a given row m
            third = remainingTriplets(m,3); % third element of a given row m
            
            index1First = find(set(:,1) == first);
            index1Second = find(set(index1First,2) == second); % use treat1.Set for all treatments, since same order across treatments
            index1(m,1) = index1First(index1Second); % index1 corresponds to the trial number in which the first and second options (elements of the given 'remainingTriplets' row) are compared
            
            index2First = find(set(:,1) == second);
            index2Second = find(set(index2First,2) == third);
            index2(m,1) = index2First(index2Second); % index2 corresponds to the trial number in which the second and third options (elements of the given 'remainingTriplets' row) are compared
            
            index3First = find(set(:,1) == first);
            index3Second = find(set(index3First,2) == third);
            index3(m,1) = index3First(index3Second); % index3 corresponds to the trial number in which the first and third options (elements of the given 'remainingTriplets' row) are compared
        end
        
        [completedProcess] = violationTVcounterForReversalsRemovals(index1,index2,index3,remainingChoices,remainingTriplets); 
        
        if completedProcess == 1
            remainingChoices(combinations(i,:),:) = []; % delete i-th choice (or 2, 3, 4, ... i-th choices)
            break
        elseif completedProcess == 0
            remainingTriplets = triplets; % effectively undoes changes that were made to 'triplets'
        end
    end
    if completedProcess == 1
        loop = loop + 0;
        break
    elseif completedProcess == 0 
        loop = loop + 1;
    end
end

end


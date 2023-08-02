function [loop, consistentChoices] = artificialChoiceReversal(treatment,index1,index2,index3,triplets,preProcessedFolder,subjects,folder)
% Author: Niree Kodaverdian

%   Does not consider the catch trial (22nd trial of each
%   treatment). If a subject made a violation on the catch trial, then one
%   more choice would need to be reversed in addition to what the program
%   finds (reported as 'loop') is the number of choices to be reversed for perfect consistency
%   (as counted by transitivity violations of triplets)

cd('../../');
cd(preProcessedFolder);
cd(subjects(folder).name);
load('preProcessed.mat');
load('violations.mat');

completedProcess = 0;  
loop = 1;

if treatment == 1               % load choice file, for given subject
    choices = preProcessed.treat1.choices(1:21,1);
elseif treatment == 2
    choices = preProcessed.treat2.choices(1:21,1);
elseif treatment == 3
    choices = preProcessed.treat3.choices(1:21,1);
end

while completedProcess == 0
    combinations = nchoosek(1:21,loop);     % combinations of size 'loop' of the 21 trials 
    possibleChoices = npermutek(0:2,loop);  % permutations of size 'loop' for possible responses (0 = indifferent, 1 = left option, 2 = right option)
    for i = 1:length(combinations)
        for k = 1:length(possibleChoices)
            for j = 1:length(combinations(1,:))  % always will be same length for a given loop
                choices(combinations(i,j)) = possibleChoices(k,j);
            end
            [completedProcess] = violationTVcounterForReversalsRemovals(index1,index2,index3,choices,triplets);      % count the violations now. 
            if completedProcess == 1                                                    % if no violations, then completedProcess = 1 and code breaks
                consistentChoices = choices;
                break
            elseif completedProcess == 0
                if treatment == 1                               % un-do the choice reversals that were just applied before beginning loop again
                    choices = preProcessed.treat1.choices;
                elseif treatment == 2
                    choices = preProcessed.treat2.choices;
                elseif treatment == 3
                    choices = preProcessed.treat3.choices;
                end
            end
        end
        if completedProcess == 1
            break
        end
    end
    if completedProcess == 0
    loop = loop + 1;
    end
    if completedProcess == 1
        break 
    end
end

if treatment == 1 && violation.triplet.treat1Total == 0
    loop = loop - 1;
elseif treatment == 1 && violation.triplet.treat1Total ~= 0
    loop = loop + 0;
elseif treatment == 2 && violation.triplet.treat2Total == 0
    loop = loop - 1;
elseif treatment == 2 && violation.triplet.treat2Total ~= 0
    loop = loop  + 0;
elseif treatment == 3 && violation.triplet.treat3Total == 0
    loop = loop - 1;
elseif treatment == 3 && violation.triplet.treat3Total ~= 0
    loop = loop + 0;
end

end


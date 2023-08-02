% Author: Niree Kodaverdian

preProcessedFolder = '/Users/nireekodaverdian/Desktop/transitivity_experiment/preProcessed/'; % define path of folder holding pre-processed files
generalFolder = '/Users/nireekodaverdian/Desktop/transitivity_experiment/General/'; % define path of 'General' folder

cd(preProcessedFolder); % change directory to 'preProcessed' folder
subjects = dir;

% type of violation counting (half or full point violations)
type = 0.5; % to count transitivity violations involving indifferences as weaker than those not involving indifferences, leave this line uncommented
% type = 1; % otherwise, to count all transitivity violations in the same
% way, leave this line uncommented

for folder = 1:length(subjects) % for folder from 1 to length of directory, or number of subjects (see line 5)
    if ismember((subjects(folder).name(1)), {'.','v','n','r','m','h','p','e','t','T'}); % if file name starts with any of these
        continue % skip that file and continue onto next file name
    end
    
    folder % this is so that the folder number is printed in Command Window (just so you know how far along the analysis you've reached)
    cd(subjects(folder).name); % change directory to each subject in order
    load('preProcessed.mat'); % load that subject's 'preProcessed.mat' file
    load('violations.mat'); % load that subject's 'violation.mat' file
    
%     choiceReversals = violation.choiceReversals;
%     closestConsistentChoices = violation.closestConsistentChoices;
%     choiceRemovals = violation.choiceRemovals;
%     remainingConsistentChoices = violation.closestConsistentChoices;
    
    %% Count transitivity violations (TV) for subject
    % Depends on function violationTVcounter to run
    
    cd(generalFolder); % change directory to 'General' folder
    cd('Sets'); % change directory to 'Sets' folder within 'General'
    load('triplets.mat');  % load 'triplets.mat' file which includes all possible triplets (35 of them) for the 7 options
    load('tripletSetIndex.mat'); % load 'tripletSetIndex.mat'
    cd('../../'); % change directory back to 'General'
    cd(preProcessedFolder); % change directory to 'preProcessed'
    cd(subjects(folder).name); % change directory to specific subject
    
    index1triplets = zeros(length(triplets),1); % vector of 35 zeros; created so that 'index1triplets' does not change size with each loop and in turn, produce annoying squiggly red lines under the word in the loop
    index2triplets = zeros(length(triplets),1); % same as above
    index3triplets = zeros(length(triplets),1); % same as above
    
    for i = 1:length(triplets)
        firstTriplets = triplets(i,1); % first element of a given row i
        secondTriplets = triplets(i,2); % second element of a given row i
        thirdTriplets = triplets(i,3); % third element of a given row i
        
        index1FirstTriplets = find(preProcessed.settings.treat1.Set(:,1) == firstTriplets);
        index1SecondTriplets = find(preProcessed.settings.treat1.Set(index1FirstTriplets,2) == secondTriplets); % use treat1.Set for all treatments, since same order across treatments
        index1triplets(i,1) = index1FirstTriplets(index1SecondTriplets); % index1triplets corresponds to the trial number in which the first and second options (elements of the given 'triplets' row) are compared
        
        index2FirstTriplets = find(preProcessed.settings.treat1.Set(:,1) == secondTriplets);
        index2SecondTriplets = find(preProcessed.settings.treat1.Set(index2FirstTriplets,2) == thirdTriplets);
        index2triplets(i,1) = index2FirstTriplets(index2SecondTriplets); % index2triplets corresponds to the trial number in which the second and third options (elements of the given 'triplets' row) are compared
        
        index3FirstTriplets = find(preProcessed.settings.treat1.Set(:,1) == firstTriplets);
        index3SecondTriplets = find(preProcessed.settings.treat1.Set(index3FirstTriplets,2) == thirdTriplets);
        index3triplets(i,1) = index3FirstTriplets(index3SecondTriplets); % index3triplets corresponds to the trial number in which the first and third options (elements of the given 'triplets' row) are compared
    end
    
    % For Goods choice task
    for i = 1:length(triplets)
        choice1(i) = preProcessed.treat1.choices(index1triplets(i,1));
        choice2(i) = preProcessed.treat1.choices(index2triplets(i,1));
        choice3(i) = preProcessed.treat1.choices(index3triplets(i,1));
    end
    
    [violationTV,violationTotal,indifference,indifferenceTotal,TVandIndiff,TVandIndiffTotal] = violationTVcounter(type,choice1,choice2,choice3);
    % reorganize outputs from function above as a structure
    violation.triplet.treat1 = violationTV;
    violation.triplet.treat1Total = violationTotal;
    violation.indifferentChoices.treat1 = indifference;
    violation.indifferencesTotal.treat1 = indifferenceTotal;
    violation.TVandIndiffTotal.treat1 = TVandIndiffTotal;
    
    for i = 1:length(tripletSetIndex)
        if sum(violation.triplet.treat1(tripletSetIndex(i,1:length(tripletSetIndex(1,:))))) ~= 0
            violation.treat1TVbinary(i,1) = 1;
            violation.treat1TV(i,1) = sum(violation.triplet.treat1(tripletSetIndex(i,1:length(tripletSetIndex(1,:)))));
        elseif sum(violation.triplet.treat1(tripletSetIndex(i,1:length(tripletSetIndex(1,:))))) == 0
            violation.treat1TVbinary(i,1) = 0;
            violation.treat1TV(i,1) = sum(violation.triplet.treat1(tripletSetIndex(i,1:length(tripletSetIndex(1,:)))));
        end
    end
    
    % For Social choice task
    for i = 1:length(triplets)
        choice1(i) = preProcessed.treat3.choices(index1triplets(i,1));
        choice2(i) = preProcessed.treat3.choices(index2triplets(i,1));
        choice3(i) = preProcessed.treat3.choices(index3triplets(i,1));
    end
    [violationTV,violationTotal,indifference,indifferenceTotal,TVandIndiff,TVandIndiffTotal] = violationTVcounter(type,choice1,choice2,choice3);
    % reorganize outputs from function above as a structure
    violation.triplet.treat3 = violationTV;
    violation.triplet.treat3Total = violationTotal;
    violation.indifferentChoices.treat3 = indifference;
    violation.indifferencesTotal.treat3 = indifferenceTotal;
    violation.TVandIndiffTotal.treat3 = TVandIndiffTotal;
    
    for i = 1:length(tripletSetIndex)
        if sum(violation.triplet.treat3(tripletSetIndex(i,1:length(tripletSetIndex(1,:))))) ~= 0
            violation.treat3TVbinary(i,1) = 1;
            violation.treat3TV(i,1) = sum(violation.triplet.treat3(tripletSetIndex(i,1:length(tripletSetIndex(1,:)))));
        elseif sum(violation.triplet.treat3(tripletSetIndex(i,1:length(tripletSetIndex(1,:))))) == 0
            violation.treat3TVbinary(i,1) = 0;
            violation.treat3TV(i,1) = sum(violation.triplet.treat3(tripletSetIndex(i,1:length(tripletSetIndex(1,:)))));
        end
    end
    
    % For Risk choice task
    for i = 1:length(triplets)
        choice1(i) = preProcessed.treat2.choices(index1triplets(i,1));
        choice2(i) = preProcessed.treat2.choices(index2triplets(i,1));
        choice3(i) = preProcessed.treat2.choices(index3triplets(i,1));
    end
    
    [violationTV,violationTotal,indifference,indifferenceTotal,TVandIndiff,TVandIndiffTotal] = violationTVcounter(type,choice1,choice2,choice3);
    % reorganize outputs from function above as a structure
    violation.triplet.treat2 = violationTV;
    violation.triplet.treat2Total = violationTotal;
    violation.indifferentChoices.treat2 = indifference;
    violation.indifferencesTotal.treat2 = indifferenceTotal;
    violation.TVandIndiffTotal.treat2 = TVandIndiffTotal;
    
    for i = 1:length(tripletSetIndex)
        if sum(violation.triplet.treat2(tripletSetIndex(i,1:length(tripletSetIndex(1,:))))) ~= 0
            violation.treat2TVbinary(i,1) = 1;
            violation.treat2TV(i,1) = sum(violation.triplet.treat2(tripletSetIndex(i,1:length(tripletSetIndex(1,:)))));
        elseif sum(violation.triplet.treat2(tripletSetIndex(i,1:length(tripletSetIndex(1,:))))) == 0
            violation.treat2TVbinary(i,1) = 0;
            violation.treat2TV(i,1) = sum(violation.triplet.treat2(tripletSetIndex(i,1:length(tripletSetIndex(1,:)))));
        end
    end
    
    %% Detect use of heuristics (lexicographic and otherwise) for Social and Risk choice tasks
    % Depends on functions strategyDetectorSocial and strategyDetectorRisk
    % to run
    
    % For Social
    set = preProcessed.settings.treat3.Set;
    choice = preProcessed.treat3.choices;
    
    [memax,othermax,summax,memaxOthermax,memaxOthermin,summaxMemax,summaxOthermax] = strategyDetectorSocial(set,choice);
    % reorganize outputs from function above as a structure
    heuristic.bytrial.treat3.memax = memax;
    heuristic.bytrial.treat3.othermax = othermax;
    heuristic.bytrial.treat3.summax = summax;
    heuristic.bytrial.treat3.memaxOthermax = memaxOthermax;
    heuristic.bytrial.treat3.memaxOthermin = memaxOthermin;
    heuristic.bytrial.treat3.summaxMemax = summaxMemax;
    heuristic.bytrial.treat3.summaxOthermax = summaxOthermax;
    
    % reorganize sums of outputs from function above as a structure
    heuristic.totals.treat3.memax = sum(memax);
    heuristic.totals.treat3.othermax = sum(othermax);
    heuristic.totals.treat3.summax = sum(summax);
    heuristic.totals.treat3.memaxOthermax = sum(memaxOthermax);
    heuristic.totals.treat3.memaxOthermin = sum(memaxOthermin);
    heuristic.totals.treat3.summaxMemax = sum(summaxMemax);
    heuristic.totals.treat3.summaxOthermax = sum(summaxOthermax);
    
    % For Risk choice task
    set = preProcessed.settings.treat2.Set;
    choice = preProcessed.treat2.choices;
    
    [probmax,amountmax,expectmax,probmaxAmountmax,amountmaxProbmax,expectmaxAmountmax,expectmaxProbmax,expectmaxIndiff] = strategyDetectorRisk(set,choice);
    % reorganize outputs from function above as a structure
    heuristic.bytrial.treat2.probmax = probmax;
    heuristic.bytrial.treat2.amountmax = amountmax;
    heuristic.bytrial.treat2.expectmax = expectmax;
    heuristic.bytrial.treat2.probmaxAmountmax = probmaxAmountmax;
    heuristic.bytrial.treat2.amountmaxProbmax = amountmaxProbmax;
    heuristic.bytrial.treat2.expectmaxAmountmax = expectmaxAmountmax;
    heuristic.bytrial.treat2.expectmaxProbmax = expectmaxProbmax;
    heuristic.bytrial.treat2.expectmaxIndiff = expectmaxIndiff;
    
    % reorganize sums of outputs from function above as a structure
    heuristic.totals.treat2.probmax = sum(probmax);
    heuristic.totals.treat2.amountmax = sum(amountmax);
    heuristic.totals.treat2.expectmax = sum(expectmax);
    heuristic.totals.treat2.probmaxAmountmax = sum(probmaxAmountmax);
    heuristic.totals.treat2.amountmaxProbmax = sum(amountmaxProbmax);
    heuristic.totals.treat2.expectmaxAmountmax = sum(expectmaxAmountmax);
    heuristic.totals.treat2.expectmaxProbmax = sum(expectmaxProbmax);
    heuristic.totals.treat2.expectmaxIndiff = sum(expectmaxIndiff);
    
    %% Count violations between choices and explicit rankings (IC-E)
    % Depends on function violationICEcounter to run
    
    leftOption = preProcessed.settings.treat1.Set(:,1);
    rightOption = preProcessed.settings.treat1.Set(:,2);
    
    % For Goods
    choice = preProcessed.treat1.choices(:);
    for i = 1:21
        leftOptionRankIndex(i) = find(preProcessed.behavioral.rank1.key(1,:) == leftOption(i));
        leftOptionRank(i) = preProcessed.behavioral.rank1.key(2,leftOptionRankIndex(i));
        rightOptionRankIndex(i) = find(preProcessed.behavioral.rank1.key(1,:) == rightOption(i));
        rightOptionRank(i) = preProcessed.behavioral.rank1.key(2,rightOptionRankIndex(i));
    end
    [violationICE, violationTotal] = violationICEcounter(type,leftOptionRank,rightOptionRank,choice);
    % reorganize outputs from function above as a structure
    violation.treat1ICE = violationICE;
    violation.treat1ICETotal = violationTotal;
    [C,J] = sort(preProcessed.behavioral.rank1.key(1,:),'ascend');
    for i = 1:length(J)
        C(2,i) = preProcessed.behavioral.rank1.key(2,J(i));
    end
    violation.elicitedRankDistribution.treat1 = C(2,:);
    % Checking for violation for catch trial of Goods
    catchTrial = preProcessed.treat1.choices(22);
    if catchTrial == 1
        violation.catch1 = 0;
    elseif catchTrial == 0
        violation.catch1 = 0.5;
    elseif catchTrial == 2
        violation.catch1 = 1;
    end
    
    % For Social
    choice = preProcessed.treat3.choices(:);
    for i = 1:21
        leftOptionRankIndex(i) = find(preProcessed.behavioral.rank3.key(1,:) == leftOption(i));
        leftOptionRank(i) = preProcessed.behavioral.rank3.key(2,leftOptionRankIndex(i));
        rightOptionRankIndex(i) = find(preProcessed.behavioral.rank3.key(1,:) == rightOption(i));
        rightOptionRank(i) = preProcessed.behavioral.rank3.key(2,rightOptionRankIndex(i));
    end
    [violationICE, violationTotal] = violationICEcounter(type,leftOptionRank,rightOptionRank,choice);
    % reorganize outputs from function above as a structure
    violation.treat3ICE = violationICE;
    violation.treat3ICETotal = violationTotal;
    [C,J] = sort(preProcessed.behavioral.rank3.key(1,:),'ascend');
    for i = 1:length(J)
        C(2,i) = preProcessed.behavioral.rank3.key(2,J(i));
    end
    violation.elicitedRankDistribution.treat3 = C(2,:);
    % Checking for violation for catch trial of Social
    catchTrial = preProcessed.treat3.choices(22);
    if catchTrial == 1
        violation.catch3 = 0;
    elseif catchTrial == 0
        violation.catch3 = 0.5;
    elseif catchTrial == 2
        violation.catch3 = 1;
    end
    
    % For Risk
    choice = preProcessed.treat2.choices(:);
    for i = 1:21
        leftOptionRankIndex(i) = find(preProcessed.behavioral.rank2.key(1,:) == leftOption(i));
        leftOptionRank(i) = preProcessed.behavioral.rank2.key(2,leftOptionRankIndex(i));
        rightOptionRankIndex(i) = find(preProcessed.behavioral.rank2.key(1,:) == rightOption(i));
        rightOptionRank(i) = preProcessed.behavioral.rank2.key(2,rightOptionRankIndex(i));
    end
    [violationICE, violationTotal] = violationICEcounter(type,leftOptionRank,rightOptionRank,choice);
    % reorganize outputs from function above as a structure
    violation.treat2ICE = violationICE;
    violation.treat2ICETotal = violationTotal;
    [C,J] = sort(preProcessed.behavioral.rank2.key(1,:),'ascend');
    for i = 1:length(J)
        C(2,i) = preProcessed.behavioral.rank2.key(2,J(i));
    end
    violation.elicitedRankDistribution.treat2 = C(2,:);
    % Checking for violation for catch trial of Risk
    catchTrial = preProcessed.treat2.choices(22);
    if catchTrial == 1
        violation.catch2 = 0;
    elseif catchTrial == 0
        violation.catch2 = 0.5;
    elseif catchTrial == 2
        violation.catch2 = 1;
    end
    %% Count violations between choices and implicit, or revealed rankings (IC-R)
    % Depends on function violationICRcounter to run
    
    leftOption(:) = preProcessed.settings.treat1.Set(:,1);
    rightOption(:) = preProcessed.settings.treat1.Set(:,2);
    
    % For Goods
    choice = preProcessed.treat1.choices(:);
    for i = 1:21
        leftOptionRank(i) = preProcessed.behavioral.treat1.tally.total(leftOption(i));
        rightOptionRank(i) = preProcessed.behavioral.treat1.tally.total(rightOption(i));
    end
    [ violationICR, violationTotal ] = violationICRcounter(type, leftOptionRank, rightOptionRank, choice );
    % reorganize outputs from function above as a structure
    violation.treat1ICR = violationICR;
    violation.treat1ICRTotal = violationTotal;
    
    % For Social
    choice = preProcessed.treat3.choices(:);
    for i = 1:21
        leftOptionRank(i) = preProcessed.behavioral.treat3.tally.total(leftOption(i));
        rightOptionRank(i) = preProcessed.behavioral.treat3.tally.total(rightOption(i));
    end
    [ violationICR, violationTotal ] = violationICRcounter(type, leftOptionRank, rightOptionRank, choice );
    % reorganize outputs from function above as a structure
    violation.treat3ICR = violationICR;
    violation.treat3ICRTotal = violationTotal;
    
    % For Risk
    choice = preProcessed.treat2.choices(:);
    for i = 1:21
        leftOptionRank(i) = preProcessed.behavioral.treat2.tally.total(leftOption(i));
        rightOptionRank(i) = preProcessed.behavioral.treat2.tally.total(rightOption(i));
    end
    [ violationICR, violationTotal ] = violationICRcounter(type, leftOptionRank, rightOptionRank, choice );
    % reorganize outputs from function above as a structure
    violation.treat2ICR = violationICR;
    violation.treat2ICRTotal = violationTotal;
    %% Count wrong answers to Animal Party questions
    
    cd(generalFolder);
    cd('Sets');
    load('solutionsAnimalParty.mat');
    cd('../../');
    cd(preProcessedFolder);
    cd(subjects(folder).name);
    
    for i = 1:length(solutionsAnimalParty) % 7 trials long
        string = preProcessed.behavioral.party.key(i);  % responses to animal party are saved as strings
        number = str2num(string);                       % convert these strings to numbers
        if  number == solutionsAnimalParty(i)           % if numerical version of response is same as solution to that question
            violation.party(i) = 0;                     % then error is 0
        elseif number ~= solutionsAnimalParty(i)        % otherwise
            violation.party(i) = 1;                     % error is 1
        end
    end
    
    violation.partyTotal = sum(violation.party);        % add up all errors for animal party to get total count
    
    %% Create matrix of choice-explicit ranking violations for the subject (based on earlier count of IC-E)
    
    % For Goods
    rankingValue = preProcessed.behavioral.rank1.key(2,:);
    rankingOption = preProcessed.behavioral.rank1.key(1,:);
    matrix1(1,3:9) = rankingValue;
    matrix1(3:9,1) = transpose(rankingValue);
    matrix1(2,3:9) = rankingOption;
    matrix1(3:9,2) = transpose(rankingOption);
    for trial = 1:length(preProcessed.settings.treat1.Set)
        matrix1(find(matrix1(:,2) == preProcessed.settings.treat1.Set(trial,1)),find(matrix1(2,:) == (preProcessed.settings.treat1.Set(trial,2)))) = violation.treat1ICE(trial); % matrix entry (i,j)
        matrix1(find(matrix1(:,2) == preProcessed.settings.treat1.Set(trial,2)),find(matrix1(2,:) == (preProcessed.settings.treat1.Set(trial,1)))) = violation.treat1ICE(trial); % fill the spot (j,i) with the same value as that of (i,j)
    end
    violation.matrixElicited.treat1 = matrix1;
    for i = 1:7
        violation.elicitedICEtotal.treat1(i,1) = violation.matrixElicited.treat1(i+2,1);
        violation.elicitedICEtotal.treat1(i,2) = violation.matrixElicited.treat1(i+2,2);
        violation.elicitedICEtotal.treat1(i,3) = sum(violation.matrixElicited.treat1(i+2,3:9));
    end
    
    violation.heatmapMatrix.treat1 = zeros(28,14); % this will be a matrix with ICE, ICR, TV, reaction times for all subjects to be used in making heat maps
    violation.heatmapMatrix.treat1(:,1:2) = cat(1,nchoosek([1,2,3,4,5,6,7],2),[1,1;2,2;3,3;4,4;5,5;6,6;7,7]); % first and second columns of violation.heatmapMatrix are all possible combinations of item ranks
    for i = 1:length(preProcessed.settings.treat1.Set)
        indx1 = preProcessed.behavioral.rank1.key(2,find(preProcessed.behavioral.rank1.key(1,:) == preProcessed.settings.treat1.Set(i,1))); % elicited ranking
        indx2 = preProcessed.behavioral.rank1.key(2,find(preProcessed.behavioral.rank1.key(1,:) == preProcessed.settings.treat1.Set(i,2)));
        indx3 = sort([indx1 indx2]); % sort them in ascending order, as this is how the first two columns of violation.heatmapMatrix are listed
        indx4 = find(violation.heatmapMatrix.treat1(:,1) == indx3(1));
        violation.heatmapMatrix.treat1(indx4((find(violation.heatmapMatrix.treat1(indx4,2) == indx3(2)))),3) = violation.heatmapMatrix.treat1(indx4((find(violation.heatmapMatrix.treat1(indx4,2) == indx3(2)))),3) + violation.treat1ICE(i);
        violation.heatmapMatrix.treat1(indx4((find(violation.heatmapMatrix.treat1(indx4,2) == indx3(2)))),4) = violation.heatmapMatrix.treat1(indx4((find(violation.heatmapMatrix.treat1(indx4,2) == indx3(2)))),4) + preProcessed.treat1.responseTimes(i);
        violation.heatmapMatrix.treat1(indx4((find(violation.heatmapMatrix.treat1(indx4,2) == indx3(2)))),7) = violation.heatmapMatrix.treat1(indx4((find(violation.heatmapMatrix.treat1(indx4,2) == indx3(2)))),7) + violation.treat1ICR(i);
        violation.heatmapMatrix.treat1(indx4((find(violation.heatmapMatrix.treat1(indx4,2) == indx3(2)))),8) = violation.heatmapMatrix.treat1(indx4((find(violation.heatmapMatrix.treat1(indx4,2) == indx3(2)))),8) + violation.treat1TV(i);
    end
    
    % For Social
    rankingValue = preProcessed.behavioral.rank3.key(2,:);
    rankingOption = preProcessed.behavioral.rank3.key(1,:);
    matrix3(1,3:9) = rankingValue;
    matrix3(3:9,1) = transpose(rankingValue);
    matrix3(2,3:9) = rankingOption;
    matrix3(3:9,2) = transpose(rankingOption);
    for trial = 1:length(preProcessed.settings.treat1.Set)
        matrix3(find(matrix3(:,2) == preProcessed.settings.treat1.Set(trial,1)),find(matrix3(2,:) == (preProcessed.settings.treat1.Set(trial,2)))) = violation.treat3ICE(trial); % matrix entry (i,j)
        matrix3(find(matrix3(:,2) == preProcessed.settings.treat1.Set(trial,2)),find(matrix3(2,:) == (preProcessed.settings.treat1.Set(trial,1)))) = violation.treat3ICE(trial); % fill the spot (j,i) with the same value as that of (i,j)
    end
    violation.matrixElicited.treat3 = matrix3;
    for i = 1:7
        violation.elicitedICEtotal.treat3(i,1) = violation.matrixElicited.treat3(i+2,1);
        violation.elicitedICEtotal.treat3(i,2) = violation.matrixElicited.treat3(i+2,2);
        violation.elicitedICEtotal.treat3(i,3) = sum(violation.matrixElicited.treat3(i+2,3:9));
    end
    
    violation.heatmapMatrix.treat3 = zeros(28,14); % this will be a matrix with ICE, ICR, TV, reaction times for all subjects to be used in making heat maps
    violation.heatmapMatrix.treat3(:,1:2) = cat(1,nchoosek([1,2,3,4,5,6,7],2),[1,1;2,2;3,3;4,4;5,5;6,6;7,7]); % first and second columns of violation.heatmapMatrix are all possible combinations of item ranks
    for i = 1:length(preProcessed.settings.treat3.Set)
        indx1 = preProcessed.behavioral.rank3.key(2,find(preProcessed.behavioral.rank3.key(1,:) == preProcessed.settings.treat1.Set(i,1)));
        indx2 = preProcessed.behavioral.rank3.key(2,find(preProcessed.behavioral.rank3.key(1,:) == preProcessed.settings.treat1.Set(i,2)));
        indx3 = sort([indx1 indx2]); % sort them in ascending order, as this is how the first two columns of violation.heatmapMatrix are listed
        indx4 = find(violation.heatmapMatrix.treat3(:,1) == indx3(1));
        violation.heatmapMatrix.treat3(indx4((find(violation.heatmapMatrix.treat3(indx4,2) == indx3(2)))),3) = violation.heatmapMatrix.treat3(indx4((find(violation.heatmapMatrix.treat3(indx4,2) == indx3(2)))),3) + violation.treat3ICE(i);
        violation.heatmapMatrix.treat3(indx4((find(violation.heatmapMatrix.treat3(indx4,2) == indx3(2)))),4) = violation.heatmapMatrix.treat3(indx4((find(violation.heatmapMatrix.treat3(indx4,2) == indx3(2)))),4) + preProcessed.treat3.responseTimes(i);
        violation.heatmapMatrix.treat3(indx4((find(violation.heatmapMatrix.treat3(indx4,2) == indx3(2)))),7) = violation.heatmapMatrix.treat3(indx4((find(violation.heatmapMatrix.treat3(indx4,2) == indx3(2)))),7) + violation.treat3ICR(i);
        violation.heatmapMatrix.treat3(indx4((find(violation.heatmapMatrix.treat3(indx4,2) == indx3(2)))),8) = violation.heatmapMatrix.treat3(indx4((find(violation.heatmapMatrix.treat3(indx4,2) == indx3(2)))),8) + violation.treat3TV(i);
        
    end
    
    % For Risk
    rankingValue = preProcessed.behavioral.rank2.key(2,:);
    rankingOption = preProcessed.behavioral.rank2.key(1,:);
    matrix2(1,3:9) = rankingValue;
    matrix2(3:9,1) = transpose(rankingValue);
    matrix2(2,3:9) = rankingOption;
    matrix2(3:9,2) = transpose(rankingOption);
    for trial = 1:length(preProcessed.settings.treat1.Set)
        matrix2(find(matrix2(:,2) == preProcessed.settings.treat1.Set(trial,1)),find(matrix2(2,:) == (preProcessed.settings.treat1.Set(trial,2)))) = violation.treat2ICE(trial); % matrix entry (i,j)
        matrix2(find(matrix2(:,2) == preProcessed.settings.treat1.Set(trial,2)),find(matrix2(2,:) == (preProcessed.settings.treat1.Set(trial,1)))) = violation.treat2ICE(trial); % fill the spot (j,i) with the same value as that of (i,j)
    end
    violation.matrixElicited.treat2 = matrix2;
    for i = 1:7
        violation.elicitedICEtotal.treat2(i,1) = violation.matrixElicited.treat2(i+2,1);
        violation.elicitedICEtotal.treat2(i,2) = violation.matrixElicited.treat2(i+2,2);
        violation.elicitedICEtotal.treat2(i,3) = sum(violation.matrixElicited.treat2(i+2,3:9));
    end
    
    violation.heatmapMatrix.treat2 = zeros(28,14); % this will be a matrix with ICE, ICR, TV, reaction times for all subjects to be used in making heat maps
    violation.heatmapMatrix.treat2(:,1:2) = cat(1,nchoosek([1,2,3,4,5,6,7],2),[1,1;2,2;3,3;4,4;5,5;6,6;7,7]); % first and second columns of violation.heatmapMatrix are all possible combinations of item ranks
    for i = 1:length(preProcessed.settings.treat2.Set)
        indx1 = preProcessed.behavioral.rank2.key(2,find(preProcessed.behavioral.rank2.key(1,:) == preProcessed.settings.treat1.Set(i,1)));
        indx2 = preProcessed.behavioral.rank2.key(2,find(preProcessed.behavioral.rank2.key(1,:) == preProcessed.settings.treat1.Set(i,2)));
        indx3 = sort([indx1 indx2]); % sort them in ascending order, as this is how the first two columns of violation.heatmapMatrix are listed
        indx4 = find(violation.heatmapMatrix.treat2(:,1) == indx3(1));
        violation.heatmapMatrix.treat2(indx4((find(violation.heatmapMatrix.treat2(indx4,2) == indx3(2)))),3) = violation.heatmapMatrix.treat2(indx4((find(violation.heatmapMatrix.treat2(indx4,2) == indx3(2)))),3) + violation.treat2ICE(i);
        violation.heatmapMatrix.treat2(indx4((find(violation.heatmapMatrix.treat2(indx4,2) == indx3(2)))),4) = violation.heatmapMatrix.treat2(indx4((find(violation.heatmapMatrix.treat2(indx4,2) == indx3(2)))),4) + preProcessed.treat2.responseTimes(i);
        violation.heatmapMatrix.treat2(indx4((find(violation.heatmapMatrix.treat2(indx4,2) == indx3(2)))),7) = violation.heatmapMatrix.treat2(indx4((find(violation.heatmapMatrix.treat2(indx4,2) == indx3(2)))),7) + violation.treat2ICR(i);
        violation.heatmapMatrix.treat2(indx4((find(violation.heatmapMatrix.treat2(indx4,2) == indx3(2)))),8) = violation.heatmapMatrix.treat2(indx4((find(violation.heatmapMatrix.treat2(indx4,2) == indx3(2)))),8) + violation.treat2TV(i);
    end
    %% Create matrix of choice-implicit ranking violations for the subject (based on earlier count of IC-R)
    
    % For Goods
    [B,I] = sort(preProcessed.behavioral.treat1.tally.total(1,:),'descend');
    for i = 1:7                     % create a second row for vector I, with ranking value. If no ties, this second row will be [1 2 3 4 5 6 7]
        if i == 1
            I(2,i) = i;
        elseif i > 1
            if B(1,i) == B(1,i-1)
                I(2,i) = I(2,i-1);
            else
                I(2,i) = i;
            end
        end
    end
    rankingValue = I(2,:);          % second row of I becomes vector called rankingValue
    rankingOption = I(1,:);         % first row of I becomes vector called rankingOption
    matrix1(1,3:9) = rankingValue;  % first row of matrix1 takes on values of rankingValue
    matrix1(3:9,1) = transpose(rankingValue);   % as does the first column
    matrix1(2,3:9) = rankingOption; % second row of matrix1 takes on values of rankingOption
    matrix1(3:9,2) = transpose(rankingOption);  % as does the second column
    for trial = 1:length(preProcessed.settings.treat1.Set)
        matrix1(find(matrix1(:,2) == preProcessed.settings.treat1.Set(trial,1)),find(matrix1(2,:) == (preProcessed.settings.treat1.Set(trial,2)))) = violation.treat1ICR(trial); % matrix entry (i,j)
        matrix1(find(matrix1(:,2) == preProcessed.settings.treat1.Set(trial,2)),find(matrix1(2,:) == (preProcessed.settings.treat1.Set(trial,1)))) = violation.treat1ICR(trial); % fill the spot (j,i) with the same value as that of (i,j)
    end
    violation.matrixRevealed.treat1 = matrix1;
    for i = 1:7
        violation.revealedICRtotal.treat1(i,1) = violation.matrixRevealed.treat1(i+2,1);
        violation.revealedICRtotal.treat1(i,2) = violation.matrixRevealed.treat1(i+2,2);
        violation.revealedICRtotal.treat1(i,3) = sum(violation.matrixRevealed.treat1(i+2,3:9));
    end
    for i = 1:7
        violation.rankDistribution.treat1(I(1,i)) = I(2,i);
    end
    permuteMatrix = perms(1:7);
    matchedPermuteRow = 0;
    for i = 1:length(permuteMatrix)
        if violation.rankDistribution.treat1(1:7) == permuteMatrix(i,1:7)
            matchedPermuteRow = i;
            violation.rankDistribution.treat1matchedRowDistance = 0;
            break
        else
            matchedPermuteRow = 0;
        end
    end
    if matchedPermuteRow == 0
        for i = 1:length(permuteMatrix)
            difference(i,1:7) = abs(violation.rankDistribution.treat1(1:7) - permuteMatrix(i,1:7));
            sumDifference(i,1) = sum(difference(i,1:7));
        end
        matchedPermuteRow = find(sumDifference == min(sumDifference));
        distanceToPerfectMatch = min(sumDifference);
        violation.rankDistribution.treat1matchedRowDistance = distanceToPerfectMatch;
    end
    violation.rankDistribution.treat1matchedPermuteRow = matchedPermuteRow;
    
    % Add columns to heat map matrix with IC-R and reaction time data
    for i = 1:length(preProcessed.settings.treat1.Set)
        indx1 = rankingValue(find(rankingOption == preProcessed.settings.treat1.Set(i,1)));
        indx2 = rankingValue(find(rankingOption == preProcessed.settings.treat1.Set(i,2)));
        indx3 = sort([indx1 indx2]); % sort them in ascending order, as this is how the first two columns of violation.heatmapMatrix are listed
        indx4 = find(violation.heatmapMatrix.treat1(:,1) == indx3(1));
        violation.heatmapMatrix.treat1(indx4((find(violation.heatmapMatrix.treat1(indx4,2) == indx3(2)))),5) = violation.heatmapMatrix.treat1(indx4((find(violation.heatmapMatrix.treat1(indx4,2) == indx3(2)))),5) + violation.treat1ICR(i);
        violation.heatmapMatrix.treat1(indx4((find(violation.heatmapMatrix.treat1(indx4,2) == indx3(2)))),6) = violation.heatmapMatrix.treat1(indx4((find(violation.heatmapMatrix.treat1(indx4,2) == indx3(2)))),6) + preProcessed.treat1.responseTimes(i);
        violation.heatmapMatrix.treat1(indx4((find(violation.heatmapMatrix.treat1(indx4,2) == indx3(2)))),9) = violation.heatmapMatrix.treat1(indx4((find(violation.heatmapMatrix.treat1(indx4,2) == indx3(2)))),9) + violation.treat1ICE(i);
        violation.heatmapMatrix.treat1(indx4((find(violation.heatmapMatrix.treat1(indx4,2) == indx3(2)))),10) = violation.heatmapMatrix.treat1(indx4((find(violation.heatmapMatrix.treat1(indx4,2) == indx3(2)))),10) + violation.treat1TV(i);
    end
    
    % For Social
    [B,I] = sort(preProcessed.behavioral.treat3.tally.total(1,:),'descend');
    for i = 1:7
        if i == 1
            I(2,i) = i;
        elseif i > 1
            if B(1,i) == B(1,i-1)
                I(2,i) = I(2,i-1);
            else
                I(2,i) = i;
            end
        end
    end
    rankingValue = I(2,:);
    rankingOption = I(1,:);
    matrix3(1,3:9) = rankingValue;
    matrix3(3:9,1) = transpose(rankingValue);
    matrix3(2,3:9) = rankingOption;
    matrix3(3:9,2) = transpose(rankingOption);
    for trial = 1:length(preProcessed.settings.treat1.Set)
        matrix3(find(matrix3(:,2) == preProcessed.settings.treat1.Set(trial,1)),find(matrix3(2,:) == (preProcessed.settings.treat1.Set(trial,2)))) = violation.treat3ICR(trial); % matrix entry (i,j)
        matrix3(find(matrix3(:,2) == preProcessed.settings.treat1.Set(trial,2)),find(matrix3(2,:) == (preProcessed.settings.treat1.Set(trial,1)))) = violation.treat3ICR(trial); % fill the spot (j,i) with the same value as that of (i,j)
    end
    violation.matrixRevealed.treat3 = matrix3;
    for i = 1:7
        violation.revealedICRtotal.treat3(i,1) = violation.matrixRevealed.treat3(i+2,1);
        violation.revealedICRtotal.treat3(i,2) = violation.matrixRevealed.treat3(i+2,2);
        violation.revealedICRtotal.treat3(i,3) = sum(violation.matrixRevealed.treat3(i+2,3:9));
    end
    
    for i = 1:7
        violation.rankDistribution.treat3(I(1,i)) = I(2,i);
    end
    permuteMatrix = perms(1:7);
    matchedPermuteRow = 0;
    for i = 1:length(permuteMatrix)
        if violation.rankDistribution.treat3(1:7) == permuteMatrix(i,1:7)
            matchedPermuteRow = i;
            violation.rankDistribution.treat3matchedRowDistance = 0;
            break
        else
            matchedPermuteRow = 0;
        end
    end
    if matchedPermuteRow == 0
        for i = 1:length(permuteMatrix)
            difference(i,1:7) = abs(violation.rankDistribution.treat3(1:7) - permuteMatrix(i,1:7));
            sumDifference(i,1) = sum(difference(i,1:7));
        end
        matchedPermuteRow = find(sumDifference == min(sumDifference));
        distanceToPerfectMatch = min(sumDifference);
        violation.rankDistribution.treat3matchedRowDistance = distanceToPerfectMatch;
    end
    violation.rankDistribution.treat3matchedPermuteRow = matchedPermuteRow;
    
    % Add columns to heat map matrix with IC-R and reaction time data
    for i = 1:length(preProcessed.settings.treat3.Set)
        indx1 = rankingValue(find(rankingOption == preProcessed.settings.treat1.Set(i,1)));
        indx2 = rankingValue(find(rankingOption == preProcessed.settings.treat1.Set(i,2)));
        indx3 = sort([indx1 indx2]); % sort them in ascending order, as this is how the first two columns of violation.heatmapMatrix are listed
        indx4 = find(violation.heatmapMatrix.treat3(:,1) == indx3(1));
        violation.heatmapMatrix.treat3(indx4((find(violation.heatmapMatrix.treat3(indx4,2) == indx3(2)))),5) = violation.heatmapMatrix.treat3(indx4((find(violation.heatmapMatrix.treat3(indx4,2) == indx3(2)))),5) + violation.treat3ICR(i);
        violation.heatmapMatrix.treat3(indx4((find(violation.heatmapMatrix.treat3(indx4,2) == indx3(2)))),6) = violation.heatmapMatrix.treat3(indx4((find(violation.heatmapMatrix.treat3(indx4,2) == indx3(2)))),6) + preProcessed.treat3.responseTimes(i);
        violation.heatmapMatrix.treat3(indx4((find(violation.heatmapMatrix.treat3(indx4,2) == indx3(2)))),9) = violation.heatmapMatrix.treat3(indx4((find(violation.heatmapMatrix.treat3(indx4,2) == indx3(2)))),9) + violation.treat3ICE(i);
        violation.heatmapMatrix.treat3(indx4((find(violation.heatmapMatrix.treat3(indx4,2) == indx3(2)))),10) = violation.heatmapMatrix.treat3(indx4((find(violation.heatmapMatrix.treat3(indx4,2) == indx3(2)))),10) + violation.treat3TV(i);
    end
    
    % For Risk
    [B,I] = sort(preProcessed.behavioral.treat2.tally.total(1,:),'descend');
    for i = 1:7
        if i == 1
            I(2,i) = i;
        elseif i > 1
            if B(1,i) == B(1,i-1)
                I(2,i) = I(2,i-1);
            else
                I(2,i) = i;
            end
        end
    end
    rankingValue = I(2,:);
    rankingOption = I(1,:);
    matrix2(1,3:9) = rankingValue;
    matrix2(3:9,1) = transpose(rankingValue);
    matrix2(2,3:9) = rankingOption;
    matrix2(3:9,2) = transpose(rankingOption);
    for trial = 1:length(preProcessed.settings.treat1.Set)
        matrix2(find(matrix2(:,2) == preProcessed.settings.treat1.Set(trial,1)),find(matrix2(2,:) == (preProcessed.settings.treat1.Set(trial,2)))) = violation.treat2ICR(trial); % matrix entry (i,j)
        matrix2(find(matrix2(:,2) == preProcessed.settings.treat1.Set(trial,2)),find(matrix2(2,:) == (preProcessed.settings.treat1.Set(trial,1)))) = violation.treat2ICR(trial); % fill the spot (j,i) with the same value as that of (i,j)
    end
    violation.matrixRevealed.treat2 = matrix2;
    for i = 1:7
        violation.revealedICRtotal.treat2(i,1) = violation.matrixRevealed.treat2(i+2,1);
        violation.revealedICRtotal.treat2(i,2) = violation.matrixRevealed.treat2(i+2,2);
        violation.revealedICRtotal.treat2(i,3) = sum(violation.matrixRevealed.treat2(i+2,3:9));
    end
    for i = 1:7
        violation.rankDistribution.treat2(I(1,i)) = I(2,i);
    end
    permuteMatrix = perms(1:7);
    matchedPermuteRow = 0;
    for i = 1:length(permuteMatrix)
        if violation.rankDistribution.treat2(1:7) == permuteMatrix(i,1:7)
            matchedPermuteRow = i;
            violation.rankDistribution.treat2matchedRowDistance = 0;
            break
        else
            matchedPermuteRow = 0;
        end
    end
    if matchedPermuteRow == 0
        for i = 1:length(permuteMatrix)
            difference(i,1:7) = abs(violation.rankDistribution.treat2(1:7) - permuteMatrix(i,1:7));
            sumDifference(i,1) = sum(difference(i,1:7));
        end
        matchedPermuteRow = find(sumDifference == min(sumDifference));
        distanceToPerfectMatch = min(sumDifference);
        violation.rankDistribution.treat2matchedRowDistance = distanceToPerfectMatch;
    end
    violation.rankDistribution.treat2matchedPermuteRow = matchedPermuteRow;
    
    % Add columns to heat map matrix with IC-R and reaction time data
    for i = 1:length(preProcessed.settings.treat2.Set)
        indx1 = rankingValue(find(rankingOption == preProcessed.settings.treat1.Set(i,1)));
        indx2 = rankingValue(find(rankingOption == preProcessed.settings.treat1.Set(i,2)));
        indx3 = sort([indx1 indx2]); % sort them in ascending order, as this is how the first two columns of violation.heatmapMatrix are listed
        indx4 = find(violation.heatmapMatrix.treat2(:,1) == indx3(1));
        violation.heatmapMatrix.treat2(indx4((find(violation.heatmapMatrix.treat2(indx4,2) == indx3(2)))),5) = violation.heatmapMatrix.treat2(indx4((find(violation.heatmapMatrix.treat2(indx4,2) == indx3(2)))),5) + violation.treat2ICR(i);
        violation.heatmapMatrix.treat2(indx4((find(violation.heatmapMatrix.treat2(indx4,2) == indx3(2)))),6) = violation.heatmapMatrix.treat2(indx4((find(violation.heatmapMatrix.treat2(indx4,2) == indx3(2)))),6) + preProcessed.treat2.responseTimes(i);
        violation.heatmapMatrix.treat2(indx4((find(violation.heatmapMatrix.treat2(indx4,2) == indx3(2)))),9) = violation.heatmapMatrix.treat2(indx4((find(violation.heatmapMatrix.treat2(indx4,2) == indx3(2)))),9) + violation.treat2ICE(i);
        violation.heatmapMatrix.treat2(indx4((find(violation.heatmapMatrix.treat2(indx4,2) == indx3(2)))),10) = violation.heatmapMatrix.treat2(indx4((find(violation.heatmapMatrix.treat2(indx4,2) == indx3(2)))),10) + violation.treat2TV(i);
    end
    
    
    % most and least favorite (revealed) options
    violation.revealedMostFavorite.treat1 = find(violation.rankDistribution.treat1 == 1);
    violation.revealedLeastFavorite.treat1 = find(violation.rankDistribution.treat1 == max(violation.rankDistribution.treat1));
    
    violation.revealedMostFavorite.treat2 = find(violation.rankDistribution.treat2 == 1);
    violation.revealedLeastFavorite.treat2 = find(violation.rankDistribution.treat2 == max(violation.rankDistribution.treat2));
    
    violation.revealedMostFavorite.treat3 = find(violation.rankDistribution.treat3 == 1);
    violation.revealedLeastFavorite.treat3 = find(violation.rankDistribution.treat3 == max(violation.rankDistribution.treat3));
    
    %% Measure distance between implicit and explicit ranking of options for each subject
    
    % For Goods
    [B,I] = sort(preProcessed.behavioral.treat1.tally.total(1,:),'descend');
    for i = 1:7
        if i == 1
            I(2,i) = i;
        elseif i > 1
            if B(1,i) == B(1,i-1)
                I(2,i) = I(2,i-1);
            else
                % I(2,i) = I(2,i-1) + 1; QUESTION to ASK JUAN: should we do
                % ranking as such? or as follows...
                I(2,i) = i;
            end
        end
    end
    for i = 1:7
        explicitOption = preProcessed.behavioral.rank1.key(1,i);
        explicitRank = preProcessed.behavioral.rank1.key(2,i);
        revealedOption = find(I(1,:) == explicitOption);
        revealedRank = I(2,revealedOption);
        violation.discrepancyRvlXpl.treat1(i,1) = pdist2(revealedRank,explicitRank);            % the discrepancy or distance between revealed and elicited rankings
    end
    violation.discrepancyRvlXpl.treat1Average = mean(violation.discrepancyRvlXpl.treat1);
    
    
    % For Social
    [B,I] = sort(preProcessed.behavioral.treat3.tally.total(1,:),'descend');
    for i = 1:7
        if i == 1
            I(2,i) = i;
        elseif i > 1
            if B(1,i) == B(1,i-1)
                I(2,i) = I(2,i-1);
            else
                I(2,i) = i;
            end
        end
    end
    for i = 1:7
        explicitOption = preProcessed.behavioral.rank3.key(1,i);
        explicitRank = preProcessed.behavioral.rank3.key(2,i);
        revealedOption = find(I(1,:) == explicitOption);
        revealedRank = I(2,revealedOption);
        violation.discrepancyRvlXpl.treat3(i,1) = pdist2(revealedRank,explicitRank);            % the discrepancy or distance between revealed and elicited rankings
    end
    violation.discrepancyRvlXpl.treat3Average = mean(violation.discrepancyRvlXpl.treat3);
    
    
    % For Risk
    [B,I] = sort(preProcessed.behavioral.treat2.tally.total(1,:),'descend');
    for i = 1:7
        if i == 1
            I(2,i) = i;
        elseif i > 1
            if B(1,i) == B(1,i-1)
                I(2,i) = I(2,i-1);
            else
                I(2,i) = i;
            end
        end
    end
    for i = 1:7
        explicitOption = preProcessed.behavioral.rank2.key(1,i);
        explicitRank = preProcessed.behavioral.rank2.key(2,i);
        revealedOption = find(I(1,:) == explicitOption);
        revealedRank = I(2,revealedOption);
        violation.discrepancyRvlXpl.treat2(i,1) = pdist2(revealedRank,explicitRank);            % the discrepancy or distance between revealed and elicited rankings
    end
    violation.discrepancyRvlXpl.treat2Average = mean(violation.discrepancyRvlXpl.treat2);
    
    save('violations.mat','violation')
    %% Artificial choice REVERSALS to achieve triplet transitivity consistency
    
    leftOption = preProcessed.settings.treat1.Set(:,1);
    rightOption = preProcessed.settings.treat1.Set(:,2);
    
    % keep this code block commented-out after running once.
    for treatment = 1:3;
        [loop, consistentChoices] = artificialChoiceReversal(treatment,index1triplets,index2triplets,index3triplets,triplets,preProcessedFolder,subjects,folder);
        if treatment == 1
            violation.choiceReversals.treat1 = loop;
            violation.closestConsistentChoices.treat1 = consistentChoices;
            choice = consistentChoices;
            for i = 1:21
                leftOptionRankIndex(i) = find(preProcessed.behavioral.rank1.key(1,:) == leftOption(i));
                leftOptionRank(i) = preProcessed.behavioral.rank1.key(2,leftOptionRankIndex(i));
                rightOptionRankIndex(i) = find(preProcessed.behavioral.rank1.key(1,:) == rightOption(i));
                rightOptionRank(i) = preProcessed.behavioral.rank1.key(2,rightOptionRankIndex(i));
            end
            [violationICE, violationTotal] = violationICEcounter(type,leftOptionRank,rightOptionRank,choice);
            violation.treat1ICEafterReversals = violationICE;
            violation.treat1ICETotalafterReversals = violationTotal;
        elseif treatment == 2
            violation.choiceReversals.treat2 = loop;
            violation.closestConsistentChoices.treat2 = consistentChoices;
            choice = consistentChoices;
            for i = 1:21
                leftOptionRankIndex(i) = find(preProcessed.behavioral.rank2.key(1,:) == leftOption(i));
                leftOptionRank(i) = preProcessed.behavioral.rank2.key(2,leftOptionRankIndex(i));
                rightOptionRankIndex(i) = find(preProcessed.behavioral.rank2.key(1,:) == rightOption(i));
                rightOptionRank(i) = preProcessed.behavioral.rank2.key(2,rightOptionRankIndex(i));
            end
            [violationICE, violationTotal] = violationICEcounter(type,leftOptionRank,rightOptionRank,choice);
            violation.treat2ICEafterReversals = violationICE;
            violation.treat2ICETotalafterReversals = violationTotal;
        elseif treatment == 3
            violation.choiceReversals.treat3 = loop;
            violation.closestConsistentChoices.treat3 = consistentChoices;
            choice = consistentChoices;
            for i = 1:21
                leftOptionRankIndex(i) = find(preProcessed.behavioral.rank3.key(1,:) == leftOption(i));
                leftOptionRank(i) = preProcessed.behavioral.rank3.key(2,leftOptionRankIndex(i));
                rightOptionRankIndex(i) = find(preProcessed.behavioral.rank3.key(1,:) == rightOption(i));
                rightOptionRank(i) = preProcessed.behavioral.rank3.key(2,rightOptionRankIndex(i));
            end
            [violationICE, violationTotal] = violationICEcounter(type,leftOptionRank,rightOptionRank,choice);
            violation.treat3ICEafterReversals = violationICE;
            violation.treat3ICETotalafterReversals = violationTotal;
        end
    end
    
    
    %% Artificial choice REMOVALS to achieve triplet transitivity consistency
    
    % need to add "type" here
    
    % keep this code block commented-out after running once.
    for treatment = 1:3
        if treatment == 1 && violation.triplet.treat1Total ~= 0
            [loop, remainingChoices] = artificialChoiceRemoval(treatment, preProcessedFolder, triplets, tripletSetIndex, subjects, folder );
            violation.choiceRemovals.treat1 = loop;
            violation.remainingConsistentChoices.treat1 = remainingChoices;
        elseif treatment == 1 && violation.triplet.treat1Total == 0
            violation.choiceRemovals.treat1 = 0;
            violation.remainingConsistentChoices.treat1 = preProcessed.treat1.choices(1:21,1);
        elseif treatment == 2 && violation.triplet.treat2Total ~= 0
            [loop, remainingChoices] = artificialChoiceRemoval(treatment, preProcessedFolder, triplets, tripletSetIndex, subjects, folder );
            violation.choiceRemovals.treat2 = loop;
            violation.remainingConsistentChoices.treat2 = remainingChoices;
        elseif treatment == 2 && violation.triplet.treat2Total == 0
            violation.choiceRemovals.treat2 = 0;
            violation.remainingConsistentChoices.treat2 = preProcessed.treat2.choices(1:21,1);
        elseif treatment == 3 && violation.triplet.treat3Total ~= 0
            [loop, remainingChoices] = artificialChoiceRemoval(treatment, preProcessedFolder, triplets, tripletSetIndex, subjects, folder );
            violation.choiceRemovals.treat3 = loop;
            violation.remainingConsistentChoices.treat3 = remainingChoices;
        elseif treatment == 3 && violation.triplet.treat3Total == 0
            violation.choiceRemovals.treat3 = 0;
            violation.remainingConsistentChoices.treat3 = preProcessed.treat3.choices(1:21,1);
        end
    end
    
    save('violations.mat','violation')
    save('heuristics.mat','heuristic');
    
    %% Save everything up at the end and clear all variables except for those specified
    
    clearvars -except folder subjects preProcessedFolder generalFolder type
    
    cd('../');
    
end

subjects = dir;
violationSummary = zeros(length(subjects)-6,9);
rankDistribution.treat1.byPermuteRow = perms(1:7);
rankDistribution.treat1.byPermuteRow(:,8) = 0;
rankDistribution.treat2.byPermuteRow = perms(1:7);
rankDistribution.treat2.byPermuteRow(:,8) = 0;
rankDistribution.treat3.byPermuteRow = perms(1:7);
rankDistribution.treat3.byPermuteRow(:,8) = 0;
elicitedRankDistribution.treat1 = zeros(10);
elicitedRankDistribution.treat2 = zeros(10);
elicitedRankDistribution.treat3 = zeros(10);
matrixElicited.treat1 = zeros(7);
matrixElicited.treat2 = zeros(7);
matrixElicited.treat3 = zeros(7);
matrixRevealed.treat1 = zeros(7);
matrixRevealed.treat2 = zeros(7);
matrixRevealed.treat3 = zeros(7);
clear heatmapMatrix
heatmap = zeros(28,3);
heatmap(:,1:2) = cat(1,nchoosek([1,2,3,4,5,6,7],2),[1,1;2,2;3,3;4,4;5,5;6,6;7,7]);
heatmapMatrix.ice.treat1 = heatmap; % this will be a matrix with the sum of ICE, ICR, TV, reaction times for all subjects to be used in making heat maps
heatmapMatrix.iceAvgRxn.treat1 = heatmap;
heatmapMatrix.icr.treat1 = heatmap;
heatmapMatrix.icrAvgRxn.treat1 = heatmap;
heatmapMatrix.iceICR.treat1 = heatmap;
heatmapMatrix.iceTV.treat1 = heatmap;
heatmapMatrix.icrICE.treat1 = heatmap;
heatmapMatrix.icrTV.treat1 = heatmap;
heatmapMatrix.ice.treat2 = heatmap;
heatmapMatrix.iceAvgRxn.treat2 = heatmap;
heatmapMatrix.icr.treat2 = heatmap;
heatmapMatrix.icrAvgRxn.treat2 = heatmap;
heatmapMatrix.iceICR.treat2 = heatmap;
heatmapMatrix.iceTV.treat2 = heatmap;
heatmapMatrix.icrICE.treat2 = heatmap;
heatmapMatrix.icrTV.treat2 = heatmap;
heatmapMatrix.ice.treat3 = heatmap;
heatmapMatrix.iceAvgRxn.treat3 = heatmap;
heatmapMatrix.icr.treat3 = heatmap;
heatmapMatrix.icrAvgRxn.treat3 = heatmap;
heatmapMatrix.iceICR.treat3 = heatmap;
heatmapMatrix.iceTV.treat3 = heatmap;
heatmapMatrix.icrICE.treat3 = heatmap;
heatmapMatrix.icrTV.treat3 = heatmap;


for folder = 1:(length(subjects))
    
    if ismember((subjects(folder).name(1)), {'.','v','n','r','m','h','p','e','t','T'});
        continue
    end
    
    cd(subjects(folder).name);
    load('preProcessed.mat');
    load('violations.mat');
    load('heuristics.mat');
    
    
    if preProcessed.settings.gender == 'g'
        gender = 1;
    elseif preProcessed.settings.gender == 'b'
        gender = 0;
    end
    
    if preProcessed.settings.gradeLevel == 'k'
        gradeLevel = 0;
    elseif preProcessed.settings.gradeLevel == '1'
        gradeLevel = 1;
    elseif preProcessed.settings.gradeLevel == '2'
        gradeLevel = 2;
    elseif preProcessed.settings.gradeLevel == '3'
        gradeLevel = 3;
    elseif preProcessed.settings.gradeLevel == '4'
        gradeLevel = 4;
    elseif preProcessed.settings.gradeLevel == '5'
        gradeLevel = 5;
    elseif preProcessed.settings.gradeLevel == 'u'
        gradeLevel = 14;
    end
    
    trialIndex = transpose(1:21);
    
    violationSummary(folder,1) = preProcessed.settings.subjID;       % 1st column
    violationSummary(folder,2) = gender;                             % 2nd column
    violationSummary(folder,3) = gradeLevel;                         % 3rd column
    violationSummary(folder,4) = violation.treat1ICETotal;              % 4th column
    violationSummary(folder,5) = violation.catch1;                   % 5th column
    violationSummary(folder,6) = violation.discrepancyRvlXpl.treat1Average; % 6th column
    violationSummary(folder,7) = violation.triplet.treat1Total;
    violationSummary(folder,8) = violation.treat1ICRTotal;
    violationSummary(folder,19) = violation.partyTotal;
    violationSummary(folder,20) = violation.choiceReversals.treat1;
    violationSummary(folder,21) = violation.choiceRemovals.treat1;
    violationSummary(folder,101) = violation.treat1ICETotalafterReversals;
    
    violationSummary(folder,9) = violation.treat2ICETotal;
    violationSummary(folder,10) = violation.catch2;
    violationSummary(folder,11) = violation.discrepancyRvlXpl.treat2Average;
    violationSummary(folder,12) = violation.triplet.treat2Total;
    violationSummary(folder,13) = violation.treat2ICRTotal;
    violationSummary(folder,22) = violation.choiceReversals.treat2;
    violationSummary(folder,23) = violation.choiceRemovals.treat2;
    violationSummary(folder,27) = mean(preProcessed.behavioral.treat2.secs(2:21));
    violationSummary(folder,32) = heuristic.totals.treat2.probmax;
    violationSummary(folder,33) = heuristic.totals.treat2.amountmax;
    violationSummary(folder,34) = heuristic.totals.treat2.expectmax;
    violationSummary(folder,35) = heuristic.totals.treat2.probmaxAmountmax;
    violationSummary(folder,36) = heuristic.totals.treat2.amountmaxProbmax;
    violationSummary(folder,37) = heuristic.totals.treat2.expectmaxAmountmax;
    violationSummary(folder,38) = heuristic.totals.treat2.expectmaxProbmax;
    violationSummary(folder,47) = median(preProcessed.behavioral.treat2.secs(2:21));
    violationSummary(folder,54) = max(preProcessed.behavioral.treat2.tally.total) - ...
        min(preProcessed.behavioral.treat2.tally.total);
    violationSummary(folder,57) = 21 - nnz(preProcessed.treat2.choices(1:21)); % subtracts number of non-zero (left/right) choices from total number of choices to give number of indifferent choices
    violationSummary(folder,102) = violation.treat2ICETotalafterReversals;
    
    violationSummary(folder,14) = violation.treat3ICETotal;
    violationSummary(folder,15) = violation.catch3;
    violationSummary(folder,16) = violation.discrepancyRvlXpl.treat3Average;
    violationSummary(folder,17) = violation.triplet.treat3Total;
    violationSummary(folder,18) = violation.treat3ICRTotal;
    violationSummary(folder,24) = violation.choiceReversals.treat3;
    violationSummary(folder,25) = violation.choiceRemovals.treat3;
    violationSummary(folder,28) = mean(preProcessed.behavioral.treat3.secs(2:21));
    violationSummary(folder,39) = heuristic.totals.treat3.memax;
    violationSummary(folder,40) = heuristic.totals.treat3.othermax;
    violationSummary(folder,41) = heuristic.totals.treat3.summax;
    violationSummary(folder,42) = heuristic.totals.treat3.memaxOthermax;
    violationSummary(folder,43) = heuristic.totals.treat3.memaxOthermin;
    violationSummary(folder,44) = heuristic.totals.treat3.summaxMemax;
    violationSummary(folder,45) = heuristic.totals.treat3.summaxOthermax;
    violationSummary(folder,48) = median(preProcessed.behavioral.treat3.secs(2:21));
    violationSummary(folder,55) = max(preProcessed.behavioral.treat3.tally.total) - ...vio
        min(preProcessed.behavioral.treat3.tally.total);
    violationSummary(folder,58) = 21 - nnz(preProcessed.treat3.choices(1:21));
    violationSummary(folder,100) = preProcessed.treat2.choices(12);
    violationSummary(folder,103) = violation.treat3ICETotalafterReversals;
    violationSummary(folder,104) = heuristic.totals.treat2.expectmaxIndiff;
    
    violationSummary(folder,26) = mean(preProcessed.behavioral.treat1.secs(2:21));
    violationSummary(folder,29) = violation.party(1,1) + violation.party(1,2) + violation.party(1,4);
    violationSummary(folder,30) = violation.party(1,3) + violation.party(1,6);
    violationSummary(folder,31) = violation.party(1,5) + violation.party(1,7);
    violationSummary(folder,46) = median(preProcessed.behavioral.treat1.secs(2:21));
    violationSummary(folder,53) = max(preProcessed.behavioral.treat1.tally.total) - ...
        min(preProcessed.behavioral.treat1.tally.total);
    violationSummary(folder,56) = 21 - nnz(preProcessed.treat1.choices(1:21));
    
    
    % list subject's favorite for each treatment (elicited then revealed)
    % elicited for treat 1
    violationSummary(folder,62:61+length(preProcessed.behavioral.rank1.key(1,find(preProcessed.behavioral.rank1.key(2,:)==1)))) = preProcessed.behavioral.rank1.key(1,find(preProcessed.behavioral.rank1.key(2,:)==1));
    % revealed for treat 1
    violationSummary(folder,69:68+length(find(violation.rankDistribution.treat1==1))) = find(violation.rankDistribution.treat1==1);
    % elicited for treat 2
    violationSummary(folder,76:75+length(preProcessed.behavioral.rank2.key(1,find(preProcessed.behavioral.rank2.key(2,:)==1)))) = preProcessed.behavioral.rank2.key(1,find(preProcessed.behavioral.rank2.key(2,:)==1));
    % revealed for treat 2
    violationSummary(folder,83:82+length(find(violation.rankDistribution.treat2==1))) = find(violation.rankDistribution.treat2==1);
    % elicited for treat 3
    violationSummary(folder,90:89+length(preProcessed.behavioral.rank3.key(1,find(preProcessed.behavioral.rank3.key(2,:)==1)))) = preProcessed.behavioral.rank3.key(1,find(preProcessed.behavioral.rank3.key(2,:)==1));
    % revealed for treat 3
    violationSummary(folder,97:96+length(find(violation.rankDistribution.treat3==1))) = find(violation.rankDistribution.treat3==1);
    
    revealedMostFavorite.treat2(folder,1:length(violation.revealedMostFavorite.treat2)) = violation.revealedMostFavorite.treat2;
    revealedLeastFavorite.treat2(folder,1:length(violation.revealedLeastFavorite.treat2)) = violation.revealedLeastFavorite.treat2;
    revealedMostFavorite.treat3(folder,1:length(violation.revealedMostFavorite.treat3)) = violation.revealedMostFavorite.treat3;
    revealedLeastFavorite.treat3(folder,1:length(violation.revealedLeastFavorite.treat3)) = violation.revealedLeastFavorite.treat3;
    
    elicitedRankDistribution.treat1(folder,1) = preProcessed.settings.subjID;
    elicitedRankDistribution.treat1(folder,2) = gender;
    elicitedRankDistribution.treat1(folder,3) = gradeLevel;
    elicitedRankDistribution.treat1(folder,4:10) = violation.elicitedRankDistribution.treat1;
    elicitedRankDistribution.treat2(folder,1) = preProcessed.settings.subjID;
    elicitedRankDistribution.treat2(folder,2) = gender;
    elicitedRankDistribution.treat2(folder,3) = gradeLevel;
    elicitedRankDistribution.treat2(folder,4:10) = violation.elicitedRankDistribution.treat2;
    elicitedRankDistribution.treat3(folder,1) = preProcessed.settings.subjID;
    elicitedRankDistribution.treat3(folder,2) = gender;
    elicitedRankDistribution.treat3(folder,3) = gradeLevel;
    elicitedRankDistribution.treat3(folder,4:10) = violation.elicitedRankDistribution.treat3;
    
    rankDistribution.treat1.bySubject(folder,1) = preProcessed.settings.subjID;
    rankDistribution.treat1.bySubject(folder,2) = gender;
    rankDistribution.treat1.bySubject(folder,3) = gradeLevel;
    rankDistribution.treat1.bySubject(folder,4) = violation.rankDistribution.treat1(1);
    rankDistribution.treat1.bySubject(folder,5) = violation.rankDistribution.treat1(2);
    rankDistribution.treat1.bySubject(folder,6) = violation.rankDistribution.treat1(3);
    rankDistribution.treat1.bySubject(folder,7) = violation.rankDistribution.treat1(4);
    rankDistribution.treat1.bySubject(folder,8) = violation.rankDistribution.treat1(5);
    rankDistribution.treat1.bySubject(folder,9) = violation.rankDistribution.treat1(6);
    rankDistribution.treat1.bySubject(folder,10) = violation.rankDistribution.treat1(7);
    rankDistribution.treat1.bySubject(folder,11) = violation.rankDistribution.treat1matchedPermuteRow(1);
    rankDistribution.treat1.bySubject(folder,12) = violation.rankDistribution.treat1matchedRowDistance;
    rankDistribution.treat1.bySubject(folder,13) = length(violation.rankDistribution.treat1matchedPermuteRow);
    
    if length(violation.rankDistribution.treat1matchedPermuteRow) < 100
        rankDistribution.treat1.byPermuteRow(violation.rankDistribution.treat1matchedPermuteRow,8) = ...
            rankDistribution.treat1.byPermuteRow(violation.rankDistribution.treat1matchedPermuteRow,8) + 1/length(violation.rankDistribution.treat1matchedPermuteRow);
    end
    
    
    rankDistribution.treat2.bySubject(folder,1) = preProcessed.settings.subjID;
    rankDistribution.treat2.bySubject(folder,2) = gender;
    rankDistribution.treat2.bySubject(folder,3) = gradeLevel;
    rankDistribution.treat2.bySubject(folder,4) = violation.rankDistribution.treat2(1);
    rankDistribution.treat2.bySubject(folder,5) = violation.rankDistribution.treat2(2);
    rankDistribution.treat2.bySubject(folder,6) = violation.rankDistribution.treat2(3);
    rankDistribution.treat2.bySubject(folder,7) = violation.rankDistribution.treat2(4);
    rankDistribution.treat2.bySubject(folder,8) = violation.rankDistribution.treat2(5);
    rankDistribution.treat2.bySubject(folder,9) = violation.rankDistribution.treat2(6);
    rankDistribution.treat2.bySubject(folder,10) = violation.rankDistribution.treat2(7);
    rankDistribution.treat2.bySubject(folder,11) = violation.rankDistribution.treat2matchedPermuteRow(1);
    rankDistribution.treat2.bySubject(folder,12) = violation.rankDistribution.treat2matchedRowDistance;
    rankDistribution.treat2.bySubject(folder,13) = length(violation.rankDistribution.treat2matchedPermuteRow);
    
    if length(violation.rankDistribution.treat2matchedPermuteRow) < 100
        rankDistribution.treat2.byPermuteRow(violation.rankDistribution.treat2matchedPermuteRow,8) = ...
            rankDistribution.treat2.byPermuteRow(violation.rankDistribution.treat2matchedPermuteRow,8) + 1/length(violation.rankDistribution.treat2matchedPermuteRow);
    end
    
    
    rankDistribution.treat3.bySubject(folder,1) = preProcessed.settings.subjID;
    rankDistribution.treat3.bySubject(folder,2) = gender;
    rankDistribution.treat3.bySubject(folder,3) = gradeLevel;
    rankDistribution.treat3.bySubject(folder,4) = violation.rankDistribution.treat3(1);
    rankDistribution.treat3.bySubject(folder,5) = violation.rankDistribution.treat3(2);
    rankDistribution.treat3.bySubject(folder,6) = violation.rankDistribution.treat3(3);
    rankDistribution.treat3.bySubject(folder,7) = violation.rankDistribution.treat3(4);
    rankDistribution.treat3.bySubject(folder,8) = violation.rankDistribution.treat3(5);
    rankDistribution.treat3.bySubject(folder,9) = violation.rankDistribution.treat3(6);
    rankDistribution.treat3.bySubject(folder,10) = violation.rankDistribution.treat3(7);
    rankDistribution.treat3.bySubject(folder,11) = violation.rankDistribution.treat3matchedPermuteRow(1);
    rankDistribution.treat3.bySubject(folder,12) = violation.rankDistribution.treat3matchedRowDistance;
    rankDistribution.treat3.bySubject(folder,13) = length(violation.rankDistribution.treat3matchedPermuteRow);
    
    if length(violation.rankDistribution.treat3matchedPermuteRow) < 100
        rankDistribution.treat3.byPermuteRow(violation.rankDistribution.treat3matchedPermuteRow,8) = ...
            rankDistribution.treat3.byPermuteRow(violation.rankDistribution.treat3matchedPermuteRow,8) + 1/length(violation.rankDistribution.treat3matchedPermuteRow);
    end
    
    
    violationSummaryRow = violationSummary(folder,:) + 0;
    violationSummaryRow2 = violationSummary(folder,:) + 0;
    violationSummaryRow(violationSummaryRow < 21) = 0;
    violationSummaryRow2(violationSummaryRow2 < 19) = 0;
    startingPoint = 63*(folder-3) + 1;
    endingPoint = 63*(folder-3) + 63;
    treat1Start = startingPoint;
    treat1End = startingPoint + 20;
    treat2Start = treat1End + 1;
    treat2End = treat2Start + 20;
    treat3Start = treat2End + 1;
    treat3End = treat3Start + 20;
    violationRxnTimeListed(startingPoint:endingPoint,1) = preProcessed.settings.subjID;
    violationRxnTimeListed(startingPoint:endingPoint,2) = gender;
    violationRxnTimeListed(startingPoint:endingPoint,3) = gradeLevel;
    violationICEmatrixListed(startingPoint:endingPoint,1) = preProcessed.settings.subjID;
    violationICEmatrixListed(startingPoint:endingPoint,6) = gender;
    violationICEmatrixListed(startingPoint:endingPoint,7) = gradeLevel;
    
    % For Goods
    rankingValue = preProcessed.behavioral.rank1.key(2,:);
    rankingOption = preProcessed.behavioral.rank1.key(1,:);
    rankingOptionList = nchoosek(rankingOption,2);
    for i = 1:length(rankingOptionList)
        rankingOptionListSorted(i,1:2) = sort(rankingOptionList(i,1:2),2);
    end
    violationICEmatrixListed(treat1Start:treat1End,2:3) = nchoosek(rankingValue,2);
    violationICEmatrixListed(treat1Start:treat1End,4) = 1;
    violationICEmatrixListed(treat1Start:treat1End,10:11) = nchoosek(rankingOption,2); % fill columns 10 and 11 with option Numbers
    for trial = 1:21
        indexFirst = find(preProcessed.settings.treat1.Set(trial,1) == rankingOptionListSorted(:,1));
        indexSecond = find(preProcessed.settings.treat1.Set(trial,2) == rankingOptionListSorted(indexFirst,2));
        index = indexFirst(indexSecond);
        violationICEmatrixListed(treat1Start + index - 1, 5) = violation.treat1ICE(trial);
        violationICEmatrixListed(treat1Start + index - 1, 8) = preProcessed.treat1.responseTimes(trial);
        violationICEmatrixListed(treat1Start + index - 1, 9) = preProcessed.treat1.choices(trial);
    end
    violationRxnTimeListed(treat1Start:treat1End,4) = 1;
    violationRxnTimeListed(treat1Start:treat1End,5) = violation.treat1ICR(:,1);
    violationRxnTimeListed(treat1Start:treat1End,6) = violation.treat1TV(:,1);
    violationRxnTimeListed(treat1Start:treat1End,7) = transpose(preProcessed.treat1.responseTimes(1:21));
    violationRxnTimeListed(treat1Start:treat1End,8) = transpose(preProcessed.treat1.choices(1:21));
    violationRxnTimeListed(treat1Start:treat1End,9:10) = 0;
    violationRxnTimeListed(treat1Start:treat1End,11) = trialIndex;
    matrixElicited.treat1 = matrixElicited.treat1 + violation.matrixElicited.treat1(3:9,3:9);
    matrixRevealed.treat1 = matrixRevealed.treat1 + violation.matrixRevealed.treat1(3:9,3:9);
    
    % For Risk
    rankingValue = preProcessed.behavioral.rank2.key(2,:);
    rankingOption = preProcessed.behavioral.rank2.key(1,:);
    rankingOptionList = nchoosek(rankingOption,2);
    for i = 1:length(rankingOptionList)
        rankingOptionListSorted(i,1:2) = sort(rankingOptionList(i,1:2),2);
    end
    violationICEmatrixListed(treat2Start:treat2End,2:3) = nchoosek(rankingValue,2);
    violationICEmatrixListed(treat2Start:treat2End,4) = 2;
    violationICEmatrixListed(treat2Start:treat2End,10:11) = nchoosek(rankingOption,2); % fill columns 10 and 11 with option Numbers
    for trial = 1:21
        indexFirst = find(preProcessed.settings.treat1.Set(trial,1) == rankingOptionListSorted(:,1));
        indexSecond = find(preProcessed.settings.treat1.Set(trial,2) == rankingOptionListSorted(indexFirst,2));
        index = indexFirst(indexSecond);
        violationICEmatrixListed(treat2Start + index - 1, 5) = violation.treat2ICE(trial);
        violationICEmatrixListed(treat2Start + index - 1, 8) = preProcessed.treat2.responseTimes(trial);
        violationICEmatrixListed(treat2Start + index - 1, 9) = preProcessed.treat2.choices(trial);
    end
    
    violationRxnTimeListed(treat2Start:treat2End,4) = 2;
    violationRxnTimeListed(treat2Start:treat2End,5) = violation.treat2ICR(:,1);
    violationRxnTimeListed(treat2Start:treat2End,6) = violation.treat2TV(:,1);
    violationRxnTimeListed(treat2Start:treat2End,7) = transpose(preProcessed.treat2.responseTimes(1:21));
    violationRxnTimeListed(treat2Start:treat2End,8) = transpose(preProcessed.treat2.choices(1:21));
    if sum(violationSummaryRow(32:38)) > 0
        violationRxnTimeListed(treat2Start:treat2End,9) = 1;
        violationSummary(folder,49) = 1;
    elseif sum(violationSummaryRow(32:38)) == 0
        violationRxnTimeListed(treat2Start:treat2End,9) = 0;
        violationSummary(folder,49) = 0;
    end
    if sum(violationSummaryRow2(32:38)) > 0
        violationRxnTimeListed(treat2Start:treat2End,10) = 1;
        violationSummary(folder,50) = 1;
    elseif sum(violationSummaryRow2(32:38)) == 0
        violationRxnTimeListed(treat2Start:treat2End,10) = 0;
        violationSummary(folder,50) = 0;
    end
    violationRxnTimeListed(treat2Start:treat2End,11) = trialIndex;
    matrixElicited.treat2 = matrixElicited.treat2 + violation.matrixElicited.treat2(3:9,3:9);
    matrixRevealed.treat2 = matrixRevealed.treat2 + violation.matrixRevealed.treat2(3:9,3:9);
    
    % For Social
    rankingValue = preProcessed.behavioral.rank3.key(2,:);
    rankingOption = preProcessed.behavioral.rank3.key(1,:);
    rankingOptionList = nchoosek(rankingOption,2);
    for i = 1:length(rankingOptionList)
        rankingOptionListSorted(i,1:2) = sort(rankingOptionList(i,1:2),2);
    end
    violationICEmatrixListed(treat3Start:treat3End,2:3) = nchoosek(rankingValue,2);
    violationICEmatrixListed(treat3Start:treat3End,4) = 3;
    violationICEmatrixListed(treat3Start:treat3End,10:11) = nchoosek(rankingOption,2); % fill columns 10 and 11 with option Numbers
    for trial = 1:21
        indexFirst = find(preProcessed.settings.treat1.Set(trial,1) == rankingOptionListSorted(:,1));
        indexSecond = find(preProcessed.settings.treat1.Set(trial,2) == rankingOptionListSorted(indexFirst,2));
        index = indexFirst(indexSecond);
        violationICEmatrixListed(treat3Start + index - 1, 5) = violation.treat3ICE(trial);
        violationICEmatrixListed(treat3Start + index - 1, 8) = preProcessed.treat3.responseTimes(trial);
        violationICEmatrixListed(treat3Start + index - 1, 9) = preProcessed.treat3.choices(trial);
    end
    
    violationRxnTimeListed(treat3Start:treat3End,4) = 3;
    violationRxnTimeListed(treat3Start:treat3End,5) = violation.treat3ICR(:,1);
    violationRxnTimeListed(treat3Start:treat3End,6) = violation.treat3TV(:,1);
    violationRxnTimeListed(treat3Start:treat3End,7) = transpose(preProcessed.treat3.responseTimes(1:21));
    violationRxnTimeListed(treat3Start:treat3End,8) = transpose(preProcessed.treat3.choices(1:21));
    if sum(violationSummaryRow(39:45)) > 0
        violationRxnTimeListed(treat3Start:treat3End,9) = 1;
        violationSummary(folder,51) = 1;
    elseif sum(violationSummaryRow(39:45)) == 0
        violationRxnTimeListed(treat3Start:treat3End,9) = 0;
        violationSummary(folder,51) = 0;
    end
    if sum(violationSummaryRow2(39:45)) > 0
        violationRxnTimeListed(treat3Start:treat3End,10) = 1;
        violationSummary(folder,52) = 1;
    elseif sum(violationSummaryRow2(39:45)) == 0
        violationRxnTimeListed(treat3Start:treat3End,10) = 0;
        violationSummary(folder,52) = 0;
    end
    violationRxnTimeListed(treat3Start:treat3End,11) = trialIndex;
    matrixElicited.treat3 = matrixElicited.treat3 + violation.matrixElicited.treat3(3:9,3:9);
    matrixRevealed.treat3 = matrixRevealed.treat3 + violation.matrixRevealed.treat3(3:9,3:9);
    
    
    % Matrices with averages - will then be used in R to construct heat
    % maps for violation and reaction time of each pair of items (based on
    % their elicited and revealed rankings)
    
    % For treatment 1
    heatmapMatrix.ice.treat1(:,3) = heatmapMatrix.ice.treat1(:,3) + violation.heatmapMatrix.treat1(:,3); % ICE violations and ICE ranking labels of options
    heatmapMatrix.iceAvgRxn.treat1(:,3) = heatmapMatrix.iceAvgRxn.treat1(:,3) + violation.heatmapMatrix.treat1(:,4); % reaction times and ICE ranking labels of options
    heatmapMatrix.icr.treat1(:,3) = heatmapMatrix.icr.treat1(:,3) + violation.heatmapMatrix.treat1(:,5);  % ICR violations and ICR ranking labels of options
    heatmapMatrix.icrAvgRxn.treat1(:,3) = heatmapMatrix.icrAvgRxn.treat1(:,3) + violation.heatmapMatrix.treat1(:,6); % reaction times and ICR ranking labels of options
    heatmapMatrix.iceICR.treat1(:,3) = heatmapMatrix.iceICR.treat1(:,3) + violation.heatmapMatrix.treat1(:,7); % ICR violations and ICE ranking labels of options
    heatmapMatrix.iceTV.treat1(:,3) = heatmapMatrix.iceTV.treat1(:,3) + violation.heatmapMatrix.treat1(:,8); % TV violations and ICE ranking labels of options
    heatmapMatrix.icrICE.treat1(:,3) = heatmapMatrix.icrICE.treat1(:,3) + violation.heatmapMatrix.treat1(:,9); % ICE violations and ICR ranking labels of options
    heatmapMatrix.icrTV.treat1(:,3) = heatmapMatrix.icrTV.treat1(:,3) + violation.heatmapMatrix.treat1(:,10); % TV violations and ICR ranking labels of options
    
    % For treatment 2
    heatmapMatrix.ice.treat2(:,3) = heatmapMatrix.ice.treat2(:,3) + violation.heatmapMatrix.treat2(:,3);
    heatmapMatrix.iceAvgRxn.treat2(:,3) = heatmapMatrix.iceAvgRxn.treat2(:,3) + violation.heatmapMatrix.treat2(:,4);
    heatmapMatrix.icr.treat2(:,3) = heatmapMatrix.icr.treat2(:,3) + violation.heatmapMatrix.treat2(:,5);
    heatmapMatrix.icrAvgRxn.treat2(:,3) = heatmapMatrix.icrAvgRxn.treat2(:,3) + violation.heatmapMatrix.treat2(:,6);
    heatmapMatrix.iceICR.treat2(:,3) = heatmapMatrix.iceICR.treat2(:,3) + violation.heatmapMatrix.treat2(:,7); % ICR violations and ICE ranking labels of options
    heatmapMatrix.iceTV.treat2(:,3) = heatmapMatrix.iceTV.treat2(:,3) + violation.heatmapMatrix.treat2(:,8); % TV violations and ICE ranking labels of options
    heatmapMatrix.icrICE.treat2(:,3) = heatmapMatrix.icrICE.treat2(:,3) + violation.heatmapMatrix.treat2(:,9); % ICE violations and ICR ranking labels of options
    heatmapMatrix.icrTV.treat2(:,3) = heatmapMatrix.icrTV.treat2(:,3) + violation.heatmapMatrix.treat2(:,10); % TV violations and ICR ranking labels of options
    
    % For treatment 3
    heatmapMatrix.ice.treat3(:,3) = heatmapMatrix.ice.treat3(:,3) + violation.heatmapMatrix.treat3(:,3);
    heatmapMatrix.iceAvgRxn.treat3(:,3) = heatmapMatrix.iceAvgRxn.treat3(:,3) + violation.heatmapMatrix.treat3(:,4);
    heatmapMatrix.icr.treat3(:,3) = heatmapMatrix.icr.treat3(:,3) + violation.heatmapMatrix.treat3(:,5);
    heatmapMatrix.icrAvgRxn.treat3(:,3) = heatmapMatrix.icrAvgRxn.treat3(:,3) + violation.heatmapMatrix.treat3(:,6);
    heatmapMatrix.iceICR.treat3(:,3) = heatmapMatrix.iceICR.treat3(:,3) + violation.heatmapMatrix.treat3(:,7); % ICR violations and ICE ranking labels of options
    heatmapMatrix.iceTV.treat3(:,3) = heatmapMatrix.iceTV.treat3(:,3) + violation.heatmapMatrix.treat3(:,8); % TV violations and ICE ranking labels of options
    heatmapMatrix.icrICE.treat3(:,3) = heatmapMatrix.icrICE.treat3(:,3) + violation.heatmapMatrix.treat3(:,9); % ICE violations and ICR ranking labels of options
    heatmapMatrix.icrTV.treat3(:,3) = heatmapMatrix.icrTV.treat3(:,3) + violation.heatmapMatrix.treat3(:,10); % TV violations and ICR ranking labels of options
    
    
    % Indifferences and violations, by triplet (for each subject and
    % treatment)
    tripletSummary(((folder-3)*35)+1:(((folder-3)*35)+35),1) = preProcessed.settings.subjID;       % 1st column
    tripletSummary(((folder-3)*35)+1:(((folder-3)*35)+35),2) = gender;                             % 2nd column
    tripletSummary(((folder-3)*35)+1:(((folder-3)*35)+35),3) = gradeLevel;                         % 3rd column
    tripletSummary(((folder-3)*35)+1:(((folder-3)*35)+35),4) = violation.indifferentChoices.treat1(1:35,1);
    tripletSummary(((folder-3)*35)+1:(((folder-3)*35)+35),5) = violation.triplet.treat1(1:35,1);
    tripletSummary(((folder-3)*35)+1:(((folder-3)*35)+35),6) = violation.indifferentChoices.treat2(1:35,1);
    tripletSummary(((folder-3)*35)+1:(((folder-3)*35)+35),7) = violation.triplet.treat2(1:35,1);
    tripletSummary(((folder-3)*35)+1:(((folder-3)*35)+35),8) = violation.indifferentChoices.treat3(1:35,1);
    tripletSummary(((folder-3)*35)+1:(((folder-3)*35)+35),9) = violation.triplet.treat3(1:35,1);
    
    
    % Indifferences and violations, summed for each subject (for each
    % treatment)
    TVandIndiffSummary.treat1(folder,1) = preProcessed.settings.subjID;
    TVandIndiffSummary.treat1(folder,2) = gender;
    TVandIndiffSummary.treat1(folder,3) = gradeLevel;
    TVandIndiffSummary.treat1(folder,4:7) = violation.TVandIndiffTotal.treat1(1,1:4);
    
    TVandIndiffSummary.treat2(folder,1) = preProcessed.settings.subjID;
    TVandIndiffSummary.treat2(folder,2) = gender;
    TVandIndiffSummary.treat2(folder,3) = gradeLevel;
    TVandIndiffSummary.treat2(folder,4:7) = violation.TVandIndiffTotal.treat2(1,1:4);
    
    
    TVandIndiffSummary.treat3(folder,1) = preProcessed.settings.subjID;
    TVandIndiffSummary.treat3(folder,2) = gender;
    TVandIndiffSummary.treat3(folder,3) = gradeLevel;
    TVandIndiffSummary.treat3(folder,4:7) = violation.TVandIndiffTotal.treat3(1,1:4);
    
    
    cd('../');
end

% Divide third column of heat map prep matrices by number of subjects who
% completed that treatment (51 for all three treatments)
heatmapMatrix.ice.treat1(:,3) = heatmapMatrix.ice.treat1(:,3)/51;
heatmapMatrix.iceAvgRxn.treat1(:,3) = heatmapMatrix.iceAvgRxn.treat1(:,3)/51;
heatmapMatrix.icr.treat1(:,3) = heatmapMatrix.icr.treat1(:,3)/51;
heatmapMatrix.icrAvgRxn.treat1(:,3) = heatmapMatrix.icrAvgRxn.treat1(:,3)/51;
heatmapMatrix.iceICR.treat1(:,3) = heatmapMatrix.iceICR.treat1(:,3)/51;
heatmapMatrix.iceTV.treat1(:,3) = heatmapMatrix.iceTV.treat1(:,3)/51;
heatmapMatrix.icrICE.treat1(:,3) = heatmapMatrix.icrICE.treat1(:,3)/51;
heatmapMatrix.icrTV.treat1(:,3) = heatmapMatrix.icrTV.treat1(:,3)/51;

heatmapMatrix.ice.treat2(:,3) = heatmapMatrix.ice.treat2(:,3)/51;
heatmapMatrix.iceAvgRxn.treat2(:,3) = heatmapMatrix.iceAvgRxn.treat2(:,3)/51;
heatmapMatrix.icr.treat2(:,3) = heatmapMatrix.icr.treat2(:,3)/51;
heatmapMatrix.icrAvgRxn.treat2(:,3) = heatmapMatrix.icrAvgRxn.treat2(:,3)/51;
heatmapMatrix.iceICR.treat2(:,3) = heatmapMatrix.iceICR.treat2(:,3)/51;
heatmapMatrix.iceTV.treat2(:,3) = heatmapMatrix.iceTV.treat2(:,3)/51;
heatmapMatrix.icrICE.treat2(:,3) = heatmapMatrix.icrICE.treat2(:,3)/51;
heatmapMatrix.icrTV.treat2(:,3) = heatmapMatrix.icrTV.treat2(:,3)/51;


heatmapMatrix.ice.treat3(:,3) = heatmapMatrix.ice.treat3(:,3)/51;
heatmapMatrix.iceAvgRxn.treat3(:,3) = heatmapMatrix.iceAvgRxn.treat3(:,3)/51;
heatmapMatrix.icr.treat3(:,3) = heatmapMatrix.icr.treat3(:,3)/51;
heatmapMatrix.icrAvgRxn.treat3(:,3) = heatmapMatrix.icrAvgRxn.treat3(:,3)/51;
heatmapMatrix.iceICR.treat3(:,3) = heatmapMatrix.iceICR.treat3(:,3)/51;
heatmapMatrix.iceTV.treat3(:,3) = heatmapMatrix.iceTV.treat3(:,3)/51;
heatmapMatrix.icrICE.treat3(:,3) = heatmapMatrix.icrICE.treat3(:,3)/51;
heatmapMatrix.icrTV.treat3(:,3) = heatmapMatrix.icrTV.treat3(:,3)/51;

save('violationSummary.mat','violationSummary');
save('violationICEmatrixListed.mat','violationICEmatrixListed');
save('violationRxnTimeListed.mat','violationRxnTimeListed');
save('rankDistribution.mat','rankDistribution');
save('elicitedRankDistribution.mat','elicitedRankDistribution');
save('matrixElicited.mat','matrixElicited');
save('matrixRevealed.mat','matrixRevealed');
save('heatmapMatrix.mat','heatmapMatrix');
save('tripletSummary.mat','tripletSummary');
save('revealedMostFavorite.mat','revealedMostFavorite');
save('revealedLeastFavorite.mat','revealedLeastFavorite');
save('TVandIndiffSummary.mat','TVandIndiffSummary');

clearvars -except type
cd('../');
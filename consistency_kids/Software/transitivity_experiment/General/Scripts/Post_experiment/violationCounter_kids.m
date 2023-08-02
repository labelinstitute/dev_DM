% Author: Niree Kodaverdian

preProcessedFolder = '/Users/nireekodaverdian/Desktop/transitivity_experiment/preProcessed_kids/'; % define path of folder holding pre-processed files
generalFolder = '/Users/nireekodaverdian/Desktop/transitivity_experiment/General/'; % define path of 'General' folder

cd(preProcessedFolder); % change directory to this folder
subjects = dir;

% type of violation counting (half or only full point violations)
type = 0.5;

% type = 1;

for folder = 1:length(subjects)
    if ismember((subjects(folder).name(1)), {'.','v','n','r','m','h','e','t','T'});
        continue
    end
    
    folder
    cd(subjects(folder).name);
    load('preProcessed.mat');
    load('violations.mat');
    
    choiceReversals = violation.choiceReversals;
    closestConsistentChoices = violation.closestConsistentChoices;
    choiceRemovals = violation.choiceRemovals;
    remainingConsistentChoices = violation.closestConsistentChoices;
    
    %% Count triplet violations (TV) across choices (elicited rankings do not come into consideration here)
    
    cd(generalFolder);
    cd('Sets');
    load('triplets.mat');  % load the 'triplets' file which includes all possible triplets (35 of them) for the 7 options
    load('tripletSetIndex.mat');
    load('quadruplets.mat');
    load('quadrupletSetIndex.mat');
    cd('../../');
    cd(preProcessedFolder);
    cd(subjects(folder).name);
    
    index1triplets = zeros(length(triplets),1); % vector of 35 zeros. made so that 'index1triplets' does not change size with each loop and in turn, produce annoying squiggly red lines under the word in the loop
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
    
    % For Treatment 1
    for i = 1:length(triplets)
        choice1(i) = preProcessed.treat1.choices(index1triplets(i,1));
        choice2(i) = preProcessed.treat1.choices(index2triplets(i,1));
        choice3(i) = preProcessed.treat1.choices(index3triplets(i,1));
    end
    
    [violationTV,violationTotal,indifference,indifferenceTotal,TVandIndiff,TVandIndiffTotal] = violationTVcounter(type,choice1,choice2,choice3);
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
    
    
    % For Treatment 2
    if folder ~= 46 && folder ~= 53
        for i = 1:length(triplets)
            choice1(i) = preProcessed.treat2.choices(index1triplets(i,1));
            choice2(i) = preProcessed.treat2.choices(index2triplets(i,1));
            choice3(i) = preProcessed.treat2.choices(index3triplets(i,1));
        end
        
        [violationTV,violationTotal,indifference,indifferenceTotal,TVandIndiff,TVandIndiffTotal] = violationTVcounter(type,choice1,choice2,choice3);
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
    end
    
    
    
    % For Treatment 3
    if folder ~= 46
        for i = 1:length(triplets)
            choice1(i) = preProcessed.treat3.choices(index1triplets(i,1));
            choice2(i) = preProcessed.treat3.choices(index2triplets(i,1));
            choice3(i) = preProcessed.treat3.choices(index3triplets(i,1));
        end
        [violationTV,violationTotal,indifference,indifferenceTotal,TVandIndiff,TVandIndiffTotal] = violationTVcounter(type,choice1,choice2,choice3);
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
    end
    
    index1quadruplets = zeros(length(quadruplets),1); % vector of 35 zeros. made so that 'index1' does not change size with each loop and in turn, produce annoying squiggly red lines under the word in the loop
    index2quadruplets = zeros(length(quadruplets),1); % same as above
    index3quadruplets = zeros(length(quadruplets),1); % same as above
    index4quadruplets = zeros(length(quadruplets),1); % same as above
    
    for i = 1:length(quadruplets)
        firstQuadruplets = quadruplets(i,1); % first element of a given row i
        secondQuadruplets = quadruplets(i,2); % second element of a given row i
        thirdQuadruplets = quadruplets(i,3); % third element of a given row i
        fourthQuadruplets = quadruplets(i,4); % fourth element of a given row i
        
        index1FirstQuadruplets = find(preProcessed.settings.treat1.Set(:,1) == firstQuadruplets);
        index1SecondQuadruplets = find(preProcessed.settings.treat1.Set(index1FirstQuadruplets,2) == secondQuadruplets); % use treat1.Set for all treatments, since same order across treatments
        index1quadruplets(i,1) = index1FirstQuadruplets(index1SecondQuadruplets); % index1 corresponds to the trial number in which the first and second options (elements of the given 'quadruplets' row) are compared
        
        index2FirstQuadruplets = find(preProcessed.settings.treat1.Set(:,1) == secondQuadruplets);
        index2SecondQuadruplets = find(preProcessed.settings.treat1.Set(index2FirstQuadruplets,2) == thirdQuadruplets);
        index2quadruplets(i,1) = index2FirstQuadruplets(index2SecondQuadruplets); % index2 corresponds to the trial number in which the second and third options (elements of the given 'quadruplets' row) are compared
        
        index3FirstQuadruplets = find(preProcessed.settings.treat1.Set(:,1) == thirdQuadruplets);
        index3SecondQuadruplets = find(preProcessed.settings.treat1.Set(index3FirstQuadruplets,2) == fourthQuadruplets);
        index3quadruplets(i,1) = index3FirstQuadruplets(index3SecondQuadruplets); % index3 corresponds to the trial number in which the third and fourth options (elements of the given 'quadruplets' row) are compared
        
        index4FirstQuadruplets = find(preProcessed.settings.treat1.Set(:,1) == firstQuadruplets);
        index4SecondQuadruplets = find(preProcessed.settings.treat1.Set(index4FirstQuadruplets,2) == fourthQuadruplets);
        index4quadruplets(i,1) = index4FirstQuadruplets(index4SecondQuadruplets);
    end
    
    
    choices = preProcessed.treat1.choices;
    [quadViolation,quadTotal,quadViolationByTrial] = ...
        violationQuadrupletTVcounter(index1quadruplets,index2quadruplets,index3quadruplets,index4quadruplets,choices,quadruplets,quadrupletSetIndex);
    violation.quadruplet.treat1 = quadViolation;
    violation.quadruplet.treat1Total = quadTotal;
    violation.treat1TVquad = quadViolationByTrial;
    
    if folder ~= 46 && folder ~= 53
    choices = preProcessed.treat2.choices;
    [quadViolation,quadTotal,quadViolationByTrial] = ...
        violationQuadrupletTVcounter(index1quadruplets,index2quadruplets,index3quadruplets,index4quadruplets,choices,quadruplets,quadrupletSetIndex);
    violation.quadruplet.treat2 = quadViolation;
    violation.quadruplet.treat2Total = quadTotal;
    violation.treat2TVquad = quadViolationByTrial;
    end
    
    if folder ~= 46
    choices = preProcessed.treat3.choices;
    [quadViolation,quadTotal,quadViolationByTrial] = ...
        violationQuadrupletTVcounter(index1quadruplets,index2quadruplets,index3quadruplets,index4quadruplets,choices,quadruplets,quadrupletSetIndex);
    violation.quadruplet.treat3 = quadViolation;
    violation.quadruplet.treat3Total = quadTotal;
    violation.treat3TVquad = quadViolationByTrial;
    end
    
    %% Detect use of heuristics (lexicographic and otherwise) for Treatment 2 and Treatment 3
    
    % For Treatment 2
    if folder ~= 46 && folder ~= 53
        heuristic.nolexico.treat2.probmax = zeros(21,1); % non-lexicographic heuristic of maximizing probability
        for i = 1:21
            probLeftOption = preProcessed.settings.treat2.Set(1,1,i);
            probRightOption = preProcessed.settings.treat2.Set(2,1,i);
            choice = preProcessed.treat2.choices(i);
            if (probLeftOption > probRightOption) && (choice == 1)
                heuristic.nolexico.treat2.probmax(i) = 1;
            elseif (probLeftOption < probRightOption) && (choice == 2)
                heuristic.nolexico.treat2.probmax(i) = 1;
            elseif (probLeftOption == probRightOption) && (choice == 0)
                heuristic.nolexico.treat2.probmax(i) = 1;
            else
                heuristic.nolexico.treat2.probmax(i) = 0;
            end
        end
        heuristic.totals.treat2.probmax = sum(heuristic.nolexico.treat2.probmax);
        
        heuristic.nolexico.treat2.amountmax = zeros(21,1); % non-lexicographic heuristic of maximizing amount
        for i = 1:21
            amtLeftOption = preProcessed.settings.treat2.Set(1,2,i);
            amtRightOption = preProcessed.settings.treat2.Set(2,2,i);
            choice = preProcessed.treat2.choices(i);
            if (amtLeftOption > amtRightOption) && (choice == 1)
                heuristic.nolexico.treat2.amountmax(i) = 1;
            elseif (amtLeftOption < amtRightOption) && (choice == 2)
                heuristic.nolexico.treat2.amountmax(i) = 1;
            elseif (amtLeftOption == amtRightOption) && (choice == 0)
                heuristic.nolexico.treat2.amountmax(i) = 1;
            else
                heuristic.nolexico.treat2.amountmax(i) = 0;
            end
        end
        heuristic.totals.treat2.amountmax = sum(heuristic.nolexico.treat2.amountmax);
        
        heuristic.nolexico.treat2.expectmax = zeros(21,1); % non-lexicographic heuristic of maximizing expected amount
        for i = 1:21
            probLeftOption = preProcessed.settings.treat2.Set(1,1,i);
            probRightOption = preProcessed.settings.treat2.Set(2,1,i);
            amtLeftOption = preProcessed.settings.treat2.Set(1,2,i);
            amtRightOption = preProcessed.settings.treat2.Set(2,2,i);
            expLeftOption = probLeftOption * amtLeftOption;
            expRightOption = probRightOption * amtRightOption;
            choice = preProcessed.treat2.choices(i);
            if (expLeftOption > expRightOption) && (choice == 1)
                heuristic.nolexico.treat2.expectmax(i) = 1;
            elseif (expLeftOption < expRightOption) && (choice == 2)
                heuristic.nolexico.treat2.expectmax(i) = 1;
            elseif (expLeftOption == expRightOption) && (choice == 0)
                heuristic.nolexico.treat2.expectmax(i) = 1;
            else
                heuristic.nolexico.treat2.expectmax(i) = 0;
            end
        end
        heuristic.totals.treat2.expectmax = sum(heuristic.nolexico.treat2.expectmax);
        
        heuristic.lexico.treat2.probmaxAmountmax = zeros(21,1); % lexicographic heuristic of maximizing probability then amount
        for i = 1:21
            probLeftOption = preProcessed.settings.treat2.Set(1,1,i);
            probRightOption = preProcessed.settings.treat2.Set(2,1,i);
            amtLeftOption = preProcessed.settings.treat2.Set(1,2,i);
            amtRightOption = preProcessed.settings.treat2.Set(2,2,i);
            choice = preProcessed.treat2.choices(i);
            if (probLeftOption > probRightOption) && (choice == 1)
                heuristic.lexico.treat2.probmaxAmountmax(i) = 1;
            elseif (probLeftOption < probRightOption) && (choice == 2)
                heuristic.lexico.treat2.probmaxAmountmax(i) = 1;
            elseif (probLeftOption == probRightOption) && (amtLeftOption > amtRightOption) && (choice == 1)
                heuristic.lexico.treat2.probmaxAmountmax(i) = 1;
            elseif (probLeftOption == probRightOption) && (amtLeftOption < amtRightOption) && (choice == 2)
                heuristic.lexico.treat2.probmaxAmountmax(i) = 1;
            else
                heuristic.lexico.treat2.probmaxAmountmax(i) = 0;
            end
        end
        heuristic.totals.treat2.probmaxAmountmax = sum(heuristic.lexico.treat2.probmaxAmountmax);
        
        heuristic.lexico.treat2.amountmaxProbmax = zeros(21,1); % lexicographic heuristic of maximizing amount then probability
        for i = 1:21
            probLeftOption = preProcessed.settings.treat2.Set(1,1,i);
            probRightOption = preProcessed.settings.treat2.Set(2,1,i);
            amtLeftOption = preProcessed.settings.treat2.Set(1,2,i);
            amtRightOption = preProcessed.settings.treat2.Set(2,2,i);
            choice = preProcessed.treat2.choices(i);
            if (amtLeftOption > amtRightOption) && (choice == 1)
                heuristic.lexico.treat2.amountmaxProbmax(i) = 1;
            elseif (amtLeftOption < amtRightOption) && (choice == 2)
                heuristic.lexico.treat2.amountmaxProbmax(i) = 1;
            elseif (amtLeftOption == amtRightOption) && (probLeftOption > probRightOption) && (choice == 1)
                heuristic.lexico.treat2.amountmaxProbmax(i) = 1;
            elseif (amtLeftOption == amtRightOption) && (probLeftOption < probRightOption) && (choice == 2)
                heuristic.lexico.treat2.amountmaxProbmax(i) = 1;
            else
                heuristic.lexico.treat2.amountmaxProbmax(i) = 0;
            end
        end
        heuristic.totals.treat2.amountmaxProbmax = sum(heuristic.lexico.treat2.amountmaxProbmax);
        
        heuristic.lexico.treat2.expectmaxAmountmax = zeros(21,1); % lexicographic heuristic of maximizing expected value then amount
        for i = 1:21
            probLeftOption = preProcessed.settings.treat2.Set(1,1,i);
            probRightOption = preProcessed.settings.treat2.Set(2,1,i);
            amtLeftOption = preProcessed.settings.treat2.Set(1,2,i);
            amtRightOption = preProcessed.settings.treat2.Set(2,2,i);
            choice = preProcessed.treat2.choices(i);
            if ((probLeftOption * amtLeftOption) > (probRightOption * amtRightOption)) && (choice == 1)
                heuristic.lexico.treat2.expectmaxAmountmax(i) = 1;
            elseif ((probLeftOption * amtLeftOption) < (probRightOption * amtRightOption)) && (choice == 2)
                heuristic.lexico.treat2.expectmaxAmountmax(i) = 1;
            elseif ((probLeftOption * amtLeftOption) == (probRightOption * amtRightOption)) && (amtLeftOption > amtRightOption) && (choice == 1)
                heuristic.lexico.treat2.expectmaxAmountmax(i) = 1;
            elseif ((probLeftOption * amtLeftOption) == (probRightOption * amtRightOption)) && (amtLeftOption < amtRightOption) && (choice == 2)
                heuristic.lexico.treat2.expectmaxAmountmax(i) = 1;
            else
                heuristic.lexico.treat2.expectmaxAmountmax(i) = 0;
            end
        end
        heuristic.totals.treat2.expectmaxAmountmax = sum(heuristic.lexico.treat2.expectmaxAmountmax);
        
        heuristic.lexico.treat2.expectmaxProbmax = zeros(21,1); % lexicographic heuristic of maximizing expected value then probability
        for i = 1:21
            probLeftOption = preProcessed.settings.treat2.Set(1,1,i);
            probRightOption = preProcessed.settings.treat2.Set(2,1,i);
            amtLeftOption = preProcessed.settings.treat2.Set(1,2,i);
            amtRightOption = preProcessed.settings.treat2.Set(2,2,i);
            choice = preProcessed.treat2.choices(i);
            if ((probLeftOption * amtLeftOption) > (probRightOption * amtRightOption)) && (choice == 1)
                heuristic.lexico.treat2.expectmaxProbmax(i) = 1;
            elseif ((probLeftOption * amtLeftOption) < (probRightOption * amtRightOption)) && (choice == 2)
                heuristic.lexico.treat2.expectmaxProbmax(i) = 1;
            elseif ((probLeftOption * amtLeftOption) == (probRightOption * amtRightOption)) && (probLeftOption > probRightOption) && (choice == 1)
                heuristic.lexico.treat2.expectmaxProbmax(i) = 1;
            elseif ((probLeftOption * amtLeftOption) == (probRightOption * amtRightOption)) && (probLeftOption < probRightOption) && (choice == 2)
                heuristic.lexico.treat2.expectmaxProbmax(i) = 1;
            else
                heuristic.lexico.treat2.expectmaxProbmax(i) = 0;
            end
        end
        heuristic.totals.treat2.expectmaxProbmax = sum(heuristic.lexico.treat2.expectmaxProbmax);
        
        heuristic.lexico.treat2.expectmaxIndiff = zeros(21,1); % lexicographic heuristic of maximizing expected value then indifferent
        for i = 1:21
            probLeftOption = preProcessed.settings.treat2.Set(1,1,i);
            probRightOption = preProcessed.settings.treat2.Set(2,1,i);
            amtLeftOption = preProcessed.settings.treat2.Set(1,2,i);
            amtRightOption = preProcessed.settings.treat2.Set(2,2,i);
            choice = preProcessed.treat2.choices(i);
            if ((probLeftOption * amtLeftOption) > (probRightOption * amtRightOption)) && (choice == 1)
                heuristic.lexico.treat2.expectmaxIndiff(i) = 1;
            elseif ((probLeftOption * amtLeftOption) < (probRightOption * amtRightOption)) && (choice == 2)
                heuristic.lexico.treat2.expectmaxIndiff(i) = 1;
            elseif ((probLeftOption * amtLeftOption) == (probRightOption * amtRightOption)) && (choice == 0)
                heuristic.lexico.treat2.expectmaxIndiff(i) = 1;
            else
                heuristic.lexico.treat2.expectmaxIndiff(i) = 0;
            end
        end
        heuristic.totals.treat2.expectmaxIndiff = sum(heuristic.lexico.treat2.expectmaxIndiff);
        
    end
    
    % For Treatment 3
    if folder ~= 46
        
        heuristic.nolexico.treat3.memax = zeros(21,1); % non-lexicographic heuristic of maximizing "me" amount
        for i = 1:21
            meLeftOption = preProcessed.settings.treat3.Set(1,1,i);
            meRightOption = preProcessed.settings.treat3.Set(2,1,i);
            choice = preProcessed.treat3.choices(i);
            if (meLeftOption > meRightOption) && (choice == 1);
                heuristic.nolexico.treat3.memax(i) = 1;
            elseif (meLeftOption < meRightOption) && (choice == 2);
                heuristic.nolexico.treat3.memax(i) = 1;
            elseif (meLeftOption == meRightOption) && (choice == 0);
                heuristic.nolexico.treat3.memax(i) = 1;
            else
                heuristic.nolexico.treat3.memax(i) = 0;
            end
        end
        heuristic.totals.treat3.memax = sum(heuristic.nolexico.treat3.memax);
        
        heuristic.nolexico.treat3.othermax = zeros(21,1); % non-lexicographic heuristic of maximizing "other" amount
        for i = 1:21
            otherLeftOption = preProcessed.settings.treat3.Set(1,2,i);
            otherRightOption = preProcessed.settings.treat3.Set(2,2,i);
            choice = preProcessed.treat3.choices(i);
            if (otherLeftOption > otherRightOption) && (choice == 1);
                heuristic.nolexico.treat3.othermax(i) = 1;
            elseif (otherLeftOption < otherRightOption)&& (choice == 2);
                heuristic.nolexico.treat3.othermax(i) = 1;
            elseif (otherLeftOption == otherRightOption) && (choice == 0);
                heuristic.nolexico.treat3.othermax(i) = 1;
            else
                heuristic.nolexico.treat3.othermax(i) = 0;
            end
        end
        heuristic.totals.treat3.othermax = sum(heuristic.nolexico.treat3.othermax);
        
        heuristic.nolexico.treat3.summax = zeros(21,1); % non-lexicographic heuristic of maximizing sum of "me" and "other" amounts
        for i = 1:21
            meLeftOption = preProcessed.settings.treat3.Set(1,1,i);
            meRightOption = preProcessed.settings.treat3.Set(2,1,i);
            otherLeftOption = preProcessed.settings.treat3.Set(1,2,i);
            otherRightOption = preProcessed.settings.treat3.Set(2,2,i);
            choice = preProcessed.treat3.choices(i);
            sumLeftOptions = meLeftOption + otherLeftOption;
            sumRightOptions = meRightOption + otherRightOption;
            if (sumLeftOptions > sumRightOptions) && (choice == 1);
                heuristic.nolexico.treat3.summax(i) = 1;
            elseif (sumLeftOptions < sumRightOptions) && (choice == 2);
                heuristic.nolexico.treat3.summax(i) = 1;
            elseif (sumLeftOptions == sumRightOptions) && (choice == 0);
                heuristic.nolexico.treat3.summax(i) = 1;
            else
                heuristic.nolexico.treat3.summax(i) = 0;
            end
        end
        heuristic.totals.treat3.summax = sum(heuristic.nolexico.treat3.summax);
        
        heuristic.lexico.treat3.memaxOthermax = zeros(21,1); % lexicographic heuristic of maximizing "me" amount then maximizing "other" amount
        for i = 1:21
            meLeftOption = preProcessed.settings.treat3.Set(1,1,i);
            meRightOption = preProcessed.settings.treat3.Set(2,1,i);
            otherLeftOption = preProcessed.settings.treat3.Set(1,2,i);
            otherRightOption = preProcessed.settings.treat3.Set(2,2,i);
            choice = preProcessed.treat3.choices(i);
            if (meLeftOption > meRightOption) && (choice == 1)
                heuristic.lexico.treat3.memaxOthermax(i) = 1;
            elseif (meLeftOption < meRightOption) && (choice == 2)
                heuristic.lexico.treat3.memaxOthermax(i) = 1;
            elseif (meLeftOption == meRightOption) && (otherLeftOption > otherRightOption) && (choice == 1) % if amounts are same for you, maximize what other receives
                heuristic.lexico.treat3.memaxOthermax(i) = 1;
            elseif (meLeftOption == meRightOption) && (otherLeftOption < otherRightOption) && (choice == 2)
                heuristic.lexico.treat3.memaxOthermax(i) = 1;
            else
                heuristic.lexico.treat3.memaxOthermax(i) = 0;
            end
        end
        heuristic.totals.treat3.memaxOthermax = sum(heuristic.lexico.treat3.memaxOthermax);
        
        heuristic.lexico.treat3.memaxOthermin = zeros(21,1); % lexicographic heuristic of maximizing "me" amount then minimizing "other" amount
        for i = 1:21
            meLeftOption = preProcessed.settings.treat3.Set(1,1,i);
            meRightOption = preProcessed.settings.treat3.Set(2,1,i);
            otherLeftOption = preProcessed.settings.treat3.Set(1,2,i);
            otherRightOption = preProcessed.settings.treat3.Set(2,2,i);
            choice = preProcessed.treat3.choices(i);
            if (meLeftOption > meRightOption) && (choice == 1)
                heuristic.lexico.treat3.memaxOthermin(i) = 1;
            elseif (meLeftOption < meRightOption) && (choice == 2)
                heuristic.lexico.treat3.memaxOthermin(i) = 1;
            elseif (meLeftOption == meRightOption) && (otherLeftOption > otherRightOption) && (choice == 2) % if amounts are same for you, minimize what other receives
                heuristic.lexico.treat3.memaxOthermin(i) = 1;
            elseif (meLeftOption == meRightOption) && (otherLeftOption < otherRightOption) && (choice == 1)
                heuristic.lexico.treat3.memaxOthermin(i) = 1;
            else
                heuristic.lexico.treat3.memaxOthermin(i) = 0;
            end
        end
        heuristic.totals.treat3.memaxOthermin = sum(heuristic.lexico.treat3.memaxOthermin);
        
        heuristic.lexico.treat3.summaxMemax = zeros(21,1); % lexicographic heuristic of maximizing sum of "me" and "other" amounts then maximizing "me" amount
        for i = 1:21
            meLeftOption = preProcessed.settings.treat3.Set(1,1,i);
            meRightOption = preProcessed.settings.treat3.Set(2,1,i);
            otherLeftOption = preProcessed.settings.treat3.Set(1,2,i);
            otherRightOption = preProcessed.settings.treat3.Set(2,2,i);
            choice = preProcessed.treat3.choices(i);
            if ((meLeftOption + otherLeftOption) > (meRightOption + otherRightOption)) && (choice == 1)
                heuristic.lexico.treat3.summaxMemax(i) = 1;
            elseif ((meLeftOption + otherLeftOption) < (meRightOption + otherRightOption)) && (choice == 2)
                heuristic.lexico.treat3.summaxMemax(i) = 1;
            elseif ((meLeftOption + otherLeftOption) == (meRightOption + otherRightOption)) && (meLeftOption > meRightOption) && (choice == 1)
                heuristic.lexico.treat3.summaxMemax(i) = 1;
            elseif ((meLeftOption + otherLeftOption) == (meRightOption + otherRightOption)) && (meLeftOption < meRightOption) && (choice == 2)
                heuristic.lexico.treat3.summaxMemax(i) = 1;
            else
                heuristic.lexico.treat3.summaxMemax(i) = 0;
            end
        end
        heuristic.totals.treat3.summaxMemax = sum(heuristic.lexico.treat3.summaxMemax);
        
        heuristic.lexico.treat3.summaxOthermax = zeros(21,1); % lexicographic heuristic of maximizing sum of "me" and "other" amounts then maximizing "other" amount
        for i = 1:21
            meLeftOption = preProcessed.settings.treat3.Set(1,1,i);
            meRightOption = preProcessed.settings.treat3.Set(2,1,i);
            otherLeftOption = preProcessed.settings.treat3.Set(1,2,i);
            otherRightOption = preProcessed.settings.treat3.Set(2,2,i);
            choice = preProcessed.treat3.choices(i);
            if ((meLeftOption + otherLeftOption) > (meRightOption + otherRightOption)) && (choice == 1)
                heuristic.lexico.treat3.summaxOthermax(i) = 1;
            elseif ((meLeftOption + otherLeftOption) < (meRightOption + otherRightOption)) && (choice == 2)
                heuristic.lexico.treat3.summaxOthermax(i) = 1;
            elseif ((meLeftOption + otherLeftOption) == (meRightOption + otherRightOption)) && (otherLeftOption > otherRightOption) && (choice == 1)
                heuristic.lexico.treat3.summaxOthermax(i) = 1;
            elseif ((meLeftOption + otherLeftOption) == (meRightOption + otherRightOption)) && (otherLeftOption < otherRightOption) && (choice == 2)
                heuristic.lexico.treat3.summaxOthermax(i) = 1;
            else
                heuristic.lexico.treat3.summaxOthermax(i) = 0;
            end
        end
        heuristic.totals.treat3.summaxOthermax = sum(heuristic.lexico.treat3.summaxOthermax);
        
    end
    
    
    %% Count violations between choices and elicited rankings (IC-E)
    leftOption = preProcessed.settings.treat1.Set(:,1);
    rightOption = preProcessed.settings.treat1.Set(:,2);
    
    % For Treatment 1
    choice = preProcessed.treat1.choices(:);
    for i = 1:21
        leftOptionRankIndex(i) = find(preProcessed.behavioral.rank1.key(1,:) == leftOption(i));
        leftOptionRank(i) = preProcessed.behavioral.rank1.key(2,leftOptionRankIndex(i));
        rightOptionRankIndex(i) = find(preProcessed.behavioral.rank1.key(1,:) == rightOption(i));
        rightOptionRank(i) = preProcessed.behavioral.rank1.key(2,rightOptionRankIndex(i));
    end
    [violationICE, violationTotal] = violationICEcounter(type,leftOptionRank,rightOptionRank,choice);
    violation.treat1ICE = violationICE;
    violation.treat1ICETotal = violationTotal;
    [C,J] = sort(preProcessed.behavioral.rank1.key(1,:),'ascend');
    for i = 1:length(J)
        C(2,i) = preProcessed.behavioral.rank1.key(2,J(i));
    end
    violation.elicitedRankDistribution.treat1 = C(2,:);
    % Checking for violation for catch trial of Treatment 1
    catchTrial = preProcessed.treat1.choices(22);
    if catchTrial == 1
        violation.catch1 = 0;
    elseif catchTrial == 0
        violation.catch1 = 0.5;
    elseif catchTrial == 2
        violation.catch1 = 1;
    end
    
    % For Treatment 2
    if folder ~= 46 && folder ~= 53 % since there are two subjects missing this treatment
        choice = preProcessed.treat2.choices(:);
        for i = 1:21
            leftOptionRankIndex(i) = find(preProcessed.behavioral.rank2.key(1,:) == leftOption(i));
            leftOptionRank(i) = preProcessed.behavioral.rank2.key(2,leftOptionRankIndex(i));
            rightOptionRankIndex(i) = find(preProcessed.behavioral.rank2.key(1,:) == rightOption(i));
            rightOptionRank(i) = preProcessed.behavioral.rank2.key(2,rightOptionRankIndex(i));
        end
        [violationICE, violationTotal] = violationICEcounter(type,leftOptionRank,rightOptionRank,choice);
        violation.treat2ICE = violationICE;
        violation.treat2ICETotal = violationTotal;
        [C,J] = sort(preProcessed.behavioral.rank2.key(1,:),'ascend');
        for i = 1:length(J)
            C(2,i) = preProcessed.behavioral.rank2.key(2,J(i));
        end
        violation.elicitedRankDistribution.treat2 = C(2,:);
        % Checking for violation for catch trial of Treatment 2
        catchTrial = preProcessed.treat2.choices(22);
        if catchTrial == 1
            violation.catch2 = 0;
        elseif catchTrial == 0
            violation.catch2 = 0.5;
        elseif catchTrial == 2
            violation.catch2 = 1;
        end
    end
    
    % For Treatment 3
    if folder ~= 46 % since there is one subject missing this treatment
        choice = preProcessed.treat3.choices(:);
        for i = 1:21
            leftOptionRankIndex(i) = find(preProcessed.behavioral.rank3.key(1,:) == leftOption(i));
            leftOptionRank(i) = preProcessed.behavioral.rank3.key(2,leftOptionRankIndex(i));
            rightOptionRankIndex(i) = find(preProcessed.behavioral.rank3.key(1,:) == rightOption(i));
            rightOptionRank(i) = preProcessed.behavioral.rank3.key(2,rightOptionRankIndex(i));
        end
        [violationICE, violationTotal] = violationICEcounter(type,leftOptionRank,rightOptionRank,choice);
        violation.treat3ICE = violationICE;
        violation.treat3ICETotal = violationTotal;
        [C,J] = sort(preProcessed.behavioral.rank3.key(1,:),'ascend');
        for i = 1:length(J)
            C(2,i) = preProcessed.behavioral.rank3.key(2,J(i));
        end
        violation.elicitedRankDistribution.treat3 = C(2,:);
        % Checking for violation for catch trial of Treatment 3
        catchTrial = preProcessed.treat3.choices(22);
        if catchTrial == 1
            violation.catch3 = 0;
        elseif catchTrial == 0
            violation.catch3 = 0.5;
        elseif catchTrial == 2
            violation.catch3 = 1;
        end
    end
    
    %% Count violations between choices and revealed rankings (IC-R)
    
    % For Treatment 1
    choice = preProcessed.treat1.choices(:);
    for i = 1:21
        leftOptionRank(i) = preProcessed.behavioral.treat1.tally.total(leftOption(i));
        rightOptionRank(i) = preProcessed.behavioral.treat1.tally.total(rightOption(i));
    end
    [ violationICR, violationTotal ] = violationICRcounter(type, leftOptionRank, rightOptionRank, choice );
    violation.treat1ICR = violationICR;
    violation.treat1ICRTotal = violationTotal;
    
    
    % For Treatment 2
    if folder ~= 46 && folder ~= 53
        choice = preProcessed.treat2.choices(:);
        for i = 1:21
            leftOptionRank(i) = preProcessed.behavioral.treat2.tally.total(leftOption(i));
            rightOptionRank(i) = preProcessed.behavioral.treat2.tally.total(rightOption(i));
        end
        [ violationICR, violationTotal ] = violationICRcounter(type, leftOptionRank, rightOptionRank, choice );
        violation.treat2ICR = violationICR;
        violation.treat2ICRTotal = violationTotal;
    end
    
    
    % For Treatment 3
    if folder ~= 46
        choice = preProcessed.treat3.choices(:);
        for i = 1:21
            leftOptionRank(i) = preProcessed.behavioral.treat3.tally.total(leftOption(i));
            rightOptionRank(i) = preProcessed.behavioral.treat3.tally.total(rightOption(i));
        end
        [ violationICR, violationTotal ] = violationICRcounter(type, leftOptionRank, rightOptionRank, choice );
        violation.treat3ICR = violationICR;
        violation.treat3ICRTotal = violationTotal;
    end
    
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
    
    %% Create matrix of violations (of IC-E) for the subject (based on earlier count of violations - comparison of choices and elicited rankings)
    
    % For Treatment 1
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
    
    violation.heatmapMatrix.treat1 = zeros(28,10); % this will be a matrix with ICE, ICR, TV, reaction times for all subjects to be used in making heat maps
    violation.heatmapMatrix.treat1(:,1:2) = cat(1,nchoosek([1,2,3,4,5,6,7],2),[1,1;2,2;3,3;4,4;5,5;6,6;7,7]); % first and second columns of violation.heatmapMatrix are all possible combinations of item ranks
    for i = 1:length(preProcessed.settings.treat1.Set)
        indx1 = preProcessed.behavioral.rank1.key(2,find(preProcessed.behavioral.rank1.key(1,:) == preProcessed.settings.treat1.Set(i,1)));
        indx2 = preProcessed.behavioral.rank1.key(2,find(preProcessed.behavioral.rank1.key(1,:) == preProcessed.settings.treat1.Set(i,2)));
        indx3 = sort([indx1 indx2]); % sort them in ascending order, as this is how the first two columns of violation.heatmapMatrix are listed
        indx4 = find(violation.heatmapMatrix.treat1(:,1) == indx3(1));
        violation.heatmapMatrix.treat1(indx4((find(violation.heatmapMatrix.treat1(indx4,2) == indx3(2)))),3) = violation.heatmapMatrix.treat1(indx4((find(violation.heatmapMatrix.treat1(indx4,2) == indx3(2)))),3) + violation.treat1ICE(i);
        violation.heatmapMatrix.treat1(indx4((find(violation.heatmapMatrix.treat1(indx4,2) == indx3(2)))),4) = violation.heatmapMatrix.treat1(indx4((find(violation.heatmapMatrix.treat1(indx4,2) == indx3(2)))),4) + preProcessed.treat1.responseTimes(i);
        violation.heatmapMatrix.treat1(indx4((find(violation.heatmapMatrix.treat1(indx4,2) == indx3(2)))),7) = violation.heatmapMatrix.treat1(indx4((find(violation.heatmapMatrix.treat1(indx4,2) == indx3(2)))),7) + violation.treat1ICR(i);
        violation.heatmapMatrix.treat1(indx4((find(violation.heatmapMatrix.treat1(indx4,2) == indx3(2)))),8) = violation.heatmapMatrix.treat1(indx4((find(violation.heatmapMatrix.treat1(indx4,2) == indx3(2)))),8) + violation.treat1TV(i);
    end
    
    [C,J] = sort(preProcessed.behavioral.rank1.key(1,:),'ascend');
    for i = 1:length(J)
        C(2,i) = preProcessed.behavioral.rank1.key(2,J(i));
    end
    violation.elicitedRankDistribution.treat1 = C(2,:);
    
    % For Treatment 2
    if folder ~= 46 && folder ~= 53
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
        
        violation.heatmapMatrix.treat2 = zeros(28,10); % this will be a matrix with ICE, ICR, TV, reaction times for all subjects to be used in making heat maps
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
        [C,J] = sort(preProcessed.behavioral.rank2.key(1,:),'ascend');
        for i = 1:length(J)
            C(2,i) = preProcessed.behavioral.rank2.key(2,J(i));
        end
        violation.elicitedRankDistribution.treat2 = C(2,:);
    end
    
    % For Treatment 3
    if folder ~= 46
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
        
        violation.heatmapMatrix.treat3 = zeros(28,10); % this will be a matrix with ICE, ICR, TV, reaction times for all subjects to be used in making heat maps
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
        [C,J] = sort(preProcessed.behavioral.rank3.key(1,:),'ascend');
        for i = 1:length(J)
            C(2,i) = preProcessed.behavioral.rank3.key(2,J(i));
        end
        violation.elicitedRankDistribution.treat3 = C(2,:);
    end
    
    %% Create matrix of violations (of IC-R) for the subject
    
    % For Treatment 1
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
    
    % For Treatment 2
    if folder ~= 46 && folder ~= 53
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
    end
    
    % For Treatment 3
    if folder ~= 46
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
    end
    
    % most and least favorite (revealed) options
    violation.revealedMostFavorite.treat1 = find(violation.rankDistribution.treat1 == 1);
    violation.revealedLeastFavorite.treat1 = find(violation.rankDistribution.treat1 == max(violation.rankDistribution.treat1));
    
    if folder ~= 46 && folder ~= 53
        violation.revealedMostFavorite.treat2 = find(violation.rankDistribution.treat2 == 1);
        violation.revealedLeastFavorite.treat2 = find(violation.rankDistribution.treat2 == max(violation.rankDistribution.treat2));
    end
    
    if folder ~= 46
        violation.revealedMostFavorite.treat3 = find(violation.rankDistribution.treat3 == 1);
        violation.revealedLeastFavorite.treat3 = find(violation.rankDistribution.treat3 == max(violation.rankDistribution.treat3));
    end
    
    %% Measure distance between revealed and elicited ranking of options for each subject
    
    % For Treatment 1
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
    
    
    % For Treatment 2
    if folder ~= 46 && folder ~= 53
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
    end
    
    
    % For Treatment 3
    if folder ~= 46
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
    end
    
    save('violations.mat','violation')
    %% Artificial choice REVERSALS to achieve triplet transitivity consistency
    
%     leftOption = preProcessed.settings.treat1.Set(:,1);
%     rightOption = preProcessed.settings.treat1.Set(:,2);
%     
%     % keep this code block commented-out after running once.
%     if folder ~= 46 && folder ~= 53
%         for treatment = 1:3;
%             [loop, consistentChoices] = artificialChoiceReversal(treatment,index1triplets,index2triplets,index3triplets,triplets,preProcessedFolder,subjects,folder);
%             if treatment == 1
%                 violation.choiceReversals.treat1 = loop;
%                 violation.closestConsistentChoices.treat1 = consistentChoices;
%                 choice = consistentChoices;
%                 for i = 1:21
%                     leftOptionRankIndex(i) = find(preProcessed.behavioral.rank1.key(1,:) == leftOption(i));
%                     leftOptionRank(i) = preProcessed.behavioral.rank1.key(2,leftOptionRankIndex(i));
%                     rightOptionRankIndex(i) = find(preProcessed.behavioral.rank1.key(1,:) == rightOption(i));
%                     rightOptionRank(i) = preProcessed.behavioral.rank1.key(2,rightOptionRankIndex(i));
%                 end
%                 [violationICE, violationTotal] = violationICEcounter(type,leftOptionRank,rightOptionRank,choice);
%                 violation.treat1ICEafterReversals = violationICE;
%                 violation.treat1ICETotalafterReversals = violationTotal;
%             elseif treatment == 2
%                 violation.choiceReversals.treat2 = loop;
%                 violation.closestConsistentChoices.treat2 = consistentChoices;
%                 choice = consistentChoices;
%                 for i = 1:21
%                     leftOptionRankIndex(i) = find(preProcessed.behavioral.rank2.key(1,:) == leftOption(i));
%                     leftOptionRank(i) = preProcessed.behavioral.rank2.key(2,leftOptionRankIndex(i));
%                     rightOptionRankIndex(i) = find(preProcessed.behavioral.rank2.key(1,:) == rightOption(i));
%                     rightOptionRank(i) = preProcessed.behavioral.rank2.key(2,rightOptionRankIndex(i));
%                 end
%                 [violationICE, violationTotal] = violationICEcounter(type,leftOptionRank,rightOptionRank,choice);
%                 violation.treat2ICEafterReversals = violationICE;
%                 violation.treat2ICETotalafterReversals = violationTotal;
%             elseif treatment == 3
%                 violation.choiceReversals.treat3 = loop;
%                 violation.closestConsistentChoices.treat3 = consistentChoices;
%                 choice = consistentChoices;
%                 for i = 1:21
%                     leftOptionRankIndex(i) = find(preProcessed.behavioral.rank3.key(1,:) == leftOption(i));
%                     leftOptionRank(i) = preProcessed.behavioral.rank3.key(2,leftOptionRankIndex(i));
%                     rightOptionRankIndex(i) = find(preProcessed.behavioral.rank3.key(1,:) == rightOption(i));
%                     rightOptionRank(i) = preProcessed.behavioral.rank3.key(2,rightOptionRankIndex(i));
%                 end
%                 [violationICE, violationTotal] = violationICEcounter(type,leftOptionRank,rightOptionRank,choice);
%                 violation.treat3ICEafterReversals = violationICE;
%                 violation.treat3ICETotalafterReversals = violationTotal;
%             end
%         end
%     end
%     
%     if folder == 46
%         treatment = 1;
%         [loop, consistentChoices] = artificialChoiceReversal(treatment,index1triplets,index2triplets,index3triplets,triplets,preProcessedFolder,subjects,folder);
%         violation.choiceReversals.treat1 = loop;
%         violation.closestConsistentChoices.treat1 = consistentChoices;
%         choice = consistentChoices;
%         for i = 1:21
%             leftOptionRankIndex(i) = find(preProcessed.behavioral.rank1.key(1,:) == leftOption(i));
%             leftOptionRank(i) = preProcessed.behavioral.rank1.key(2,leftOptionRankIndex(i));
%             rightOptionRankIndex(i) = find(preProcessed.behavioral.rank1.key(1,:) == rightOption(i));
%             rightOptionRank(i) = preProcessed.behavioral.rank1.key(2,rightOptionRankIndex(i));
%         end
%         [violationICE, violationTotal] = violationICEcounter(type,leftOptionRank,rightOptionRank,choice);
%         violation.treat1ICEafterReversals = violationICE;
%         violation.treat1ICETotalafterReversals = violationTotal;
%     end
%     
%     if folder == 53
%         treatment = 1;
%         [loop, consistentChoices] = artificialChoiceReversal(treatment,index1triplets,index2triplets,index3triplets,triplets,preProcessedFolder,subjects,folder);
%         violation.choiceReversals.treat1 = loop;
%         violation.closestConsistentChoices.treat1 = consistentChoices;
%         choice = consistentChoices;
%         for i = 1:21
%             leftOptionRankIndex(i) = find(preProcessed.behavioral.rank1.key(1,:) == leftOption(i));
%             leftOptionRank(i) = preProcessed.behavioral.rank1.key(2,leftOptionRankIndex(i));
%             rightOptionRankIndex(i) = find(preProcessed.behavioral.rank1.key(1,:) == rightOption(i));
%             rightOptionRank(i) = preProcessed.behavioral.rank1.key(2,rightOptionRankIndex(i));
%         end
%         [violationICE, violationTotal] = violationICEcounter(type,leftOptionRank,rightOptionRank,choice);
%         violation.treat1ICEafterReversals = violationICE;
%         violation.treat1ICETotalafterReversals = violationTotal;
%         treatment = 3;
%         [loop, consistentChoices] = artificialChoiceReversal(treatment,index1triplets,index2triplets,index3triplets,triplets,preProcessedFolder,subjects,folder);
%         violation.choiceReversals.treat3 = loop;
%         violation.closestConsistentChoices.treat3 = consistentChoices;
%         choice = consistentChoices;
%         for i = 1:21
%             leftOptionRankIndex(i) = find(preProcessed.behavioral.rank3.key(1,:) == leftOption(i));
%             leftOptionRank(i) = preProcessed.behavioral.rank3.key(2,leftOptionRankIndex(i));
%             rightOptionRankIndex(i) = find(preProcessed.behavioral.rank3.key(1,:) == rightOption(i));
%             rightOptionRank(i) = preProcessed.behavioral.rank3.key(2,rightOptionRankIndex(i));
%         end
%         [violationICE, violationTotal] = violationICEcounter(type,leftOptionRank,rightOptionRank,choice);
%         violation.treat3ICEafterReversals = violationICE;
%         violation.treat3ICETotalafterReversals = violationTotal;
%     end
%     
%     %% Artificial choice REMOVALS to achieve triplet transitivity consistency
%     
%     % need to add "type" here
%     
%     if folder ~= 46 && folder ~= 53  % run for all 3 treatments
%         for treatment = 1:3
%             if treatment == 1 && violation.triplet.treat1Total ~= 0
%                 [loop, remainingChoices] = artificialChoiceRemoval(treatment, preProcessedFolder, triplets, tripletSetIndex, subjects, folder );
%                 violation.choiceRemovals.treat1 = loop;
%                 violation.remainingConsistentChoices.treat1 = remainingChoices;
%             elseif treatment == 1 && violation.triplet.treat1Total == 0
%                 violation.choiceRemovals.treat1 = 0;
%                 violation.remainingConsistentChoices.treat1 = preProcessed.treat1.choices(1:21,1);
%             elseif treatment == 2 && violation.triplet.treat2Total ~= 0
%                 [loop, remainingChoices] = artificialChoiceRemoval(treatment, preProcessedFolder, triplets, tripletSetIndex, subjects, folder );
%                 violation.choiceRemovals.treat2 = loop;
%                 violation.remainingConsistentChoices.treat2 = remainingChoices;
%             elseif treatment == 2 && violation.triplet.treat2Total == 0
%                 violation.choiceRemovals.treat2 = 0;
%                 violation.remainingConsistentChoices.treat2 = preProcessed.treat2.choices(1:21,1);
%             elseif treatment == 3 && violation.triplet.treat3Total ~= 0
%                 [loop, remainingChoices] = artificialChoiceRemoval(treatment, preProcessedFolder, triplets, tripletSetIndex, subjects, folder );
%                 violation.choiceRemovals.treat3 = loop;
%                 violation.remainingConsistentChoices.treat3 = remainingChoices;
%             elseif treatment == 3 && violation.triplet.treat3Total == 0
%                 violation.choiceRemovals.treat3 = 0;
%                 violation.remainingConsistentChoices.treat3 = preProcessed.treat3.choices(1:21,1);
%             end
%         end
%     end
%     
%     
%     if folder == 46  % run for only Treatment 1
%         treatment = 1;
%         if treatment == 1 && violation.triplet.treat1Total ~= 0
%             [loop, remainingChoices] = artificialChoiceRemoval(treatment, preProcessedFolder, triplets, tripletSetIndex, subjects, folder );
%             violation.choiceRemovals.treat1 = loop;
%             violation.remainingConsistentChoices.treat1 = remainingChoices;
%         elseif treatment == 1 && violation.triplet.treat1Total == 0
%             violation.choiceRemovals.treat1 = 0;
%             violation.remainingConsistentChoices.treat1 = preProcessed.treat1.choices(1:21,1);
%         end
%     end
%     
%     
%     if folder == 53  % run for all except Treatment 2
%         treatment = 1;
%         if treatment == 1 && violation.triplet.treat1Total ~= 0
%             [loop, remainingChoices] = artificialChoiceRemoval(treatment, preProcessedFolder, triplets, tripletSetIndex, subjects, folder );
%             violation.choiceRemovals.treat1 = loop;
%             violation.remainingConsistentChoices.treat1 = remainingChoices;
%         elseif treatment == 1 && violation.triplet.treat1Total == 0
%             violation.choiceRemovals.treat1 = 0;
%             violation.remainingConsistentChoices.treat1 = preProcessed.treat1.choices(1:21,1);
%         end
%         treatment = 3;
%         if treatment == 3 && violation.triplet.treat3Total ~= 0
%             [loop, remainingChoices] = artificialChoiceRemoval(treatment, preProcessedFolder, triplets, tripletSetIndex, subjects, folder );
%             violation.choiceRemovals.treat3 = loop;
%             violation.remainingConsistentChoices.treat3 = remainingChoices;
%         elseif treatment == 3 && violation.triplet.treat3Total == 0
%             violation.choiceRemovals.treat3 = 0;
%             violation.remainingConsistentChoices.treat3 = preProcessed.treat3.choices(1:21,1);
%         end
%     end
    
    save('violations.mat','violation')
    
    if folder ~= 46
        save('heuristics.mat','heuristic');
    end
    
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
    
    if ismember((subjects(folder).name(1)), {'.','v','n','r','m','h','e','t','T'});
        continue
    end
    
    cd(subjects(folder).name);
    load('preProcessed.mat');
    load('violations.mat');
    if folder ~= 46
        load('heuristics.mat');
    end
    
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
    violationSummary(folder,105) = violation.treat1ICETotalafterReversals;
    if folder ~= 46 && folder ~= 53
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
        violationSummary(folder,60) = violation.quadruplet.treat2Total;
        violationSummary(folder,104) = preProcessed.treat2.choices(12);
        % list subject's favorite for each treatment (elicited then revealed)
        % elicited for treat 2
        violationSummary(folder,76:75+length(preProcessed.behavioral.rank2.key(1,find(preProcessed.behavioral.rank2.key(2,:)==1)))) = preProcessed.behavioral.rank2.key(1,find(preProcessed.behavioral.rank2.key(2,:)==1));
        % revealed for treat 2
        violationSummary(folder,83:82+length(find(violation.rankDistribution.treat2==1))) = find(violation.rankDistribution.treat2==1);
        violationSummary(folder,106) = violation.treat2ICETotalafterReversals;
        violationSummary(folder,108) = heuristic.totals.treat2.expectmaxIndiff;
    end
    if folder ~= 46
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
        violationSummary(folder,55) = max(preProcessed.behavioral.treat3.tally.total) - ...
            min(preProcessed.behavioral.treat3.tally.total);
        violationSummary(folder,58) = 21 - nnz(preProcessed.treat3.choices(1:21));
        violationSummary(folder,61) = violation.quadruplet.treat3Total;
        % list subject's favorite for each treatment (elicited then revealed)
        % elicited for treat 3
        violationSummary(folder,90:89+length(preProcessed.behavioral.rank3.key(1,find(preProcessed.behavioral.rank3.key(2,:)==1)))) = preProcessed.behavioral.rank3.key(1,find(preProcessed.behavioral.rank3.key(2,:)==1));
        % revealed for treat 3
        violationSummary(folder,97:96+length(find(violation.rankDistribution.treat3==1))) = find(violation.rankDistribution.treat3==1);
        violationSummary(folder,107) = violation.treat3ICETotalafterReversals;
    end
    
    violationSummary(folder,26) = mean(preProcessed.behavioral.treat1.secs(2:21));
    violationSummary(folder,29) = violation.party(1,1) + violation.party(1,2) + violation.party(1,4);
    violationSummary(folder,30) = violation.party(1,3) + violation.party(1,6);
    violationSummary(folder,31) = violation.party(1,5) + violation.party(1,7);
    violationSummary(folder,46) = median(preProcessed.behavioral.treat1.secs(2:21));
    violationSummary(folder,53) = max(preProcessed.behavioral.treat1.tally.total) - ...
        min(preProcessed.behavioral.treat1.tally.total);
    violationSummary(folder,56) = 21 - nnz(preProcessed.treat1.choices(1:21));
    violationSummary(folder,59) = violation.quadruplet.treat1Total;
    
    % list subject's favorite for each treatment (elicited then revealed)
    % elicited for treat 1
    violationSummary(folder,62:61+length(preProcessed.behavioral.rank1.key(1,find(preProcessed.behavioral.rank1.key(2,:)==1)))) = preProcessed.behavioral.rank1.key(1,find(preProcessed.behavioral.rank1.key(2,:)==1));
    % revealed for treat 1
    violationSummary(folder,69:68+length(find(violation.rankDistribution.treat1==1))) = find(violation.rankDistribution.treat1==1);
    
    if folder ~= 46 && folder ~= 53
        revealedMostFavorite.treat2(folder,1:length(violation.revealedMostFavorite.treat2)) = violation.revealedMostFavorite.treat2;
        revealedLeastFavorite.treat2(folder,1:length(violation.revealedLeastFavorite.treat2)) = violation.revealedLeastFavorite.treat2;
    end
    if folder ~= 46
        revealedMostFavorite.treat3(folder,1:length(violation.revealedMostFavorite.treat3)) = violation.revealedMostFavorite.treat3;
        revealedLeastFavorite.treat3(folder,1:length(violation.revealedLeastFavorite.treat3)) = violation.revealedLeastFavorite.treat3;
    end
    
    elicitedRankDistribution.treat1(folder,1) = preProcessed.settings.subjID;
    elicitedRankDistribution.treat1(folder,2) = gender;
    elicitedRankDistribution.treat1(folder,3) = gradeLevel;
    elicitedRankDistribution.treat1(folder,4:10) = violation.elicitedRankDistribution.treat1;
    
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
    
    if folder ~= 46 && folder ~= 53
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
        elicitedRankDistribution.treat2(folder,1) = preProcessed.settings.subjID;
        elicitedRankDistribution.treat2(folder,2) = gender;
        elicitedRankDistribution.treat2(folder,3) = gradeLevel;
        elicitedRankDistribution.treat2(folder,4:10) = violation.elicitedRankDistribution.treat2;
    end
    
    if folder ~= 46
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
        elicitedRankDistribution.treat3(folder,1) = preProcessed.settings.subjID;
        elicitedRankDistribution.treat3(folder,2) = gender;
        elicitedRankDistribution.treat3(folder,3) = gradeLevel;
        elicitedRankDistribution.treat3(folder,4:10) = violation.elicitedRankDistribution.treat3;
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
    
    % For Treatment 1
    rankingValue = preProcessed.behavioral.rank1.key(2,:);
    rankingOption = preProcessed.behavioral.rank1.key(1,:);
    rankingOptionList = nchoosek(rankingOption,2);
    for i = 1:length(rankingOptionList)
        rankingOptionListSorted(i,1:2) = sort(rankingOptionList(i,1:2),2); % sort within rows (so that smaller item number in first column in each row)
    end
    violationICEmatrixListed(treat1Start:treat1End,2:3) = nchoosek(rankingValue,2);
    violationICEmatrixListed(treat1Start:treat1End,4) = 1; % treatment number
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
    %violationICEmatrixListedSum.treat1(3) = violationICEmatrixListedSum.treat1(3) + violationICEmatrixListed(treat1Start:treat1End,5); % third column of this summary matrix will have sum of ICE violations
    matrixElicited.treat1 = matrixElicited.treat1 + violation.matrixElicited.treat1(3:9,3:9);
    matrixRevealed.treat1 = matrixRevealed.treat1 + violation.matrixRevealed.treat1(3:9,3:9);
    
    % For Treatment 2
    if folder ~= 46 && folder ~= 53
        rankingValue = preProcessed.behavioral.rank2.key(2,:);
        rankingOption = preProcessed.behavioral.rank2.key(1,:);
        rankingOptionList = nchoosek(rankingOption,2);
        for i = 1:length(rankingOptionList)
            rankingOptionListSorted(i,1:2) = sort(rankingOptionList(i,1:2),2);
        end
        violationICEmatrixListed(treat2Start:treat2End,2:3) = nchoosek(rankingValue,2);
        violationICEmatrixListed(treat2Start:treat2End,4) = 2; % treatment number
        violationICEmatrixListed(treat2Start:treat2End,10:11) = nchoosek(rankingOption,2); % fill columns 10 and 11 with option Numbers
        for trial = 1:21
            indexFirst = find(preProcessed.settings.treat1.Set(trial,1) == rankingOptionListSorted(:,1));
            indexSecond = find(preProcessed.settings.treat1.Set(trial,2) == rankingOptionListSorted(indexFirst,2));
            index = indexFirst(indexSecond);
            violationICEmatrixListed(treat2Start + index - 1, 5) = violation.treat2ICE(trial);
            violationICEmatrixListed(treat2Start + index - 1, 8) = preProcessed.treat2.responseTimes(trial);
            violationICEmatrixListed(treat2Start + index - 1, 9) = preProcessed.treat2.choices(trial);
        end
    elseif folder == 46 || folder == 53
        violationICEmatrixListed(treat2Start:treat2End, 5) = 0;
        violationICEmatrixListed(treat2Start:treat2End, 8:10) = 0;
    end
    if folder ~= 46 && folder ~= 53
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
    elseif folder == 46 || folder == 53
        violationRxnTimeListed(treat2Start:treat2End,4:11) = 0;
    end
    
    % For Treatment 3
    if folder ~= 46
        rankingValue = preProcessed.behavioral.rank3.key(2,:);
        rankingOption = preProcessed.behavioral.rank3.key(1,:);
        rankingOptionList = nchoosek(rankingOption,2);
        for i = 1:length(rankingOptionList)
            rankingOptionListSorted(i,1:2) = sort(rankingOptionList(i,1:2),2);
        end
        violationICEmatrixListed(treat3Start:treat3End,2:3) = nchoosek(rankingValue,2);
        violationICEmatrixListed(treat3Start:treat3End,4) = 3; % treatment number
        violationICEmatrixListed(treat3Start:treat3End,10:11) = nchoosek(rankingOption,2); % fill columns 10 and 11 with option Numbers
        for trial = 1:21
            indexFirst = find(preProcessed.settings.treat1.Set(trial,1) == rankingOptionListSorted(:,1));
            indexSecond = find(preProcessed.settings.treat1.Set(trial,2) == rankingOptionListSorted(indexFirst,2));
            index = indexFirst(indexSecond);
            violationICEmatrixListed(treat3Start + index - 1, 5) = violation.treat3ICE(trial);
            violationICEmatrixListed(treat3Start + index - 1, 8) = preProcessed.treat3.responseTimes(trial);
            violationICEmatrixListed(treat3Start + index - 1, 9) = preProcessed.treat3.choices(trial);
        end
    elseif folder == 46
        violationICEmatrixListed(treat3Start:treat3End, 5) = 0;
        violationICEmatrixListed(treat3Start:treat3End, 8) = 0;
        violationICEmatrixListed(treat3Start:treat3End, 9) = 0;
    end
    if folder ~= 46
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
    elseif folder == 46
        violationRxnTimeListed(treat3Start:treat3End,4:11) = 0;
    end
    
    
    % Matrices with averages - will then be used in R to construct heat
    % maps for violation and reaction time of each pair of items (based on
    % their elicited and revealed rankings)
    
    % For treatment 1
    heatmapMatrix.ice.treat1(:,3) = heatmapMatrix.ice.treat1(:,3) + violation.heatmapMatrix.treat1(:,3); % this will be a matrix with the sum of ICE, ICR, TV, reaction times for all subjects to be used in making heat maps
    heatmapMatrix.iceAvgRxn.treat1(:,3) = heatmapMatrix.iceAvgRxn.treat1(:,3) + violation.heatmapMatrix.treat1(:,4);
    heatmapMatrix.icr.treat1(:,3) = heatmapMatrix.icr.treat1(:,3) + violation.heatmapMatrix.treat1(:,5);
    heatmapMatrix.icrAvgRxn.treat1(:,3) = heatmapMatrix.icrAvgRxn.treat1(:,3) + violation.heatmapMatrix.treat1(:,6);
    heatmapMatrix.iceICR.treat1(:,3) = heatmapMatrix.iceICR.treat1(:,3) + violation.heatmapMatrix.treat1(:,7); % ICR violations and ICE ranking labels of options
    heatmapMatrix.iceTV.treat1(:,3) = heatmapMatrix.iceTV.treat1(:,3) + violation.heatmapMatrix.treat1(:,8); % TV violations and ICE ranking labels of options
    heatmapMatrix.icrICE.treat1(:,3) = heatmapMatrix.icrICE.treat1(:,3) + violation.heatmapMatrix.treat1(:,9); % ICE violations and ICR ranking labels of options
    heatmapMatrix.icrTV.treat1(:,3) = heatmapMatrix.icrTV.treat1(:,3) + violation.heatmapMatrix.treat1(:,10); % TV violations and ICR ranking labels of options
    
    % For treatment 2
    if folder ~= 46 && folder ~= 53
        heatmapMatrix.ice.treat2(:,3) = heatmapMatrix.ice.treat2(:,3) + violation.heatmapMatrix.treat2(:,3);
        heatmapMatrix.iceAvgRxn.treat2(:,3) = heatmapMatrix.iceAvgRxn.treat2(:,3) + violation.heatmapMatrix.treat2(:,4);
        heatmapMatrix.icr.treat2(:,3) = heatmapMatrix.icr.treat2(:,3) + violation.heatmapMatrix.treat2(:,5);
        heatmapMatrix.icrAvgRxn.treat2(:,3) = heatmapMatrix.icrAvgRxn.treat2(:,3) + violation.heatmapMatrix.treat2(:,6);
        heatmapMatrix.iceICR.treat2(:,3) = heatmapMatrix.iceICR.treat2(:,3) + violation.heatmapMatrix.treat2(:,7); % ICR violations and ICE ranking labels of options
        heatmapMatrix.iceTV.treat2(:,3) = heatmapMatrix.iceTV.treat2(:,3) + violation.heatmapMatrix.treat2(:,8); % TV violations and ICE ranking labels of options
        heatmapMatrix.icrICE.treat2(:,3) = heatmapMatrix.icrICE.treat2(:,3) + violation.heatmapMatrix.treat2(:,9); % ICE violations and ICR ranking labels of options
        heatmapMatrix.icrTV.treat2(:,3) = heatmapMatrix.icrTV.treat2(:,3) + violation.heatmapMatrix.treat2(:,10); % TV violations and ICR ranking labels of options
    end
    
    % For treatment 3
    if folder ~= 46
        heatmapMatrix.ice.treat3(:,3) = heatmapMatrix.ice.treat3(:,3) + violation.heatmapMatrix.treat3(:,3);
        heatmapMatrix.iceAvgRxn.treat3(:,3) = heatmapMatrix.iceAvgRxn.treat3(:,3) + violation.heatmapMatrix.treat3(:,4);
        heatmapMatrix.icr.treat3(:,3) = heatmapMatrix.icr.treat3(:,3) + violation.heatmapMatrix.treat3(:,5);
        heatmapMatrix.icrAvgRxn.treat3(:,3) = heatmapMatrix.icrAvgRxn.treat3(:,3) + violation.heatmapMatrix.treat3(:,6);
        heatmapMatrix.iceICR.treat3(:,3) = heatmapMatrix.iceICR.treat3(:,3) + violation.heatmapMatrix.treat3(:,7); % ICR violations and ICE ranking labels of options
        heatmapMatrix.iceTV.treat3(:,3) = heatmapMatrix.iceTV.treat3(:,3) + violation.heatmapMatrix.treat3(:,8); % TV violations and ICE ranking labels of options
        heatmapMatrix.icrICE.treat3(:,3) = heatmapMatrix.icrICE.treat3(:,3) + violation.heatmapMatrix.treat3(:,9); % ICE violations and ICR ranking labels of options
        heatmapMatrix.icrTV.treat3(:,3) = heatmapMatrix.icrTV.treat3(:,3) + violation.heatmapMatrix.treat3(:,10); % TV violations and ICR ranking labels of options
    end
    
    % Indifferences and violations, by triplet (for each subject and
    % treatment)
    tripletSummary(((folder-3)*35)+1:(((folder-3)*35)+35),1) = preProcessed.settings.subjID;       % 1st column
    tripletSummary(((folder-3)*35)+1:(((folder-3)*35)+35),2) = gender;                             % 2nd column
    tripletSummary(((folder-3)*35)+1:(((folder-3)*35)+35),3) = gradeLevel;                         % 3rd column
    tripletSummary(((folder-3)*35)+1:(((folder-3)*35)+35),4) = violation.indifferentChoices.treat1(1:35,1);
    tripletSummary(((folder-3)*35)+1:(((folder-3)*35)+35),5) = violation.triplet.treat1(1:35,1);
    
    if folder ~= 46 && folder ~= 53
        tripletSummary(((folder-3)*35)+1:(((folder-3)*35)+35),6) = violation.indifferentChoices.treat2(1:35,1);
        tripletSummary(((folder-3)*35)+1:(((folder-3)*35)+35),7) = violation.triplet.treat2(1:35,1);
    end
    
    if folder ~= 46
        tripletSummary(((folder-3)*35)+1:(((folder-3)*35)+35),8) = violation.indifferentChoices.treat3(1:35,1);
        tripletSummary(((folder-3)*35)+1:(((folder-3)*35)+35),9) = violation.triplet.treat3(1:35,1);
    end
    
    % Indifferences and violations, summed for each subject (for each
    % treatment)
    TVandIndiffSummary.treat1(folder,1) = preProcessed.settings.subjID;
    TVandIndiffSummary.treat1(folder,2) = gender;
    TVandIndiffSummary.treat1(folder,3) = gradeLevel;
    TVandIndiffSummary.treat1(folder,4:7) = violation.TVandIndiffTotal.treat1(1,1:4);
    
    if folder ~= 46 && folder ~= 53
        TVandIndiffSummary.treat2(folder,1) = preProcessed.settings.subjID;
        TVandIndiffSummary.treat2(folder,2) = gender;
        TVandIndiffSummary.treat2(folder,3) = gradeLevel;
        TVandIndiffSummary.treat2(folder,4:7) = violation.TVandIndiffTotal.treat2(1,1:4);
    end
    
    if folder ~= 46
        TVandIndiffSummary.treat3(folder,1) = preProcessed.settings.subjID;
        TVandIndiffSummary.treat3(folder,2) = gender;
        TVandIndiffSummary.treat3(folder,3) = gradeLevel;
        TVandIndiffSummary.treat3(folder,4:7) = violation.TVandIndiffTotal.treat3(1,1:4);
    end
    
    cd('../');
end

% Divide third column of heat map prep matrices by number of subjects who
% completed that treatment (134, 132, 133, for T1, T2, T3, respectively)
heatmapMatrix.ice.treat1(:,3) = heatmapMatrix.ice.treat1(:,3)/134;
heatmapMatrix.iceAvgRxn.treat1(:,3) = heatmapMatrix.iceAvgRxn.treat1(:,3)/134;
heatmapMatrix.icr.treat1(:,3) = heatmapMatrix.icr.treat1(:,3)/134;
heatmapMatrix.icrAvgRxn.treat1(:,3) = heatmapMatrix.icrAvgRxn.treat1(:,3)/134;
heatmapMatrix.iceICR.treat1(:,3) = heatmapMatrix.iceICR.treat1(:,3)/134;
heatmapMatrix.iceTV.treat1(:,3) = heatmapMatrix.iceTV.treat1(:,3)/134;
heatmapMatrix.icrICE.treat1(:,3) = heatmapMatrix.icrICE.treat1(:,3)/134;
heatmapMatrix.icrTV.treat1(:,3) = heatmapMatrix.icrTV.treat1(:,3)/134;

heatmapMatrix.ice.treat2(:,3) = heatmapMatrix.ice.treat2(:,3)/132;
heatmapMatrix.iceAvgRxn.treat2(:,3) = heatmapMatrix.iceAvgRxn.treat2(:,3)/132;
heatmapMatrix.icr.treat2(:,3) = heatmapMatrix.icr.treat2(:,3)/132;
heatmapMatrix.icrAvgRxn.treat2(:,3) = heatmapMatrix.icrAvgRxn.treat2(:,3)/132;
heatmapMatrix.iceICR.treat2(:,3) = heatmapMatrix.iceICR.treat2(:,3)/132;
heatmapMatrix.iceTV.treat2(:,3) = heatmapMatrix.iceTV.treat2(:,3)/132;
heatmapMatrix.icrICE.treat2(:,3) = heatmapMatrix.icrICE.treat2(:,3)/132;
heatmapMatrix.icrTV.treat2(:,3) = heatmapMatrix.icrTV.treat2(:,3)/132;


heatmapMatrix.ice.treat3(:,3) = heatmapMatrix.ice.treat3(:,3)/133;
heatmapMatrix.iceAvgRxn.treat3(:,3) = heatmapMatrix.iceAvgRxn.treat3(:,3)/133;
heatmapMatrix.icr.treat3(:,3) = heatmapMatrix.icr.treat3(:,3)/133;
heatmapMatrix.icrAvgRxn.treat3(:,3) = heatmapMatrix.icrAvgRxn.treat3(:,3)/133;
heatmapMatrix.iceICR.treat3(:,3) = heatmapMatrix.iceICR.treat3(:,3)/133;
heatmapMatrix.iceTV.treat3(:,3) = heatmapMatrix.iceTV.treat3(:,3)/133;
heatmapMatrix.icrICE.treat3(:,3) = heatmapMatrix.icrICE.treat3(:,3)/133;
heatmapMatrix.icrTV.treat3(:,3) = heatmapMatrix.icrTV.treat3(:,3)/133;

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

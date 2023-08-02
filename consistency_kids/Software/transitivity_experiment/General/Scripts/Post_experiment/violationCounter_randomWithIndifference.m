function [ violation ] = violationCounter_randomWithIndifference(triplets, Treatment1, choices, violationSummaryTV)
% Author: Niree Kodaverdian

index1 = zeros(length(triplets),1); % vector of 35 zeros. made so that 'index1' does not change size with each loop and in turn, produce annoying squiggly red lines under the word in the loop
index2 = zeros(length(triplets),1); % same as above
index3 = zeros(length(triplets),1); % same as above

for i = 1:length(triplets)
    first = triplets(i,1); % first element of a given row i
    second = triplets(i,2); % second element of a given row i
    third = triplets(i,3); % third element of a given row i
    
    index1First = find(Treatment1(:,1) == first);
    index1Second = find(Treatment1(index1First,2) == second); % use treat1.Set for all treatments, since same order across treatments
    index1(i,1) = index1First(index1Second); % index1 corresponds to the trial number in which the first and second options (elements of the given 'triplets' row) are compared
    
    index2First = find(Treatment1(:,1) == second);
    index2Second = find(Treatment1(index2First,2) == third);
    index2(i,1) = index2First(index2Second); % index2 corresponds to the trial number in which the second and third options (elements of the given 'triplets' row) are compared
    
    index3First = find(Treatment1(:,1) == first);
    index3Second = find(Treatment1(index3First,2) == third);
    index3(i,1) = index3First(index3Second); % index3 corresponds to the trial number in which the first and third options (elements of the given 'triplets' row) are compared
end

for i = 1:length(triplets)
    choice1 = choices(index1(i,1));
    choice2 = choices(index2(i,1));
    choice3 = choices(index3(i,1));
    if choice1 == 1 && choice2 == 1 && choice3 == 2         % case 1.s - strong violation (1 pt) - 3 same-way arrows (clockwise)
        violation(i,1) = 1;
    elseif choice1 == 0 && choice2 == 1 && choice3 == 2     % case 1.w.1 - weak violation (0.5 pt) - 2 same-way arrows, 1 indifference
        violation(i,1) = 0.5;
    elseif choice1 == 1 && choice2 == 0 && choice3 == 2     % case 1.w.2 - weak violation (0.5 pt) - 2 same-way arrows, 1 indifference
        violation(i,1) = 0.5;
    elseif choice1 == 1 && choice2 == 1 && choice3 == 0     % case 1.w.3 - weak violation (0.5 pt) - 2 same-way arrows, 1 indifference
        violation(i,1) = 0.5;
        
    elseif choice1 == 2 && choice2 == 2 && choice3 == 1     % case 2.s - strong violation (1 pt) - 3 same-way arrows (counter-clockwise)
        violation(i,1) = 1;
    elseif choice1 == 0 && choice2 == 2 && choice3 == 1     % case 2.w.1 - weak violation (0.5 pt) - 2 same-way arrows, 1 indifference
        violation(i,1) = 0.5;
    elseif choice1 == 2 && choice2 == 0 && choice3 == 1     % case 2.w.2 - weak violation (0.5 pt) - 2 same-way arrows, 1 indifference
        violation(i,1) = 0.5;
    elseif choice1 == 2 && choice2 == 2 && choice3 == 0     % case 2.w.3 - weak violation (0.5 pt) - 2 same-way arrows, 1 indifference
        violation(i,1) = 0.5;
        
    elseif choice1 == 0 && choice2 == 0 && choice3 ~= 0     % case 3.w.1 - weak violation (0.5 pt) - 1 arrow, 2 indifferences
        violation(i,1) = 0.5;
    elseif choice1 == 0 && choice2 ~= 0 && choice3 == 0     % case 3.w.2 - weak violation (0.5 pt) - 1 arrow, 2 indifferences
        violation(i,1) = 0.5;
    elseif choice1 ~= 0 && choice2 == 0 && choice3 == 0     % case 3.w.3 - weak violation (0.5 pt) - 1 arrow, 2 indifferences
        violation(i,1) = 0.5;
        
    else
        violation(i,1) = 0;
    end
    
end


end


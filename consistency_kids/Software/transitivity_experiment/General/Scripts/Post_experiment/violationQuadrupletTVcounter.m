function [quadViolation,quadTotal,quadViolationByTrial] = violationQuadrupletTVcounter(index1,index2,index3,index4,choices,quadruplets,quadrupletSetIndex)
% Author: Niree Kodaverdian

for i = 1:length(quadruplets)
    choice1 = choices(index1(i,1));
    choice2 = choices(index2(i,1));
    choice3 = choices(index3(i,1));
    choice4 = choices(index4(i,1));
    
    if choice1 == 1 && choice2 == 1 && choice3 == 1 && choice4 == 2        % case 1.s - strong violation (1 pt) - 3 same-way arrows (clockwise)
        quadViolation(i,1) = 1;
    elseif choice1 == 0 && choice2 == 1 && choice3 == 1 && choice4 == 2   % case 1.w.1 - weak violation (0.5 pt) - 3 same-way arrows, 1 indifference
        quadViolation(i,1) = 0.5;
    elseif choice1 == 1 && choice2 == 0 && choice3 == 1 && choice4 == 2   % case 1.w.2 - weak violation (0.5 pt) - 3 same-way arrows, 1 indifference
        quadViolation(i,1) = 0.5;
    elseif choice1 == 1 && choice2 == 1 && choice3 == 0 && choice4 == 2  % case 1.w.3 - weak violation (0.5 pt) - 3 same-way arrows, 1 indifference
        quadViolation(i,1) = 0.5;
    elseif choice1 == 1 && choice2 == 1 && choice3 == 1 && choice4 == 0
        quadViolation(i,1) = 0.5;
        
    elseif choice1 == 2 && choice2 == 2 && choice3 == 2 && choice4 == 1    % case 2.s - strong violation (1 pt) - 4 same-way arrows (counter-clockwise)
        quadViolation(i,1) = 1;
    elseif choice1 == 0 && choice2 == 2 && choice3 == 2 && choice4 == 1  % case 2.w.1 - weak violation (0.5 pt) - 3 same-way arrows, 1 indifference
        quadViolation(i,1) = 0.5;
    elseif choice1 == 2 && choice2 == 0 && choice3 == 2 && choice4 == 1  % case 2.w.2 - weak violation (0.5 pt) - 3 same-way arrows, 1 indifference
        quadViolation(i,1) = 0.5;
    elseif choice1 == 2 && choice2 == 2 && choice3 == 0 && choice4 == 1  % case 2.w.3 - weak violation (0.5 pt) - 3 same-way arrows, 1 indifference
        quadViolation(i,1) = 0.5;
    elseif choice1 == 2 && choice2 == 2 && choice3 == 2 && choice4 == 0
        quadViolation(i,1) = 0.5;
        
    elseif choice1 == 0 && choice2 == 0 && choice3 == 0 && choice4 ~= 0  % case 3.w.1 - weak violation (0.5 pt) - 1 arrow, 3 indifferences
        quadViolation(i,1) = 0.5;
    elseif choice1 == 0 && choice2 == 0 && choice3 ~= 0 && choice4 == 0   % case 3.w.2 - weak violation (0.5 pt) - 1 arrow, 3 indifferences
        quadViolation(i,1) = 0.5;
    elseif choice1 == 0 && choice2 ~= 0 && choice3 == 0 && choice4 == 0   % case 3.w.3 - weak violation (0.5 pt) - 1 arrow, 3 indifferences
        quadViolation(i,1) = 0.5;
    elseif choice1 ~= 0 && choice2 == 0 && choice3 == 0 && choice4 == 0
        quadViolation(i,1) = 0.5;
        
    else
        quadViolation(i,1) = 0;
    end
    
end
quadTotal = sum(quadViolation);

for i = 1:length(quadrupletSetIndex)
    if sum(quadViolation(quadrupletSetIndex(i,1:length(quadrupletSetIndex(1,:))))) ~= 0
        quadViolationByTrial(i,1) = sum(quadViolation(quadrupletSetIndex(i,1:length(quadrupletSetIndex(1,:)))));
    elseif sum(quadViolation(quadrupletSetIndex(i,1:length(quadrupletSetIndex(1,:))))) == 0
        quadViolationByTrial(i,1) = sum(quadViolation(quadrupletSetIndex(i,1:length(quadrupletSetIndex(1,:)))));
    end
end


end


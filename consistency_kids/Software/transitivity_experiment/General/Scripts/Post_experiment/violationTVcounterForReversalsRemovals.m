function [completedProcess] = violationTVcounterForReversalsRemovals(index1,index2,index3,choices,triplets)
% Author: Niree Kodaverdian

completedProcess = 0;
violation = zeros(length(triplets),1);

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

sumViolations = sum(violation);
if sumViolations == 0                               % if 0 violations, then end process
    completedProcess = completedProcess + 1;
elseif sumViolations > 0                            % if still a positive number of violations, then do not end process - keep looping and reversing choices
    completedProcess = completedProcess + 0;
end


end



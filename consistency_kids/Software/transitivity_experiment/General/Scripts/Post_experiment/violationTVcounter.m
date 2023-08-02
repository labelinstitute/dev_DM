function [ violationTV, violationTotal, indifference, indifferenceTotal, TVandIndiff, TVandIndiffTotal ] = violationTVcounter( type,choice1,choice2,choice3)
% Author: Niree Kodaverdian

if type == 0.5
    for i = 1:length(choice1)
        if choice1(i) == 1 && choice2(i) == 1 && choice3(i) == 2         % case 1.s - strong violationTV (1 pt) - 3 same-way arrows (clockwise)
            violationTV(i,1) = 1;
            indifference(i,1) = 0;
            TVandIndiff(i,1) = 0; 
            TVandIndiff(i,2) = 0;
            TVandIndiff(i,3) = 1; % yes TV, no indifference
            TVandIndiff(i,4) = 0;
        elseif choice1(i) == 0 && choice2(i) == 1 && choice3(i) == 2     % case 1.w.1 - weak violationTV (0.5 pt) - 2 same-way arrows, 1 indifference
            violationTV(i,1) = 0.5;
            indifference(i,1) = 1;
            TVandIndiff(i,1) = 1; % yes TV, yes indifference
            TVandIndiff(i,2) = 0;
            TVandIndiff(i,3) = 0;
            TVandIndiff(i,4) = 0;
        elseif choice1(i) == 1 && choice2(i) == 0 && choice3(i) == 2     % case 1.w.2 - weak violationTV (0.5 pt) - 2 same-way arrows, 1 indifference
            violationTV(i,1) = 0.5;
            indifference(i,1) = 1;
            TVandIndiff(i,1) = 1; % yes TV, yes indifference
            TVandIndiff(i,2) = 0;
            TVandIndiff(i,3) = 0;
            TVandIndiff(i,4) = 0;
        elseif choice1(i) == 1 && choice2(i) == 1 && choice3(i) == 0     % case 1.w.3 - weak violationTV (0.5 pt) - 2 same-way arrows, 1 indifference
            violationTV(i,1) = 0.5;
            indifference(i,1) = 1;
            TVandIndiff(i,1) = 1; % yes TV, yes indifference
            TVandIndiff(i,2) = 0;
            TVandIndiff(i,3) = 0;
            TVandIndiff(i,4) = 0;
            
        elseif choice1(i) == 2 && choice2(i) == 2 && choice3(i) == 1     % case 2.s - strong violationTV (1 pt) - 3 same-way arrows (counter-clockwise)
            violationTV(i,1) = 1;
            indifference(i,1) = 0;
            TVandIndiff(i,1) = 0;
            TVandIndiff(i,2) = 0;
            TVandIndiff(i,3) = 1; % yes TV, no indifference
            TVandIndiff(i,4) = 0;
        elseif choice1(i) == 0 && choice2(i) == 2 && choice3(i) == 1     % case 2.w.1 - weak violationTV (0.5 pt) - 2 same-way arrows, 1 indifference
            violationTV(i,1) = 0.5;
            indifference(i,1) = 1;
            TVandIndiff(i,1) = 1; % yes TV, yes indifference
            TVandIndiff(i,2) = 0;
            TVandIndiff(i,3) = 0;
            TVandIndiff(i,4) = 0;
        elseif choice1(i) == 2 && choice2(i) == 0 && choice3(i) == 1     % case 2.w.2 - weak violationTV (0.5 pt) - 2 same-way arrows, 1 indifference
            violationTV(i,1) = 0.5;
            indifference(i,1) = 1;
            TVandIndiff(i,1) = 1; % yes TV, yes indifference
            TVandIndiff(i,2) = 0;
            TVandIndiff(i,3) = 0;
            TVandIndiff(i,4) = 0;
        elseif choice1(i) == 2 && choice2(i) == 2 && choice3(i) == 0     % case 2.w.3 - weak violationTV (0.5 pt) - 2 same-way arrows, 1 indifference
            violationTV(i,1) = 0.5;
            indifference(i,1) = 1;
            TVandIndiff(i,1) = 1; % yes TV, yes indifference
            TVandIndiff(i,2) = 0;
            TVandIndiff(i,3) = 0;
            TVandIndiff(i,4) = 0;
            
        elseif choice1(i) == 0 && choice2(i) == 0 && choice3(i) ~= 0     % case 3.w.1 - weak violationTV (0.5 pt) - 1 arrow, 2 indifferences
            violationTV(i,1) = 0.5;
            indifference(i,1) = 1;
            TVandIndiff(i,1) = 1; % yes TV, yes indifference
            TVandIndiff(i,2) = 0;
            TVandIndiff(i,3) = 0;
            TVandIndiff(i,4) = 0;
        elseif choice1(i) == 0 && choice2(i) ~= 0 && choice3(i) == 0     % case 3.w.2 - weak violationTV (0.5 pt) - 1 arrow, 2 indifferences
            violationTV(i,1) = 0.5;
            indifference(i,1) = 1;
            TVandIndiff(i,1) = 1; % yes TV, yes indifference
            TVandIndiff(i,2) = 0;
            TVandIndiff(i,3) = 0;
            TVandIndiff(i,4) = 0;
        elseif choice1(i) ~= 0 && choice2(i) == 0 && choice3(i) == 0     % case 3.w.3 - weak violationTV (0.5 pt) - 1 arrow, 2 indifferences
            violationTV(i,1) = 0.5;
            indifference(i,1) = 1;
            TVandIndiff(i,1) = 1; % yes TV, yes indifference
            TVandIndiff(i,2) = 0;
            TVandIndiff(i,3) = 0;
            TVandIndiff(i,4) = 0;
            
        elseif choice1(i) ~= 0 && choice2(i) ~= 0 && choice3(i) ~= 0
            violationTV(i,1) = 0;
            indifference(i,1) = 0;
            TVandIndiff(i,1) = 0;
            TVandIndiff(i,2) = 0;
            TVandIndiff(i,3) = 0;
            TVandIndiff(i,4) = 1; % no TV, no indifference
        elseif choice1(i) == 0 || choice2(i) == 0 || choice3(i) == 0
            violationTV(i,1) = 0;
            indifference(i,1) = 1; 
            TVandIndiff(i,1) = 0;
            TVandIndiff(i,2) = 1; % no TV, yes indifference
            TVandIndiff(i,3) = 0;
            TVandIndiff(i,4) = 0;
        end
    end
    
elseif type == 1
    for i = 1:length(choice1)
        if choice1(i) == 1 && choice2(i) == 1 && choice3(i) == 2         % case 1.s - strong violationTV (1 pt) - 3 same-way arrows (clockwise)
            violationTV(i,1) = 1;
            indifference(i,1) = 0;
            TVandIndiff(i,1) = 0;
            TVandIndiff(i,2) = 0;
            TVandIndiff(i,3) = 1;
            TVandIndiff(i,4) = 0;
        elseif choice1(i) == 0 && choice2(i) == 1 && choice3(i) == 2     % case 1.w.1 - weak violationTV (1 pt) - 2 same-way arrows, 1 indifference
            violationTV(i,1) = 1;
            indifference(i,1) = 1;
            TVandIndiff(i,1) = 1;
            TVandIndiff(i,2) = 0;
            TVandIndiff(i,3) = 0;
            TVandIndiff(i,4) = 0;
        elseif choice1(i) == 1 && choice2(i) == 0 && choice3(i) == 2     % case 1.w.2 - weak violationTV (1 pt) - 2 same-way arrows, 1 indifference
            violationTV(i,1) = 1;
            indifference(i,1) = 1;
            TVandIndiff(i,1) = 1;
            TVandIndiff(i,2) = 0;
            TVandIndiff(i,3) = 0;
            TVandIndiff(i,4) = 0;
        elseif choice1(i) == 1 && choice2(i) == 1 && choice3(i) == 0     % case 1.w.3 - weak violationTV (1 pt) - 2 same-way arrows, 1 indifference
            violationTV(i,1) = 1;
            indifference(i,1) = 1;
            TVandIndiff(i,1) = 1;
            TVandIndiff(i,2) = 0;
            TVandIndiff(i,3) = 0;
            TVandIndiff(i,4) = 0;
            
        elseif choice1(i) == 2 && choice2(i) == 2 && choice3(i) == 1     % case 2.s - strong violationTV (1 pt) - 3 same-way arrows (counter-clockwise)
            violationTV(i,1) = 1;
            indifference(i,1) = 0;
            TVandIndiff(i,1) = 0;
            TVandIndiff(i,2) = 0;
            TVandIndiff(i,3) = 1;
            TVandIndiff(i,4) = 0;
        elseif choice1(i) == 0 && choice2(i) == 2 && choice3(i) == 1     % case 2.w.1 - weak violationTV (1 pt) - 2 same-way arrows, 1 indifference
            violationTV(i,1) = 1;
            indifference(i,1) = 1;
            TVandIndiff(i,1) = 1;
            TVandIndiff(i,2) = 0;
            TVandIndiff(i,3) = 0;
            TVandIndiff(i,4) = 0;
        elseif choice1(i) == 2 && choice2(i) == 0 && choice3(i) == 1     % case 2.w.2 - weak violationTV (1 pt) - 2 same-way arrows, 1 indifference
            violationTV(i,1) = 1;
            indifference(i,1) = 1;
            TVandIndiff(i,1) = 1;
            TVandIndiff(i,2) = 0;
            TVandIndiff(i,3) = 0;
            TVandIndiff(i,4) = 0;
        elseif choice1(i) == 2 && choice2(i) == 2 && choice3(i) == 0     % case 2.w.3 - weak violationTV (1 pt) - 2 same-way arrows, 1 indifference
            violationTV(i,1) = 1;
            indifference(i,1) = 1;
            TVandIndiff(i,1) = 1;
            TVandIndiff(i,2) = 0;
            TVandIndiff(i,3) = 0;
            TVandIndiff(i,4) = 0;
            
        elseif choice1(i) == 0 && choice2(i) == 0 && choice3(i) ~= 0     % case 3.w.1 - weak violationTV (1 pt) - 1 arrow, 2 indifferences
            violationTV(i,1) = 1;
            indifference(i,1) = 1;
            TVandIndiff(i,1) = 1;
            TVandIndiff(i,2) = 0;
            TVandIndiff(i,3) = 0;
            TVandIndiff(i,4) = 0;
        elseif choice1(i) == 0 && choice2(i) ~= 0 && choice3(i) == 0     % case 3.w.2 - weak violationTV (1 pt) - 1 arrow, 2 indifferences
            violationTV(i,1) = 1;
            indifference(i,1) = 1;
            TVandIndiff(i,1) = 1;
            TVandIndiff(i,2) = 0;
            TVandIndiff(i,3) = 0;
            TVandIndiff(i,4) = 0;
        elseif choice1(i) ~= 0 && choice2(i) == 0 && choice3(i) == 0     % case 3.w.3 - weak violationTV (1 pt) - 1 arrow, 2 indifferences
            violationTV(i,1) = 1;
            indifference(i,1) = 1;
            TVandIndiff(i,1) = 1;
            TVandIndiff(i,2) = 0;
            TVandIndiff(i,3) = 0;
            TVandIndiff(i,4) = 0;
            
        elseif choice1(i) ~= 0 && choice2(i) ~= 0 && choice3(i) ~= 0
            violationTV(i,1) = 0;
            indifference(i,1) = 0;
            TVandIndiff(i,1) = 0;
            TVandIndiff(i,2) = 0;
            TVandIndiff(i,3) = 0;
            TVandIndiff(i,4) = 1;
        elseif choice1(i) == 0 || choice2(i) == 0 || choice3(i) == 0
            violationTV(i,1) = 0;
            indifference(i,1) = 1;
            TVandIndiff(i,1) = 0;
            TVandIndiff(i,2) = 1;
            TVandIndiff(i,3) = 0;
            TVandIndiff(i,4) = 0;
        end
    end
end

indifferenceTotal = sum(indifference);
violationTotal = sum(violationTV);
TVandIndiffTotal(1,1) = sum(TVandIndiff(:,1));
TVandIndiffTotal(1,2) = sum(TVandIndiff(:,2));
TVandIndiffTotal(1,3) = sum(TVandIndiff(:,3));
TVandIndiffTotal(1,4) = sum(TVandIndiff(:,4));

end


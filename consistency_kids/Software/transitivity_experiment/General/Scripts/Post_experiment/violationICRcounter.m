function [ violation, violationTotal ] = violationICRcounter(type, leftOptionRank, rightOptionRank, choices )
% Author: Niree Kodaverdian

violationICE = zeros(21,1);

if type == 0.5
    for i = 1:21
        if (leftOptionRank(i) < rightOptionRank(i)) && (choices(i) == 1); % here: a higher tally score means the item is, in fact, revealed to be ranked higher
            violation(i,1) = 1;
        elseif (leftOptionRank(i) < rightOptionRank(i)) && (choices(i) == 0);
            violation(i,1) = 0.5;
        elseif (leftOptionRank(i) < rightOptionRank(i)) && (choices(i) == 2);
            violation(i,1) = 0;
        elseif (leftOptionRank(i) == rightOptionRank(i)) && (choices(i) == 1);
            violation(i,1) = 0.5;
        elseif (leftOptionRank(i) == rightOptionRank(i)) && (choices(i) == 0);
            violation(i,1) = 0;
        elseif (leftOptionRank(i) == rightOptionRank(i)) && (choices(i) == 2);
            violation(i,1) = 0.5;
        elseif (leftOptionRank(i) > rightOptionRank(i)) && (choices(i) == 1);
            violation(i,1) = 0;
        elseif (leftOptionRank(i) > rightOptionRank(i)) && (choices(i) == 0);
            violation(i,1) = 0.5;
        elseif (leftOptionRank(i) > rightOptionRank(i)) && (choices(i) == 2);
            violation(i,1) = 1;
        end
    end
    
elseif type == 1
    for i = 1:21
        if (leftOptionRank(i) < rightOptionRank(i)) && (choices(i) == 1); % here: a higher tally score means the item is, in fact, revealed to be ranked higher
            violation(i,1) = 1;
        elseif (leftOptionRank(i) < rightOptionRank(i)) && (choices(i) == 0);
            violation(i,1) = 1;
        elseif (leftOptionRank(i) < rightOptionRank(i)) && (choices(i) == 2);
            violation(i,1) = 0;
        elseif (leftOptionRank(i) == rightOptionRank(i)) && (choices(i) == 1);
            violation(i,1) = 1;
        elseif (leftOptionRank(i) == rightOptionRank(i)) && (choices(i) == 0);
            violation(i,1) = 0;
        elseif (leftOptionRank(i) == rightOptionRank(i)) && (choices(i) == 2);
            violation(i,1) = 1;
        elseif (leftOptionRank(i) > rightOptionRank(i)) && (choices(i) == 1);
            violation(i,1) = 0;
        elseif (leftOptionRank(i) > rightOptionRank(i)) && (choices(i) == 0);
            violation(i,1) = 1;
        elseif (leftOptionRank(i) > rightOptionRank(i)) && (choices(i) == 2);
            violation(i,1) = 1;
        end
    end
end

violationTotal = sum(violation);

end


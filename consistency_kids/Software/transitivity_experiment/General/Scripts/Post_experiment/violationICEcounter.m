function [ violationICE, violationTotal ] = violationICEcounter(type,leftOptionRank,rightOptionRank,choice)
% Author: Niree Kodaverdian

violationICE = zeros(21,1);

if type == 0.5 % if we are using half point violations as well as full point violations
    for i = 1:21
        if (leftOptionRank(i) > rightOptionRank(i)) && (choice(i) == 1); % if right option is ranked BETTER and chose left button, violation score is 1
            violationICE(i) = 1;
        elseif (leftOptionRank(i) > rightOptionRank(i)) && (choice(i) == 0); % if right option is ranked BETTER and chose indifference button, violation score is 0.5
            violationICE(i) = 0.5;
        elseif (leftOptionRank(i) > rightOptionRank(i)) && (choice(i) == 2); % if right option is ranked BETTER and chose right button, violation score is 0
            violationICE(i) = 0;
        elseif (leftOptionRank(i) == rightOptionRank(i)) && (choice(i) == 1); % if right and left options are ranked SAME and chose left button, violation score is 0.5
            violationICE(i) = 0.5;
        elseif (leftOptionRank(i) == rightOptionRank(i)) && (choice(i) == 0); % if right and left options are ranked SAME and chose indifference button, violation score is 0
            violationICE(i) = 0;
        elseif (leftOptionRank(i) == rightOptionRank(i)) && (choice(i) == 2); % if right and left options are ranked SAME and chose right button, violation score is 0.5
            violationICE(i) = 0.5;
        elseif (leftOptionRank(i) < rightOptionRank(i)) && (choice(i) == 1); % if right option is ranked WORSE and chose left button, violation score is 0
            violationICE(i) = 0;
        elseif (leftOptionRank(i) < rightOptionRank(i)) && (choice(i) == 0); % if right option is ranked WORSE and chose indifference button, violation score is 0.5
            violationICE(i) = 0.5;
        elseif (leftOptionRank(i) < rightOptionRank(i)) && (choice(i) == 2); % if right option ranked WORSE and chose right button, violation score is 1
            violationICE(i) = 1;
        end
    end
    
elseif type == 1 % if we are only using full point violations 
    for i = 1:21
        if (leftOptionRank(i) > rightOptionRank(i)) && (choice(i) == 1); % if right option is ranked BETTER and chose left button, violation score is 1
            violationICE(i) = 1;
        elseif (leftOptionRank(i) > rightOptionRank(i)) && (choice(i) == 0); % if right option is ranked BETTER and chose indifference button, violation score is 0.5
            violationICE(i) = 1;
        elseif (leftOptionRank(i) > rightOptionRank(i)) && (choice(i) == 2); % if right option is ranked BETTER and chose right button, violation score is 0
            violationICE(i) = 0;
        elseif (leftOptionRank(i) == rightOptionRank(i)) && (choice(i) == 1); % if right and left options are ranked SAME and chose left button, violation score is 0.5
            violationICE(i) = 1;
        elseif (leftOptionRank(i) == rightOptionRank(i)) && (choice(i) == 0); % if right and left options are ranked SAME and chose indifference button, violation score is 0
            violationICE(i) = 0;
        elseif (leftOptionRank(i) == rightOptionRank(i)) && (choice(i) == 2); % if right and left options are ranked SAME and chose right button, violation score is 0.5
            violationICE(i) = 1;
        elseif (leftOptionRank(i) < rightOptionRank(i)) && (choice(i) == 1); % if right option is ranked WORSE and chose left button, violation score is 0
            violationICE(i) = 0;
        elseif (leftOptionRank(i) < rightOptionRank(i)) && (choice(i) == 0); % if right option is ranked WORSE and chose indifference button, violation score is 0.5
            violationICE(i) = 1;
        elseif (leftOptionRank(i) < rightOptionRank(i)) && (choice(i) == 2); % if right option ranked WORSE and chose right button, violation score is 1
            violationICE(i) = 1;
        end
    end
end

    violationTotal = sum(violationICE);
    
end


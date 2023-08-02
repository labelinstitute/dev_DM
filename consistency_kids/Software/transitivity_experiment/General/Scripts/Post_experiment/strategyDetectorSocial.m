function [memax,othermax,summax,memaxOthermax,memaxOthermin,summaxMemax,summaxOthermax] = strategyDetectorSocial( set, choice )
% Author: Niree Kodaverdian

memax = zeros(21,1); % non-lexicographic heuristic of maximizing "me" amount
for i = 1:21
    meLeftOption = set(1,1,i);
    meRightOption = set(2,1,i);
    if (meLeftOption > meRightOption) && (choice(i) == 1);
        memax(i) = 1;
    elseif (meLeftOption < meRightOption) && (choice(i) == 2);
        memax(i) = 1;
    elseif (meLeftOption == meRightOption) && (choice(i) == 0);
        memax(i) = 1;
    else
        memax(i) = 0;
    end
end


othermax = zeros(21,1); % non-lexicographic heuristic of maximizing "other" amount
for i = 1:21
    otherLeftOption = set(1,2,i);
    otherRightOption = set(2,2,i);
    if (otherLeftOption > otherRightOption) && (choice(i) == 1);
        othermax(i) = 1;
    elseif (otherLeftOption < otherRightOption)&& (choice(i) == 2);
        othermax(i) = 1;
    elseif (otherLeftOption == otherRightOption) && (choice(i) == 0);
        othermax(i) = 1;
    else
        othermax(i) = 0;
    end
end


summax = zeros(21,1); % non-lexicographic heuristic of maximizing sum of "me" and "other" amounts
for i = 1:21
    meLeftOption = set(1,1,i);
    meRightOption = set(2,1,i);
    otherLeftOption = set(1,2,i);
    otherRightOption = set(2,2,i);
    sumLeftOptions = meLeftOption + otherLeftOption;
    sumRightOptions = meRightOption + otherRightOption;
    if (sumLeftOptions > sumRightOptions) && (choice(i) == 1);
        summax(i) = 1;
    elseif (sumLeftOptions < sumRightOptions) && (choice(i) == 2);
        summax(i) = 1;
    elseif (sumLeftOptions == sumRightOptions) && (choice(i) == 0);
        summax(i) = 1;
    else
        summax(i) = 0;
    end
end


memaxOthermax = zeros(21,1); % lexicographic heuristic of maximizing "me" amount then maximizing "other" amount
for i = 1:21
    meLeftOption = set(1,1,i);
    meRightOption = set(2,1,i);
    otherLeftOption = set(1,2,i);
    otherRightOption = set(2,2,i);
    if (meLeftOption > meRightOption) && (choice(i) == 1)
        memaxOthermax(i) = 1;
    elseif (meLeftOption < meRightOption) && (choice(i) == 2)
        memaxOthermax(i) = 1;
    elseif (meLeftOption == meRightOption) && (otherLeftOption > otherRightOption) && (choice(i) == 1) % if amounts are same for you, maximize what other receives
        memaxOthermax(i) = 1;
    elseif (meLeftOption == meRightOption) && (otherLeftOption < otherRightOption) && (choice(i) == 2)
        memaxOthermax(i) = 1;
    else
        memaxOthermax(i) = 0;
    end
end


memaxOthermin = zeros(21,1); % lexicographic heuristic of maximizing "me" amount then minimizing "other" amount
for i = 1:21
    meLeftOption = set(1,1,i);
    meRightOption = set(2,1,i);
    otherLeftOption = set(1,2,i);
    otherRightOption = set(2,2,i);
    if (meLeftOption > meRightOption) && (choice(i) == 1)
        memaxOthermin(i) = 1;
    elseif (meLeftOption < meRightOption) && (choice(i) == 2)
        memaxOthermin(i) = 1;
    elseif (meLeftOption == meRightOption) && (otherLeftOption > otherRightOption) && (choice(i) == 2) % if amounts are same for you, minimize what other receives
        memaxOthermin(i) = 1;
    elseif (meLeftOption == meRightOption) && (otherLeftOption < otherRightOption) && (choice(i) == 1)
        memaxOthermin(i) = 1;
    else
        memaxOthermin(i) = 0;
    end
end


summaxMemax = zeros(21,1); % lexicographic heuristic of maximizing sum of "me" and "other" amounts then maximizing "me" amount
for i = 1:21
    meLeftOption = set(1,1,i);
    meRightOption = set(2,1,i);
    otherLeftOption = set(1,2,i);
    otherRightOption = set(2,2,i);
    if ((meLeftOption + otherLeftOption) > (meRightOption + otherRightOption)) && (choice(i) == 1)
        summaxMemax(i) = 1;
    elseif ((meLeftOption + otherLeftOption) < (meRightOption + otherRightOption)) && (choice(i) == 2)
        summaxMemax(i) = 1;
    elseif ((meLeftOption + otherLeftOption) == (meRightOption + otherRightOption)) && (meLeftOption > meRightOption) && (choice(i) == 1)
        summaxMemax(i) = 1;
    elseif ((meLeftOption + otherLeftOption) == (meRightOption + otherRightOption)) && (meLeftOption < meRightOption) && (choice(i) == 2)
        summaxMemax(i) = 1;
    else
        summaxMemax(i) = 0;
    end
end


summaxOthermax = zeros(21,1); % lexicographic heuristic of maximizing sum of "me" and "other" amounts then maximizing "other" amount
for i = 1:21
    meLeftOption = set(1,1,i);
    meRightOption = set(2,1,i);
    otherLeftOption = set(1,2,i);
    otherRightOption = set(2,2,i);
    if ((meLeftOption + otherLeftOption) > (meRightOption + otherRightOption)) && (choice(i) == 1)
        summaxOthermax(i) = 1;
    elseif ((meLeftOption + otherLeftOption) < (meRightOption + otherRightOption)) && (choice(i) == 2)
        summaxOthermax(i) = 1;
    elseif ((meLeftOption + otherLeftOption) == (meRightOption + otherRightOption)) && (otherLeftOption > otherRightOption) && (choice(i) == 1)
        summaxOthermax(i) = 1;
    elseif ((meLeftOption + otherLeftOption) == (meRightOption + otherRightOption)) && (otherLeftOption < otherRightOption) && (choice(i) == 2)
        summaxOthermax(i) = 1;
    else
        summaxOthermax(i) = 0;
    end
end

end


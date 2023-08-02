function [probmax,amountmax,expectmax,probmaxAmountmax,amountmaxProbmax,expectmaxAmountmax,expectmaxProbmax,expectmaxIndiff] = strategyDetectorRisk( set, choice)
% Author: Niree Kodaverdian

probmax = zeros(21,1); % non-lexicographic heuristic of maximizing probability
for i = 1:21
    probLeftOption = set(1,1,i);
    probRightOption = set(2,1,i);
    if (probLeftOption > probRightOption) && (choice(i) == 1)
        probmax(i) = 1;
    elseif (probLeftOption < probRightOption) && (choice(i) == 2)
        probmax(i) = 1;
    elseif (probLeftOption == probRightOption) && (choice(i) == 0)
        probmax(i) = 1;
    else
        probmax(i) = 0;
    end
end


amountmax = zeros(21,1); % non-lexicographic heuristic of maximizing amount
for i = 1:21
    amtLeftOption = set(1,2,i);
    amtRightOption = set(2,2,i);
    if (amtLeftOption > amtRightOption) && (choice(i) == 1)
        amountmax(i) = 1;
    elseif (amtLeftOption < amtRightOption) && (choice(i) == 2)
        amountmax(i) = 1;
    elseif (amtLeftOption == amtRightOption) && (choice(i) == 0)
        amountmax(i) = 1;
    else
        amountmax(i) = 0;
    end
end


expectmax = zeros(21,1); % non-lexicographic heuristic of maximizing expected amount
for i = 1:21
    probLeftOption = set(1,1,i);
    probRightOption = set(2,1,i);
    amtLeftOption = set(1,2,i);
    amtRightOption = set(2,2,i);
    expLeftOption = probLeftOption * amtLeftOption;
    expRightOption = probRightOption * amtRightOption;
    if (expLeftOption > expRightOption) && (choice(i) == 1)
        expectmax(i) = 1;
    elseif (expLeftOption < expRightOption) && (choice(i) == 2)
        expectmax(i) = 1;
    elseif (expLeftOption == expRightOption) && (choice(i) == 0)
        expectmax(i) = 1;
    else
        expectmax(i) = 0;
    end
end


probmaxAmountmax = zeros(21,1); % lexicographic heuristic of maximizing probability then amount
for i = 1:21
    probLeftOption = set(1,1,i);
    probRightOption = set(2,1,i);
    amtLeftOption = set(1,2,i);
    amtRightOption = set(2,2,i);
    if (probLeftOption > probRightOption) && (choice(i) == 1)
        probmaxAmountmax(i) = 1;
    elseif (probLeftOption < probRightOption) && (choice(i) == 2)
        probmaxAmountmax(i) = 1;
    elseif (probLeftOption == probRightOption) && (amtLeftOption > amtRightOption) && (choice(i) == 1)
        probmaxAmountmax(i) = 1;
    elseif (probLeftOption == probRightOption) && (amtLeftOption < amtRightOption) && (choice(i) == 2)
        probmaxAmountmax(i) = 1;
    else
        probmaxAmountmax(i) = 0;
    end
end


amountmaxProbmax = zeros(21,1); % lexicographic heuristic of maximizing amount then probability
for i = 1:21
    probLeftOption = set(1,1,i);
    probRightOption = set(2,1,i);
    amtLeftOption = set(1,2,i);
    amtRightOption = set(2,2,i);
    if (amtLeftOption > amtRightOption) && (choice(i) == 1)
        amountmaxProbmax(i) = 1;
    elseif (amtLeftOption < amtRightOption) && (choice(i) == 2)
        amountmaxProbmax(i) = 1;
    elseif (amtLeftOption == amtRightOption) && (probLeftOption > probRightOption) && (choice(i) == 1)
        amountmaxProbmax(i) = 1;
    elseif (amtLeftOption == amtRightOption) && (probLeftOption < probRightOption) && (choice(i) == 2)
        amountmaxProbmax(i) = 1;
    else
        amountmaxProbmax(i) = 0;
    end
end


expectmaxAmountmax = zeros(21,1); % lexicographic heuristic of maximizing expected amount then amount
for i = 1:21
    probLeftOption = set(1,1,i);
    probRightOption = set(2,1,i);
    amtLeftOption = set(1,2,i);
    amtRightOption = set(2,2,i);
    if ((probLeftOption * amtLeftOption) > (probRightOption * amtRightOption)) && (choice(i) == 1)
        expectmaxAmountmax(i) = 1;
    elseif ((probLeftOption * amtLeftOption) < (probRightOption * amtRightOption)) && (choice(i) == 2)
        expectmaxAmountmax(i) = 1;
    elseif ((probLeftOption * amtLeftOption) == (probRightOption * amtRightOption)) && (amtLeftOption > amtRightOption) && (choice(i) == 1)
        expectmaxAmountmax(i) = 1;
    elseif ((probLeftOption * amtLeftOption) == (probRightOption * amtRightOption)) && (amtLeftOption < amtRightOption) && (choice(i) == 2)
        expectmaxAmountmax(i) = 1;
    else
        expectmaxAmountmax(i) = 0;
    end
end


expectmaxProbmax = zeros(21,1); % lexicographic heuristic of maximizing expected amount then probability
for i = 1:21
    probLeftOption = set(1,1,i);
    probRightOption = set(2,1,i);
    amtLeftOption = set(1,2,i);
    amtRightOption = set(2,2,i);
    if ((probLeftOption * amtLeftOption) > (probRightOption * amtRightOption)) && (choice(i) == 1)
        expectmaxProbmax(i) = 1;
    elseif ((probLeftOption * amtLeftOption) < (probRightOption * amtRightOption)) && (choice(i) == 2)
        expectmaxProbmax(i) = 1;
    elseif ((probLeftOption * amtLeftOption) == (probRightOption * amtRightOption)) && (probLeftOption > probRightOption) && (choice(i) == 1)
        expectmaxProbmax(i) = 1;
    elseif ((probLeftOption * amtLeftOption) == (probRightOption * amtRightOption)) && (probLeftOption < probRightOption) && (choice(i) == 2)
        expectmaxProbmax(i) = 1;
    else
        expectmaxProbmax(i) = 0;
    end
end
    
expectmaxIndiff = zeros(21,1); % lexicographic heuristic of maximizing expected value then indifferent
for i = 1:21
    probLeftOption = set(1,1,i);
    probRightOption = set(2,1,i);
    amtLeftOption = set(1,2,i);
    amtRightOption = set(2,2,i);
    if ((probLeftOption * amtLeftOption) > (probRightOption * amtRightOption)) && (choice(i) == 1)
        expectmaxIndiff(i) = 1;
    elseif ((probLeftOption * amtLeftOption) < (probRightOption * amtRightOption)) && (choice(i) == 2)
        expectmaxIndiff(i) = 1;
    elseif ((probLeftOption * amtLeftOption) == (probRightOption * amtRightOption)) && (choice(i) == 0)
        expectmaxIndiff(i) = 1;
    else
        expectmaxIndiff(i) = 0;
    end
end

end



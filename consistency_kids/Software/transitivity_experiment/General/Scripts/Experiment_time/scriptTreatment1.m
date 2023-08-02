function [behavioralSecs,behavioralKey,behavioralTallyTotal,behavioralTallyYes,behavioralTallyIndf,behavioralTallyNo,catchMostOption,catchLeastOption] = scriptTreatment1( items, flipLR, input, treat1Order, Treatment1, treatmentStructure, w )
% Author: Niree Kodaverdian

tally(1:7) = 0; %this is for making sure all of the items have been selected before moving on to the next screen
yesTally(1:7) = 0;
noTally(1:7) = 0;
indfTally(1:7) = 0;

for i = 1:21;
    index = flipLR(i);
    %if index == 0 then 2nd coordinate of Treatment2 is 1 and if index == 1
    %then 2nd coordinate is 2 (for first item). if index == 0 then 2nd
    %coordinate of Treatment2 is 2 and if index == 1 then 2nd coordinate is
    %1 (for second item).
    buttonDown = 0;
    renderTreat1(items{Treatment1(treat1Order(i),(index*index + 1))},...
        items{Treatment1(treat1Order(i),(index+2-index*2))},w,0,buttonDown);
    [VBLTimestamp StimulusOnsetTime FlipTimestamp] = Screen('Flip',w);
    WaitSecs(0.75); %should be 0.75
    renderTreat1(items{Treatment1(treat1Order(i),(index*index + 1))},...
        items{Treatment1(treat1Order(i),(index+2-index*2))},w,1,buttonDown);
    Screen('Flip',w);
    [behavioralSecs, behavioralKey] = touchResponse(w, input, StimulusOnsetTime);
    if behavioralKey == 'f'
        buttonDown = 1;
        if index == 0
            tally(treatmentStructure(treat1Order(i),1)) = tally(treatmentStructure(treat1Order(i),1)) + 1; %what this says: if we have not flipped the left-right order of the options, and the subject has pressed the left button (selected left option), then add 1 to the tally of that option by selecting row corresponding to trial in treatmentStructure.mat and adding 1 to tally of 1st column option
            yesTally(treatmentStructure(treat1Order(i),1)) = yesTally(treatmentStructure(treat1Order(i),1)) + 1;
            noTally(treatmentStructure(treat1Order(i),2)) = noTally(treatmentStructure(treat1Order(i),2)) + 1;
        elseif index == 1
            tally(treatmentStructure(treat1Order(i),2)) = tally(treatmentStructure(treat1Order(i),2)) + 1;
            yesTally(treatmentStructure(treat1Order(i),2)) = yesTally(treatmentStructure(treat1Order(i),2)) + 1;
            noTally(treatmentStructure(treat1Order(i),1)) = noTally(treatmentStructure(treat1Order(i),1)) + 1;
        end
    elseif behavioralKey == 'b'
        buttonDown = 2;
        if index == 0
            tally(treatmentStructure(treat1Order(i),1)) = tally(treatmentStructure(treat1Order(i),1)) + 0.5; 
            tally(treatmentStructure(treat1Order(i),2)) = tally(treatmentStructure(treat1Order(i),2)) + 0.5; 
            indfTally(treatmentStructure(treat1Order(i),1)) = indfTally(treatmentStructure(treat1Order(i),1)) + 1;
            indfTally(treatmentStructure(treat1Order(i),2)) = indfTally(treatmentStructure(treat1Order(i),2)) + 1;
        elseif index == 1
            tally(treatmentStructure(treat1Order(i),1)) = tally(treatmentStructure(treat1Order(i),1)) + 0.5; 
            tally(treatmentStructure(treat1Order(i),2)) = tally(treatmentStructure(treat1Order(i),2)) + 0.5; 
            indfTally(treatmentStructure(treat1Order(i),1)) = indfTally(treatmentStructure(treat1Order(i),1)) + 1;
            indfTally(treatmentStructure(treat1Order(i),2)) = indfTally(treatmentStructure(treat1Order(i),2)) + 1;
        end
    elseif behavioralKey == 'j'
        buttonDown = 3;
        if index == 0
            tally(treatmentStructure(treat1Order(i),2)) = tally(treatmentStructure(treat1Order(i),2)) + 1;  
            yesTally(treatmentStructure(treat1Order(i),2)) = yesTally(treatmentStructure(treat1Order(i),2)) + 1;
            noTally(treatmentStructure(treat1Order(i),1)) = noTally(treatmentStructure(treat1Order(i),1)) + 1;
        elseif index == 1
            tally(treatmentStructure(treat1Order(i),1)) = tally(treatmentStructure(treat1Order(i),1)) + 1; 
            yesTally(treatmentStructure(treat1Order(i),1)) = yesTally(treatmentStructure(treat1Order(i),1)) + 1;
            noTally(treatmentStructure(treat1Order(i),2)) = noTally(treatmentStructure(treat1Order(i),2)) + 1;
        end
    end
    renderTreat1(items{Treatment1(treat1Order(i),(index*index + 1))},...
        items{Treatment1(treat1Order(i),(index+2-index*2))},w,1,buttonDown);
    Screen('Flip',w);
    WaitSecs(0.25);  %  SHOULD BE 0.25 amount of time that selected button with changed color is displayed
    behavioral.secs(i,1) = behavioralSecs;
    behavioral.key(i,1) = behavioralKey;
    behavioral.tally.total(1:7) = tally(1:7);
    behavioral.tally.yes(1:7) = yesTally(1:7);
    behavioral.tally.indf(1:7) = indfTally(1:7);
    behavioral.tally.no(1:7) = noTally(1:7);
    
    drawFixation(w); %drawFixation
    Screen('Flip',w);
    WaitSecs(0.25); %should be 0.25 ... amount of time fixation is up
end

% 22nd trial = catch trial
buttonDown = 0;
mostChosenItem = find(behavioral.tally.total == max(behavioral.tally.total));
mostIndfItem = find(behavioral.tally.indf(mostChosenItem) == max(behavioral.tally.indf(mostChosenItem)));
mostChosenItem = mostChosenItem(mostIndfItem);
leastChosenItem = find(behavioral.tally.total == min(behavioral.tally.total));
mostIndfItem = find(behavioral.tally.indf(leastChosenItem) == max(behavioral.tally.indf(leastChosenItem)));
leastChosenItem = leastChosenItem(mostIndfItem);

%need to do something about those that are indifferent for all choices ...
%end up with more than one max and more than one min and the program breaks
t = 0;
while t == 0;
    if flipLR(22) == 0
        firstItem = mostChosenItem(randi(length(mostChosenItem)));  %randomly choose among all those with max score from tally
        secondItem = leastChosenItem(randi(length(leastChosenItem)));  %randomly choose among all those with min score from tally
        if firstItem ~= secondItem
            t = t + 1;
        elseif firstItem == secondItem
            t = t + 0;
        end
    elseif flipLR(22) == 1
        firstItem = leastChosenItem(randi(length(leastChosenItem)));
        secondItem = mostChosenItem(randi(length(mostChosenItem)));
        if firstItem ~= secondItem
            t = t + 1;
        elseif firstItem == secondItem
            t = t + 0;
        end
    end 
end

renderTreat1(items{firstItem},items{secondItem},w,0,buttonDown);
[VBLTimestamp StimulusOnsetTime FlipTimestamp] = Screen('Flip',w);
WaitSecs(0.75); %should be 1
renderTreat1(items{firstItem},items{secondItem},w,1,buttonDown);
Screen('Flip',w);
[behavioralSecs, behavioralKey] = touchResponse(w, input, StimulusOnsetTime);
if behavioralKey == 'f'
    buttonDown = 1;
elseif behavioralKey == 'b'
    buttonDown = 2;
elseif behavioralKey == 'j'
    buttonDown = 3;
end
renderTreat1(items{firstItem},items{secondItem},w,1,buttonDown);
Screen('Flip',w);
behavioral.secs(22,1) = behavioralSecs;
behavioral.key(22,1) = behavioralKey;
WaitSecs(0.25); %should be 0.5

%this is for recording which item actually showed up as the "least" chosen
%and "most" chosen items for the catch (22nd) trial
if flipLR(22) == 0
    catchMostOption = firstItem;
    catchLeastOption = secondItem;
elseif flipLR(22) == 1
    catchMostOption = secondItem;
    catchLeastOption = firstItem;
end

behavioralSecs = behavioral.secs;
behavioralKey = behavioral.key;
behavioralTallyTotal = behavioral.tally.total;
behavioralTallyYes = behavioral.tally.yes;
behavioralTallyIndf = behavioral.tally.indf;
behavioralTallyNo = behavioral.tally.no;


end


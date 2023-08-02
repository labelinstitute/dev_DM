function [behavioralSecs,behavioralKey,behavioralTallyTotal,behavioralTallyYes,behavioralTallyIndf,behavioralTallyNo,catchMostOption,catchLeastOption] = scriptTreatment3( item, flipLR, input, treat3Order, setTreatment3, Treatment3, treatmentStructure, w )
% Author: Niree Kodaverdian

tally(1:7) = 0;
yesTally(1:7) = 0;
noTally(1:7) = 0;
indfTally(1:7) = 0;

for i = 1:21;
    index = flipLR(i);
    buttonDown = 0;
    renderTreat3(item, Treatment3((index*index + 1),1,(treat3Order(i))),... 
        Treatment3((index*index + 1),2,(treat3Order(i))),...
        Treatment3((index+2-index*2),1,(treat3Order(i))),...
        Treatment3((index+2-index*2),2,(treat3Order(i))),w,0, buttonDown);
    [VBLTimestamp StimulusOnsetTime FlipTimestamp] = Screen('Flip',w);
    WaitSecs(0.75); %should be 0.75
    renderTreat3(item, Treatment3((index*index + 1),1,(treat3Order(i))),...
        Treatment3((index*index + 1),2,(treat3Order(i))),...
        Treatment3((index+2-index*2),1,(treat3Order(i))),...
        Treatment3((index+2-index*2),2,(treat3Order(i))),w,1, buttonDown);
    Screen('Flip',w);
    [behavioralSecs, behavioralKey] = touchResponse(w, input, StimulusOnsetTime);
    if behavioralKey == 'f'
        buttonDown = 1;
        if index == 0
            tally(treatmentStructure(treat3Order(i),1)) = tally(treatmentStructure(treat3Order(i),1)) + 1; %what this says: if we have not flipped the left-right order of the options, and the subject has pressed the left button (selected left option), then add 1 to the tally of that option by selecting row corresponding to trial in treatmentStructure.mat and adding 1 to tally of 1st column option
            yesTally(treatmentStructure(treat3Order(i),1)) = yesTally(treatmentStructure(treat3Order(i),1)) + 1;
            noTally(treatmentStructure(treat3Order(i),2)) = noTally(treatmentStructure(treat3Order(i),2)) + 1;
        elseif index == 1
            tally(treatmentStructure(treat3Order(i),2)) = tally(treatmentStructure(treat3Order(i),2)) + 1;
            yesTally(treatmentStructure(treat3Order(i),2)) = yesTally(treatmentStructure(treat3Order(i),2)) + 1;
            noTally(treatmentStructure(treat3Order(i),1)) = noTally(treatmentStructure(treat3Order(i),1)) + 1;
        end
    elseif behavioralKey == 'b'
        buttonDown = 2;
        if index == 0
            tally(treatmentStructure(treat3Order(i),1)) = tally(treatmentStructure(treat3Order(i),1)) + 0.5; 
            tally(treatmentStructure(treat3Order(i),2)) = tally(treatmentStructure(treat3Order(i),2)) + 0.5; 
            indfTally(treatmentStructure(treat3Order(i),1)) = indfTally(treatmentStructure(treat3Order(i),1)) + 1;
            indfTally(treatmentStructure(treat3Order(i),2)) = indfTally(treatmentStructure(treat3Order(i),2)) + 1;
        elseif index == 1
            tally(treatmentStructure(treat3Order(i),1)) = tally(treatmentStructure(treat3Order(i),1)) + 0.5; 
            tally(treatmentStructure(treat3Order(i),2)) = tally(treatmentStructure(treat3Order(i),2)) + 0.5; 
            indfTally(treatmentStructure(treat3Order(i),1)) = indfTally(treatmentStructure(treat3Order(i),1)) + 1;
            indfTally(treatmentStructure(treat3Order(i),2)) = indfTally(treatmentStructure(treat3Order(i),2)) + 1;
        end
    elseif behavioralKey == 'j'
        buttonDown = 3;
        if index == 0
            tally(treatmentStructure(treat3Order(i),2)) = tally(treatmentStructure(treat3Order(i),2)) + 1;  
            yesTally(treatmentStructure(treat3Order(i),2)) = yesTally(treatmentStructure(treat3Order(i),2)) + 1;
            noTally(treatmentStructure(treat3Order(i),1)) = noTally(treatmentStructure(treat3Order(i),1)) + 1;
        elseif index == 1
            tally(treatmentStructure(treat3Order(i),1)) = tally(treatmentStructure(treat3Order(i),1)) + 1; 
            yesTally(treatmentStructure(treat3Order(i),1)) = yesTally(treatmentStructure(treat3Order(i),1)) + 1;
            noTally(treatmentStructure(treat3Order(i),2)) = noTally(treatmentStructure(treat3Order(i),2)) + 1;
        end
    end
    renderTreat3(item, Treatment3((index*index + 1),1,(treat3Order(i))),...
        Treatment3((index*index + 1),2,(treat3Order(i))),...
        Treatment3((index+2-index*2),1,(treat3Order(i))),...
        Treatment3((index+2-index*2),2,(treat3Order(i))),w,1, buttonDown);
    Screen('Flip',w);
    WaitSecs(0.25); 
    behavioral.secs(i,1) = behavioralSecs;
    behavioral.key(i,1) = behavioralKey;
    behavioral.tally.total(1:7) = tally(1:7);
    behavioral.tally.yes(1:7) = yesTally(1:7);
    behavioral.tally.indf(1:7) = indfTally(1:7);
    behavioral.tally.no(1:7) = noTally(1:7);
    
    Screen('Flip',w);
    WaitSecs(0.25); %should be 0.5
end

% 22nd trial = catch trial
buttonDown = 0;
mostChosenOption = find(behavioral.tally.total == max(behavioral.tally.total));
mostIndfOption = find(behavioral.tally.indf(mostChosenOption) == max(behavioral.tally.indf(mostChosenOption)));
mostChosenOption = mostChosenOption(mostIndfOption);
leastChosenOption = find(behavioral.tally.total == min(behavioral.tally.total));
mostIndfOption = find(behavioral.tally.indf(leastChosenOption) == max(behavioral.tally.indf(leastChosenOption)));
leastChosenOption = leastChosenOption(mostIndfOption);

t = 0;
while t == 0;
    if flipLR(22) == 0
        firstOption = mostChosenOption(randi(length(mostChosenOption)));  %randomly choose among all those with max score from tally
        secondOption = leastChosenOption(randi(length(leastChosenOption)));  %randomly choose among all those with min score from tally
        if firstOption ~= secondOption
            t = t + 1;
        elseif firstOption == secondOption
            t = t + 0;
        end
    elseif flipLR(22) == 1
        firstOption = leastChosenOption(randi(length(leastChosenOption)));
        secondOption = mostChosenOption(randi(length(mostChosenOption)));
        if firstOption ~= secondOption
            t = t + 1;
        elseif firstOption == secondOption
            t = t + 0;
        end
    end 
end

renderTreat3(item,setTreatment3(firstOption,1),setTreatment3(firstOption,2),...
    setTreatment3(secondOption,1),setTreatment3(secondOption,2),w,0,buttonDown);
[VBLTimestamp StimulusOnsetTime FlipTimestamp] = Screen('Flip',w);
WaitSecs(0.75); %should be 1
renderTreat3(item,setTreatment3(firstOption,1),setTreatment3(firstOption,2),...
    setTreatment3(secondOption,1),setTreatment3(secondOption,2),w,1,buttonDown);
Screen('Flip',w);
[behavioralSecs, behavioralKey] = touchResponse(w, input, StimulusOnsetTime);
if behavioralKey == 'f'
    buttonDown = 1;
elseif behavioralKey == 'b'
    buttonDown = 2;
elseif behavioralKey == 'j'
    buttonDown = 3;
end
renderTreat3(item,setTreatment3(firstOption,1),setTreatment3(firstOption,2),...
    setTreatment3(secondOption,1),setTreatment3(secondOption,2),w,1,buttonDown);
Screen('Flip',w);
behavioral.secs(22,1) = behavioralSecs;
behavioral.key(22,1) = behavioralKey;
WaitSecs(0.25); %should be 0.5

%this is for recording which item actually showed up as the "least" chosen
%and "most" chosen items for the catch (22nd) trial
if flipLR(22) == 0
    catchMostOption = firstOption;
    catchLeastOption = secondOption;
elseif flipLR(22) == 1
    catchMostOption = secondOption;
    catchLeastOption = firstOption;
end

behavioralSecs = behavioral.secs;
behavioralKey = behavioral.key;
behavioralTallyTotal = behavioral.tally.total;
behavioralTallyYes = behavioral.tally.yes;
behavioralTallyIndf = behavioral.tally.indf;
behavioralTallyNo = behavioral.tally.no;


end


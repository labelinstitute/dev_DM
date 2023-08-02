function [ output_args ] = masterScript( subjID, gender, gradeLevel,input)
% Author: Niree Kodaverdian 

% About the inputs...
% 1st input (subjID) requires a subject ID number assigned by experimenter

% 2nd input (gender) is either 'g' or 'b' for girl or boy subject,
% respectively

% 3rd input (gradeLevel) is either 'k', '1', '2', '3', '4', '5', or 'u' for
% kindergarten, 1st grade, 2nd grade, 3rd grade, 4th grade, 5th grade, or
% undergraduate student, respectively

% 4th input (input) is eithr 'm' if using computer mouse or laptop
% touchpad and 't' if using a touch-screen tablet

%% AGE NEUTRAL, GENDER-SPECIFIC VERSION
% if strcmp(gender,'g') == 1
%     addpath /Users/nireekodaverdian/Desktop/transitivity_experiment/Specific/GIRL_allAge
% elseif strcmp(gender,'b') == 1
%     addpath /Users/nireekodaverdian/Desktop/transitivity_experiment/Specific/BOY_allAge
% end

%% AGE- AND GENDER-SPECIFIC VERSION
% Depending on gender, add different image folder to the path so that
% subjects see their group-specific goods
if strcmp(gender,'g') == 1 && strcmp(gradeLevel,'3') == 1
    addpath /Users/nireekodaverdian/Desktop/transitivity_experiment/Specific/GIRL_3to5
elseif strcmp(gender,'g') == 1 && strcmp(gradeLevel,'4') == 1
    addpath /Users/nireekodaverdian/Desktop/transitivity_experiment/Specific/GIRL_3to5
elseif strcmp(gender,'g') == 1 && strcmp(gradeLevel,'5') == 1
    addpath /Users/nireekodaverdian/Desktop/transitivity_experiment/Specific/GIRL_3to5
elseif strcmp(gender,'g') == 1 && strcmp(gradeLevel,'k') == 1
    addpath /Users/nireekodaverdian/Desktop/transitivity_experiment/Specific/GIRL_Kto2
elseif strcmp(gender,'g') == 1 && strcmp(gradeLevel,'1') == 1
    addpath /Users/nireekodaverdian/Desktop/transitivity_experiment/Specific/GIRL_Kto2
elseif strcmp(gender,'g') == 1 && strcmp(gradeLevel,'2') == 1
    addpath /Users/nireekodaverdian/Desktop/transitivity_experiment/Specific/GIRL_Kto2
elseif strcmp(gender,'b') == 1 && strcmp(gradeLevel,'3') == 1
    addpath /Users/nireekodaverdian/Desktop/transitivity_experiment/Specific/BOY_3to5
elseif strcmp(gender,'b') == 1 && strcmp(gradeLevel,'4') == 1
    addpath /Users/nireekodaverdian/Desktop/transitivity_experiment/Specific/BOY_3to5
elseif strcmp(gender,'b') == 1 && strcmp(gradeLevel,'5') == 1
    addpath /Users/nireekodaverdian/Desktop/transitivity_experiment/Specific/BOY_3to5
elseif strcmp(gender,'b') == 1 && strcmp(gradeLevel,'k') == 1
    addpath /Users/nireekodaverdian/Desktop/transitivity_experiment/Specific/BOY_Kto2
elseif strcmp(gender,'b') == 1 && strcmp(gradeLevel,'1') == 1
    addpath /Users/nireekodaverdian/Desktop/transitivity_experiment/Specific/BOY_Kto2
elseif strcmp(gender,'b') == 1 && strcmp(gradeLevel,'2') == 1
    addpath /Users/nireekodaverdian/Desktop/transitivity_experiment/Specific/BOY_Kto2
elseif strcmp(gradeLevel,'u') == 1
    addpath /Users/nireekodaverdian/Desktop/transitivity_experiment/Specific/Undergrads
end


item1c = 1;
item2c = 2;
item3c = 3;
item4c = 4;
item5c = 5;
item6c = 6;
item7c = 7;

if input ~= 'k'; % on a tablet we need to disable the screen synch test becuase . . .  who knows
    Screen('preference', 'SkipSyncTests',1);
end


%% Items

items = [item1c item2c item3c item4c item5c item6c item7c];
numItems = length(items);

for i = 1:numItems
    v = genvarname(strcat('item', num2str(i)));
    eval([v '= imread(strcat(''Image'', num2str(items(i)), ''.jpg''));'])
end

items = {item1 item2 item3 item4 item5 item6 item7};


%% Load all of the task lists
load('Treatment1.mat');
load('Treatment2.mat');
load('Treatment3.mat');
load('treatmentStructure.mat');
load('setTreatment2.mat');
load('setTreatment3.mat');

%% **Design the task orders**

rng('shuffle'); % so that random numbers are different for each subject

treat1Order = [];
i = 1;
while i < 2;
    treat1Order = cat(2,treat1Order,randperm(length(Treatment1)));
    i = i + 1;
end

treat2Order = [];
i = 1;
while i < 2;
    treat2Order = cat(2,treat2Order,randperm(length(Treatment2)));
    i = i + 1;
end

treat3Order = [];
i = 1;
while i < 2;
    treat3Order = cat(2,treat3Order,randperm(length(Treatment3)));
    i = i + 1;
end

rank1Order = randperm(numItems);
rank2Order = randperm(numItems);
rank3Order = randperm(numItems);

long = length(cat(2,treat1Order,treat2Order,treat3Order));
flipLR = [zeros(1,ceil((long+3)/2)), ones(1,floor((long+3)/2))]; 
flipLR = flipLR(randperm(long+3));

%% Saving the settings

% these are the same across all runs, so no need to save them under that run's name in the settings file
settings.recordfolder = 'records';
settings.subjID = subjID;
settings.gender = gender;
settings.gradeLevel = gradeLevel;
settings.treat1.flipLR = flipLR(1:22); %if '0', don't flip. If '1' flip the left basker for the right basket
settings.treat2.flipLR = flipLR(23:44);
settings.treat3.flipLR = flipLR(45:66); %each treatment has 22 associated flip entries to accomodate for the 22nd (catch) trial
settings.items.item1 = items{1}; 
settings.items.item2 = items{2};
settings.items.item3 = items{3}; 
settings.items.item4 = items{4};
settings.items.item5 = items{5}; 
settings.items.item6 = items{6};
settings.items.item7 = items{7}; 
settings.treat1.rewardTrial = 0;
settings.treat2.rewardTrial = randi(21);
settings.treat3.rewardTrial = randi(21);

settings.treat1.Order = treat1Order;
settings.rank1.Order = rank1Order;
settings.treat2.Order = treat2Order;
settings.rank2.Order = rank2Order;
settings.treat3.Order = treat3Order;
settings.rank3.Order = rank3Order;

%settings.UT = UT;
settings.treat1.Set = Treatment1;
settings.treat2.Set = Treatment2;
settings.treat3.Set = Treatment3;


mkdir(settings.recordfolder);
% create the file name for this run of this subject
recordname = [settings.recordfolder '/' num2str(subjID) '_' datestr(now,'yyyymmddTHHMMSS') '.mat'];
% Save the settings (the results are saved later)
save (recordname, 'settings')

%% Set up the screen

screenNumber = max(Screen('Screens'));
[width height] = Screen('WindowSize', screenNumber);
w = Screen('OpenWindow', screenNumber,[],[],[],[],[],[],[]);

% Display "READY" -- stop sign for kids instead (otherwise drawStart script
% would be called)
drawStop(w);
Screen('Flip',w);
WaitSecs(.2)
touchHotSpot(w, width, height,input);

%% Treatment 1: Goods Treatment

Treatment1 = settings.treat1.Set;
treat1Order = settings.treat1.Order;
flipLR = settings.treat1.flipLR;
[behavioralSecs, behavioralKey, behavioralTallyTotal,behavioralTallyYes,behavioralTallyIndf,behavioralTallyNo, catchMostOption, catchLeastOption] = scriptTreatment1( items, flipLR, input, treat1Order, Treatment1, treatmentStructure, w);

    behavioral.treat1.secs = behavioralSecs;
    behavioral.treat1.key = behavioralKey;
    behavioral.treat1.tally.total = behavioralTallyTotal;
    behavioral.treat1.tally.yes = behavioralTallyYes;
    behavioral.treat1.tally.indf = behavioralTallyIndf;
    behavioral.treat1.tally.no = behavioralTallyNo;
    behavioral.catch1.mostOption = catchMostOption;
    behavioral.catch1.leastOption = catchLeastOption;

    save (recordname, 'behavioral', '-append')
    
% Display "STOP SIGN"
drawStop(w);
Screen('Flip',w);
WaitSecs(.2)
touchHotSpot(w, width, height,input);

% call on scriptRank1 for Treatment1' (prime) and use output for the next task
rankOrder = settings.rank1.Order;
[behavioralSecs, behavioralKey, ranked1st, ranked2nd, ranked3rd] = scriptRank(rankOrder, items, 1, w, width, height, input);

if strcmp(gradeLevel,'u') == 0
% For kids' version:
    behavioral.treat2.item = ranked2nd; %their second favorite item goes into Treatment 2 - Wheel game
    behavioral.treat2.itemRank = 2; 
    behavioral.treat3.item = ranked1st; %their first favorite item goes into Treatment 3 - Split game
    behavioral.treat3.itemRank = 1;
end

% For undergrads' version:
% will be using tokens for Treatment 2 and Treatment 3

behavioral.rank1.secs = behavioralSecs;
behavioral.rank1.key = behavioralKey;
reward.Today = ranked1st;

%% Reward for Treatment 1
% determining and recording the reward earned in Treatment 1

q = 0;

while q == 0;
    rewardTrial = randi(length(settings.treat1.Order));  %selects a random number between 1 and 21 since treatment 1 is 21-trials long
    if behavioral.treat1.key(rewardTrial) == 'f' && flipLR(rewardTrial) == 0 && Treatment1(treat1Order(rewardTrial),1) ~= reward.Today
        reward.Treat1Item = Treatment1(treat1Order(rewardTrial),1);
        q = q + 1;
    elseif behavioral.treat1.key(rewardTrial) == 'f' && flipLR(rewardTrial) == 1 && Treatment1(treat1Order(rewardTrial),2) ~= reward.Today
        reward.Treat1Item = Treatment1(treat1Order(rewardTrial),2);
        q = q + 1;
    elseif behavioral.treat1.key(rewardTrial) == 'j' && flipLR(rewardTrial) == 0 && Treatment1(treat1Order(rewardTrial),2) ~= reward.Today
        reward.Treat1Item = Treatment1(treat1Order(rewardTrial),2); %hasn't been flipped, you select right one, you were selecting second option as listed in treatment 1 set
        q = q + 1;
    elseif behavioral.treat1.key(rewardTrial) == 'j' && flipLR(rewardTrial) == 1 && Treatment1(treat1Order(rewardTrial),1) ~= reward.Today
        reward.Treat1Item = Treatment1(treat1Order(rewardTrial),1);
        q = q + 1;
    elseif behavioral.treat1.key(rewardTrial) == 'b'
        x = randi(2);
        if x == 1 && Treatment1(treat1Order(rewardTrial),1) ~= reward.Today
            reward.Treat1Item = Treatment1(treat1Order(rewardTrial),1);
            q = q + 1;
        elseif x == 2 && Treatment1(treat1Order(rewardTrial),2) ~= reward.Today
            reward.Treat1Item = Treatment1(treat1Order(rewardTrial),2);
            q = q + 1;
        end
    else q = q + 0;
    end
end

    settings.treat1.rewardTrial = rewardTrial;
    
    save (recordname, 'settings')
    save (recordname, 'reward', '-append')
    save (recordname, 'behavioral', '-append')

%% Transitive Reasoning: Animal Party!

% Display "STOP SIGN"
drawStop(w);
Screen('Flip',w);
WaitSecs(0.2)
touchHotSpot(w, width, height,input);

    [behavioralSecs, behavioralKey] = scriptAnimalParty(w, input, width, height);
    behavioral.party.secs = behavioralSecs;
    behavioral.party.key = behavioralKey;

    save (recordname, 'behavioral', '-append')

    %close and open screen
    Screen('CloseAll');
    screenNumber = max(Screen('Screens'));
    [width height] = Screen('WindowSize', screenNumber);
    w = Screen('OpenWindow', screenNumber,[],[],[],[],[],[],[]);

%% Treatment 3: Social Treatment

    Treatment3 = settings.treat3.Set;
    treat3Order = settings.treat3.Order;
    if strcmp(gradeLevel,'u') == 0
        item = items{behavioral.treat3.item};
    elseif strcmp(gradeLevel,'u') == 1  % this is only for undergrad group
        token2 = imread('token2.jpg');
        item = token2;
        behavioral.treat3.item = token2;
    end
    flipLR = settings.treat3.flipLR;
    
    % Display "STOP SIGN"
    drawStop(w);
    Screen('Flip',w);
    WaitSecs(.2)
    touchHotSpot(w, width, height,input);
    
    [behavioralSecs, behavioralKey, behavioralTallyTotal,behavioralTallyYes,behavioralTallyIndf,behavioralTallyNo, catchMostOption, catchLeastOption] = scriptTreatment3( item, flipLR, input, treat3Order, setTreatment3, Treatment3, treatmentStructure, w);
    
    behavioral.treat3.secs = behavioralSecs;
    behavioral.treat3.key = behavioralKey;
    behavioral.treat3.tally.total = behavioralTallyTotal;
    behavioral.treat3.tally.yes = behavioralTallyYes;
    behavioral.treat3.tally.indf = behavioralTallyIndf;
    behavioral.treat3.tally.no = behavioralTallyNo;
    behavioral.catch3.mostOption = catchMostOption;
    behavioral.catch3.leastOption = catchLeastOption;
    
    save (recordname, 'behavioral', '-append')
    
    % Display "STOP SIGN"
    drawStop(w);
    Screen('Flip',w);
    WaitSecs(.2)
    touchHotSpot(w, width, height,input);
    
    rankOrder = settings.rank3.Order;
    [behavioralSecs, behavioralKey] = scriptRank(rankOrder, item, 3, w, width, height, input);
    
    behavioral.rank3.secs = behavioralSecs;
    behavioral.rank3.key = behavioralKey;
    
    save (recordname, 'behavioral', '-append')
    
    %close and open screen
    Screen('CloseAll');
    screenNumber = max(Screen('Screens'));
    [width height] = Screen('WindowSize', screenNumber);
    w = Screen('OpenWindow', screenNumber,[],[],[],[],[],[],[]);
    
    %% Treatment 2: Risk Treatment
    
    % Display "STOP SIGN"
    drawStop(w);
    Screen('Flip',w);
    WaitSecs(.2)
    touchHotSpot(w, width, height,input);
    
    Treatment2 = settings.treat2.Set;
    treat2Order = settings.treat2.Order;
    if strcmp(gradeLevel,'u') == 0
        item = items{behavioral.treat2.item};
    elseif strcmp(gradeLevel,'u') == 1  % this is only for undergrad group
        token2 = imread('token2.jpg');
        item = token2;
        behavioral.treat2.item = token2;
    end
    flipLR = settings.treat2.flipLR;
    
    % Display "STOP SIGN"
    drawStop(w);
    Screen('Flip',w);
    WaitSecs(.2)
    touchHotSpot(w, width, height,input);
    
    [behavioralSecs, behavioralKey, behavioralTallyTotal,behavioralTallyYes,behavioralTallyIndf,behavioralTallyNo, catchMostOption, catchLeastOption] = scriptTreatment2( item, flipLR, input, treat2Order, setTreatment2, Treatment2, treatmentStructure, w);
    
    behavioral.treat2.secs = behavioralSecs;
    behavioral.treat2.key = behavioralKey;
    behavioral.treat2.tally.total = behavioralTallyTotal;
    behavioral.treat2.tally.yes = behavioralTallyYes;
    behavioral.treat2.tally.indf = behavioralTallyIndf;
    behavioral.treat2.tally.no = behavioralTallyNo;
    behavioral.catch2.mostOption = catchMostOption;
    behavioral.catch2.leastOption = catchLeastOption;
    
    save (recordname, 'behavioral', '-append')
    
    % Display "STOP SIGN"
    drawStop(w);
    Screen('Flip',w);
    WaitSecs(.2)
    touchHotSpot(w, width, height,input);
    
    rankOrder = settings.rank2.Order;
    [behavioralSecs, behavioralKey] = scriptRank(rankOrder, item, 2, w, width, height, input);
    
    behavioral.rank2.secs = behavioralSecs;
    behavioral.rank2.key = behavioralKey;
    
    save (recordname, 'behavioral', '-append')



%% Rewards for Treatment 2 and 3

% determining and recording the reward earned in Treatment 2
treat2rewardTrial = settings.treat2.rewardTrial;
reward.Treat2Item = behavioral.treat2.item;
flipLR = settings.treat2.flipLR;
if behavioral.treat2.key(treat2rewardTrial) == 'f' && flipLR(treat2rewardTrial) == 0
    reward.Treat2Amount = Treatment2(1,2,treat2Order(treat2rewardTrial));
    reward.Treat2Proba = Treatment2(1,1,treat2Order(treat2rewardTrial));
elseif behavioral.treat2.key(treat2rewardTrial) == 'f' && flipLR(treat2rewardTrial) == 1
    reward.Treat2Amount = Treatment2(2,2,treat2Order(treat2rewardTrial));
    reward.Treat2Proba = Treatment2(2,1,treat2Order(treat2rewardTrial));
elseif behavioral.treat2.key(treat2rewardTrial) == 'j' && flipLR(treat2rewardTrial) == 0
    reward.Treat2Amount = Treatment2(2,2,treat2Order(treat2rewardTrial));
    reward.Treat2Proba = Treatment2(2,1,treat2Order(treat2rewardTrial));
elseif behavioral.treat2.key(treat2rewardTrial) == 'j' && flipLR(treat2rewardTrial) == 1
    reward.Treat2Amount = Treatment2(1,2,treat2Order(treat2rewardTrial));
    reward.Treat2Proba = Treatment2(1,1,treat2Order(treat2rewardTrial));
elseif behavioral.treat2.key(treat2rewardTrial) == 'b'
    y = randi(2);
    if y == 1
        reward.Treat2Amount = Treatment2(1,2,treat2Order(treat2rewardTrial));
        reward.Treat2Proba = Treatment2(1,1,treat2Order(treat2rewardTrial));
    elseif y == 2
        reward.Treat2Amount = Treatment2(2,2,treat2Order(treat2rewardTrial));
        reward.Treat2Proba = Treatment2(2,1,treat2Order(treat2rewardTrial));
    end
end
% rewardrecordname = [settings.recordfolder '/' 'reward_' num2str(subjID) '_' 'treat2' '_' datestr(now,'yyyymmddTHHMMSS') '.mat'];
% save (rewardrecordname, 'reward');

% determining and recording the reward earned in Treatment 3
treat3rewardTrial = settings.treat3.rewardTrial;
reward.Treat3Item = behavioral.treat3.item;
flipLR = settings.treat3.flipLR;
if behavioral.treat3.key(treat3rewardTrial) == 'f' && flipLR(treat3rewardTrial) == 0
    reward.Treat3Me = Treatment3(1,1,treat3Order(treat3rewardTrial));
    reward.Treat3Other = Treatment3(1,2,treat3Order(treat3rewardTrial));
elseif behavioral.treat3.key(treat3rewardTrial) == 'f' && flipLR(treat3rewardTrial) == 1
    reward.Treat3Me = Treatment3(2,1,treat3Order(treat3rewardTrial));
    reward.Treat3Other = Treatment3(2,2,treat3Order(treat3rewardTrial));
elseif behavioral.treat3.key(treat3rewardTrial) == 'j' && flipLR(treat3rewardTrial) == 0
    reward.Treat3Me = Treatment3(2,1,treat3Order(treat3rewardTrial)); %hasn't been flipped, you select right one, you were selecting second option as listed in treatment 1 set
    reward.Treat3Other = Treatment3(2,2,treat3Order(treat3rewardTrial));
elseif behavioral.treat3.key(treat3rewardTrial) == 'j' && flipLR(treat3rewardTrial) == 1
    reward.Treat3Me = Treatment3(1,1,treat3Order(treat3rewardTrial));
    reward.Treat3Other = Treatment3(1,2,treat3Order(treat3rewardTrial));
elseif behavioral.treat3.key(treat3rewardTrial) == 'b'
    z = randi(2);
    if z == 1
        reward.Treat3Me = Treatment3(1,1,treat3Order(treat3rewardTrial));
        reward.Treat3Other = Treatment3(1,2,treat3Order(treat3rewardTrial));
    elseif z == 2
        reward.Treat3Me = Treatment3(2,1,treat3Order(treat3rewardTrial));
        reward.Treat3Other = Treatment3(2,2,treat3Order(treat3rewardTrial));
    end
end
% rewardrecordname = [settings.recordfolder '/' 'reward_' num2str(subjID) '_' 'treat3' '_' datestr(now,'yyyymmddTHHMMSS') '.mat'];
% save (rewardrecordname, 'reward');

save (recordname, 'reward', '-append')


%% 
drawStop(w);
Screen('Flip',w);
touchHotSpot(w, width, height, input);

rewardToday = reward.Today;
treat1Item = reward.Treat1Item;
treat2Item = reward.Treat2Item;
treat2Amount = reward.Treat2Amount;
treat3Item = reward.Treat3Item;
treat3Me = reward.Treat3Me;
treat3Other = reward.Treat3Other;

renderRewards(w,gradeLevel,items,rewardToday,treat1Item,treat3Item,treat3Me,treat3Other,treat2Item,treat2Amount);

Screen('Flip',w);
WaitSecs(3); %keep locked for 5 minutes(= 300 seconds)
touchHotSpot(w, width, height, input);
Screen('CloseAll');

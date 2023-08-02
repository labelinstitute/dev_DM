% Script for pre-processing raw data (output of 'masterScript' function), as found in 'records' folder

% Author: Niree Kodaverdian

% uncomment (default) below line AND lines 27-28 AND line 271 to run this script on new data 
cd('/Users/nireekodaverdian/Desktop/transitivity_experiment/records'); 

% uncomment below line AND lines 31-32 AND line 274 to run this script on kids' data from Brocas et al., 2016
% cd('/Users/nireekodaverdian/Desktop/transitivity_experiment/records_kids');

% uncomment below line AND lines 35-36 AND line 277 to run this script on undergrads' data from Brocas et al., 2016
% cd('/Users/nireekodaverdian/Desktop/transitivity_experiment/records_undergrads'); 


subjects = dir;                             % count all of the subjects in the folder
for i = 1:length(subjects)                  % make sure that you're looking at a subject folder
    if subjects(i).name(1) == '.';
        continue
    end
    
    load(subjects(i).name);
    cd ('../');                             % change directory, back out one step from 'records' into 'New_7item_Kids_transitivity'
    
    
    % uncomment (default) below line to run this script on new data (as well as line 7 AND line 271)
    mkdir('preProcessed');                  % create a folder called 'preProcessed'
    cd('preProcessed');                     % change directory to this new folder
    
    % uncomment below line to run this script on kids' data from Brocas etal., 2016 (as well as line 10 AND line 274)
    % mkdir('preProcessed_kids');                  % create a folder called 'preProcessed_kids', if it does not already exist 
    % cd('preProcessed_kids');                     % change directory to this folder
    
    % uncomment below line run this script on undergrads' data from Brocas et al., 2016 (as well as line 13 AND line 277)
    % mkdir('preProcessed_kids_undergrads');                  % create a folder called 'preProcessed_undergrads', if it does not already exist
    % cd('preProcessed_kids_undergrads');                     % change directory to this folder
    
    
    folderName = num2str(settings.subjID);  % 'folderName' for each subject will simply be their 'subjID'
    mkdir(folderName);                      % create a new folder in 'preProcessed' labeled 'folderName'
    cd(folderName);                         % change directory to this new folder
    
    %% Bring over the tasks from the subject data files.
    
    preProcessed.settings = settings;       % move over the 'settings' folder
    preProcessed.behavioral = behavioral;   % also, move over the 'behavioral' folder; no need to move over the 'rewards' folder.
    
    %% Reverse the right-left flips that were applied
    
    % for Treatment 1
    for press = 1: length(behavioral.treat1.key)
        if behavioral.treat1.key(press) == 'f';         % if subject has tapped the left button (saved as pressing the 'f' key)
            if settings.treat1.flipLR(press) == 0;      % and further, if for that choice the options were not flipped (i.e. left option was shown on left and right option was shown on right)
                treat1.choice(press) = 1;               % then, the subject chose what was initially the left, or 1st, option and we will record their choice as '1'
            elseif settings.treat1.flipLR(press) == 1;  % otherwise, if for that choice the options were indeed flipped (i.e. left option was shown on right and vice versa)
                treat1.choice(press) = 2;               % then, the subject chose what was initially the right, or 2nd, option and we will record their choice as '2'
            end
        elseif behavioral.treat1.key(press) == 'j';     % carry out the same logic in the case that subject tapped the right button (saved as pressing the 'j' key)
            if settings.treat1.flipLR(press) == 0;
                treat1.choice(press) = 2;
            elseif settings.treat1.flipLR(press) == 1;
                treat1.choice(press) = 1;
            end
        elseif behavioral.treat1.key(press) == 'b';     % if subject has tapped the middle button (saved as pressing the 'b' key)
            treat1.choice(press) = 0;                   % then considering a flip is irrelevant and we will save record their choice as '0'
        end
    end
    
    if (strcmp(folderName,'88226') ~= 1) && (strcmp(folderName,'88304') ~= 1);
        % for Treatment 2
        for press = 1: length(behavioral.treat2.key)
            if behavioral.treat2.key(press) == 'f';
                if settings.treat2.flipLR(press) == 0;
                    treat2.choice(press) = 1;
                elseif settings.treat2.flipLR(press) == 1;
                    treat2.choice(press) = 2;
                end
            elseif behavioral.treat2.key(press) == 'j';
                if settings.treat2.flipLR(press) == 0;
                    treat2.choice(press) = 2;
                elseif settings.treat2.flipLR(press) == 1;
                    treat2.choice(press) = 1;
                end
            elseif behavioral.treat2.key(press) == 'b';
                treat2.choice(press) = 0;
            end
        end
    end
    
    if strcmp(folderName,'88226') ~= 1;
        % for Treatment 3
        for press = 1: length(behavioral.treat3.key)
            if behavioral.treat3.key(press) == 'f';
                if settings.treat3.flipLR(press) == 0;
                    treat3.choice(press) = 1;
                elseif settings.treat3.flipLR(press) == 1;
                    treat3.choice(press) = 2;
                end
            elseif behavioral.treat3.key(press) == 'j';
                if settings.treat3.flipLR(press) == 0;
                    treat3.choice(press) = 2;
                elseif settings.treat3.flipLR(press) == 1;
                    treat3.choice(press) = 1;
                end
            elseif behavioral.treat3.key(press) == 'b';
                treat3.choice(press) = 0;
            end
        end
    end
    
    
    %% Reverse the shuffling of trials, as well as corresponding choices and response times
    
    long = 21;
    overallIndex = 1;
    treat1Index = 1;
    preProcessed.treat1.choices = zeros(21,1);
    preProcessed.treat1.responseTimes = zeros(21,1);
    preProcessed.treat1.order = zeros(21,1);
    
    
    if (strcmp(folderName, '88226') ~= 1) && (strcmp(folderName, '88304') ~= 1); % in the case that we are not dealing with either of these two subjects, as they are incomplete
        treat2Index = 1;
        treat3Index = 1;
        preProcessed.treat2.choices = zeros(21,1);
        preProcessed.treat2.responseTimes = zeros(21,1);
        preProcessed.treat2.order = zeros(21,1);
        preProcessed.treat3.choices = zeros(21,1);
        preProcessed.treat3.responseTimes = zeros(21,1);
        preProcessed.treat3.order = zeros(21,1);
        while overallIndex < 4
            if overallIndex == 1
                index = treat1Index;
                choices = preProcessed.treat1.choices;
                choice = treat1.choice;
                responseTimes = preProcessed.treat1.responseTimes;
                secs = preProcessed.behavioral.treat1.secs;
                order = preProcessed.treat1.order;
                reorder = preProcessed.settings.treat1.Order;
                for tn = 1:21
                    choices(reorder(index)) = choice(tn);
                    responseTimes(reorder(index)) = secs(tn);
                    order(reorder(index)) = tn;
                    index = index + 1;
                end
                choices(22) = choice(22);
                responseTimes(22) = secs(22);
                preProcessed.treat1.choices = choices;
                preProcessed.treat1.responseTimes = responseTimes;
                preProcessed.treat1.order = order;
            elseif overallIndex == 2
                index = treat2Index;
                choices = preProcessed.treat2.choices;
                choice = treat2.choice;
                responseTimes = preProcessed.treat2.responseTimes;
                secs = preProcessed.behavioral.treat2.secs;
                order = preProcessed.treat2.order;
                reorder = preProcessed.settings.treat2.Order;
                for tn = 1:21
                    choices(reorder(index)) = choice(tn);
                    responseTimes(reorder(index)) = secs(tn);
                    order(reorder(index)) = tn;
                    index = index + 1;
                end
                choices(22) = choice(22);
                responseTimes(22) = secs(22);
                preProcessed.treat2.choices = choices;
                preProcessed.treat2.responseTimes = responseTimes;
                preProcessed.treat2.order = order;
            elseif overallIndex == 3
                index = treat3Index;
                choices = preProcessed.treat3.choices;
                choice = treat3.choice;
                responseTimes = preProcessed.treat3.responseTimes;
                secs = preProcessed.behavioral.treat3.secs;
                order = preProcessed.treat3.order;
                reorder = preProcessed.settings.treat3.Order;
                for tn = 1:21
                    choices(reorder(index)) = choice(tn);
                    responseTimes(reorder(index)) = secs(tn);
                    order(reorder(index)) = tn;
                    index = index + 1;
                end
                choices(22) = choice(22);
                responseTimes(22) = secs(22);
                preProcessed.treat3.choices = choices;
                preProcessed.treat3.responseTimes = responseTimes;
                preProcessed.treat3.order = order;
            end
            overallIndex = overallIndex + 1;
        end
        
    elseif strcmp(folderName,'88226') == 1  % otherwise, if we are dealing with subject '88226' then only pre-process data from Treatment 1
        index = treat1Index;
        choices = preProcessed.treat1.choices;
        choice = treat1.choice;
        responseTimes = preProcessed.treat1.responseTimes;
        secs = preProcessed.behavioral.treat1.secs;
        order = preProcessed.treat1.order;
        reorder = preProcessed.settings.treat1.Order;
        for tn = 1:21
            choices(reorder(index)) = choice(tn);
            responseTimes(reorder(index)) = secs(tn);
            order(reorder(index)) = tn;
            index = index + 1;
        end
        choices(22) = choice(22);
        responseTimes(22) = secs(22);
        preProcessed.treat1.choices = choices;
        preProcessed.treat1.responseTimes = responseTimes;
        preProcessed.treat1.order = order;
        
    elseif strcmp(folderName,'88304') == 1  % otherwise, if we are dealing with subject '88304' then only pre-process data from Treatment 1 and Treatment 3 (remember that: Treatment 2 comes last in the experiment)
        treat3Index = 1;
        preProcessed.treat3.choices = zeros(21,1);
        preProcessed.treat3.responseTimes = zeros(21,1);
        preProcessed.treat3.order = zeros(21,1);
        while overallIndex < 3
            if overallIndex == 1
                index = treat1Index;
                choices = preProcessed.treat1.choices;
                choice = treat1.choice;
                responseTimes = preProcessed.treat1.responseTimes;
                secs = preProcessed.behavioral.treat1.secs;
                order = preProcessed.treat1.order;
                reorder = preProcessed.settings.treat1.Order;
                for tn = 1:21
                    choices(reorder(index)) = choice(tn);
                    responseTimes(reorder(index)) = secs(tn);
                    order(reorder(index)) = tn;
                    index = index + 1;
                end
                choices(22) = choice(22);
                responseTimes(22) = secs(22);
                preProcessed.treat1.choices = choices;
                preProcessed.treat1.responseTimes = responseTimes;
                preProcessed.treat1.order = order;
            elseif overallIndex == 2
                index = treat3Index;
                choices = preProcessed.treat3.choices;
                choice = treat3.choice;
                responseTimes = preProcessed.treat3.responseTimes;
                secs = preProcessed.behavioral.treat3.secs;
                order = preProcessed.treat3.order;
                reorder = preProcessed.settings.treat3.Order;
                for tn = 1:21
                    choices(reorder(index)) = choice(tn);
                    responseTimes(reorder(index)) = secs(tn);
                    order(reorder(index)) = tn;
                    index = index + 1;
                end
                choices(22) = choice(22);
                responseTimes(22) = secs(22);
                preProcessed.treat3.choices = choices;
                preProcessed.treat3.responseTimes = responseTimes;
                preProcessed.treat3.order = order;
            end
            overallIndex = overallIndex + 1;
            
        end
    end
    

    save('preProcessed.mat','preProcessed')
    
    
    % to run on new data
    cd('../../records');
    
    % to run on kids' data from Brocas et al., 2016
    % cd('../../records_kids');
    
    % to run on undergrads' data from Brocas et al., 2016
    % cd('../../records_undergrads');

    
    
    
    clearvars -except i subjects
end

cd('../');
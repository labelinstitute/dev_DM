function [behavioralSecs, behavioralKey] = touchResponse( w, input, StimulusOnsetTime)
% Author: Niree Kodaverdian

%   Detailed explanation goes hereif i > 1; % So don't wait on the first lap through
% first wait .2 seconds so that they have time to stop pressing the button.
screenNumber = max(Screen('Screens'));
[width height] = Screen('WindowSize', screenNumber);
centerw = width/2;
centerh = height/2;

if input  == 'k';% 'k' for for Keyboard
    [behavioral.secs, keyCode, behavioral.deltaSecs] = KbWait([], 3);
    
    %drawFixation
%     drawFixation(w);
%     WaitSecs(1);
    
    %If a key is pressed, record that key press in the behavioral record.
    if sum(keyCode) == 1;
        behavioral.key = KbName(keyCode);
    end
    
elseif input == 'm'; % 'm' is for mouse
    
i = 1; 

while i == 1
    [clicks,x,y,whichButton] = GetClicks(w,0); %Record where the click happened and which side it was on
    if (x >= width/40) && (x <= (width/40+width/10)) && (y >= height/40) && (y <= height/7);
        behavioral.key = 'f';
        behavioral.secs = GetSecs - StimulusOnsetTime;
        behavioralSecs = behavioral.secs;
        behavioralKey = behavioral.key;
        i = i + 1;
    elseif (x >= (centerw-width/20)) && (x <= (centerw+width/20)) && (y >= height/40) && (y <= height/7);
        behavioral.key = 'b';
        behavioral.secs = GetSecs - StimulusOnsetTime;
        behavioralSecs = behavioral.secs;
        behavioralKey = behavioral.key;
        i = i + 1;
    elseif (x >= (width-width/40-width/10)) && (x <= (width-width/40)) && (y >= height/40) && (y <= height/7);
        behavioral.key = 'j';
        behavioral.secs = GetSecs - StimulusOnsetTime;
        behavioralSecs = behavioral.secs;
        behavioralKey = behavioral.key;
        i = i + 1;
    else
        i = i + 0;
    end
    
end

elseif input == 't'; % 't' is for tablet %not sure if this is all coded correctly, need to try it out on tablet(s)
    
    i = 1;
    
    while i == 1
        SetMouse(width/2, height/2 ,w);
        while true;
            [x,y] = GetMouse(w); %Record where the click happened and which side it was on
            if x ~= width/2 && y ~= height/2;
                break;
            end
        end
        if (x >= width/40) && (x <= (width/40+width/10)) && (y >= height/40) && (y <= height/7);
            behavioral.key = 'f';
            behavioral.secs = GetSecs - StimulusOnsetTime;
            behavioralSecs = behavioral.secs;
            behavioralKey = behavioral.key;
            i = i + 1;
        elseif (x >= (centerw-width/20)) && (x <= (centerw+width/20)) && (y >= height/40) && (y <= height/7);
            behavioral.key = 'b';
            behavioral.secs = GetSecs - StimulusOnsetTime;
            behavioralSecs = behavioral.secs;
            behavioralKey = behavioral.key;
            i = i + 1;
        elseif (x >= (width-width/40-width/10)) && (x <= (width-width/40)) && (y >= height/40) && (y <= height/7);
            behavioral.key = 'j';
            behavioral.secs = GetSecs - StimulusOnsetTime;
            behavioralSecs = behavioral.secs;
            behavioralKey = behavioral.key;
            i = i + 1;
        else
            i = i + 0;
        end
        
    end
    
end
end


function [behavioralSecs, behavioralKey] = touchAnimalResponse(w, input, number, index, StimulusOnsetTime)
% Author: Niree Kodaverdian

    screenNumber = max(Screen('Screens'));
    [width height] = Screen('WindowSize', screenNumber);
    centerw = width/2;  % This the center width of the screen
    centerh = height/2;
    itemw = width/8;
    itemh = 1.5*itemw;
    eccen = itemw/3;
    
    ph1 = centerh - itemh/2;
    ph2 = centerh + itemh/2;
    
    % When there are 2 animals on screen (from left to right)
    pw2L1 = centerw - itemw/2 - eccen - itemw;
    pw2L2 = pw2L1 + itemw;
    pw2R1 = pw2L2 + eccen;
    pw2R2 = pw2R1 + itemw;
    pw2QMark1 = pw2R2 + eccen;
    pw2QMark2 = pw2QMark1 + itemw;
    
    % When there are 3 animals on screen (from left to right)
    pw3L1 = centerw - eccen/2 - itemw - eccen - itemw;
    pw3L2 = pw3L1 + itemw;
    pw3M1 = pw3L2 + eccen;
    pw3M2 = pw3M1 + itemw;
    pw3R1 = pw3M2 + eccen;
    pw3R2 = pw3R1 + itemw;
    pw3QMark1 = pw3R2 + eccen;
    pw3QMark2 = pw3QMark1 + itemw;
    
    % When there are 4 animals on screen (from left to right)
    pw4LL1 = centerw - itemw/2 - eccen - itemw - eccen - itemw;
    pw4LL2 = pw4LL1 + itemw;
    pw4LM1 = pw4LL2 + eccen;
    pw4LM2 = pw4LM1 + itemw;
    pw4RM1 = pw4LM2 + eccen;
    pw4RM2 = pw4RM1 + itemw;
    pw4RR1 = pw4RM2 + eccen;
    pw4RR2 = pw4RR1 + itemw;
    pw4QMark1 = pw4RR2 + eccen;
    pw4QMark2 = pw4QMark1 + itemw;
    
    if input == 'm'; % 'm' is for mouse
        if number(index) == 2
            i = 1;
            while i == 1
                [~,x,y,~] = GetClicks(w,0); %Record where the click happened and which side it was on
                if (x >= pw2L1) && (x <= pw2L2) && (y >= ph1) && (y <= ph2);
                    behavioral.secs = GetSecs - StimulusOnsetTime;
                    behavioral.key = '1';
                    behavioralSecs = behavioral.secs;
                    behavioralKey = behavioral.key;
                    i = i + 1;
                elseif (x >= pw2QMark1) && (x <= pw2QMark2) && (y >= ph1) && (y <= ph2);
                    behavioral.secs = GetSecs - StimulusOnsetTime;
                    behavioral.key = '0';
                    behavioralSecs = behavioral.secs;
                    behavioralKey = behavioral.key;
                    i = i + 1;
                elseif (x >= pw2R1) && (x <= pw2R2) && (y >= ph1) && (y <= ph2);
                    behavioral.secs = GetSecs - StimulusOnsetTime;
                    behavioral.key = '2';
                    behavioralSecs = behavioral.secs;
                    behavioralKey = behavioral.key;
                    i = i + 1;
                else
                    i = i + 0;
                end
            end
        elseif number(index) == 3
            i = 1;
            while i == 1
                [~,x,y,~] = GetClicks(w,0); %Record where the click happened and which side it was on
                if (x >= (pw3L1)) && (x <= (pw3L2)) && (y >= ph1) && (y <= ph2);
                    behavioral.secs = GetSecs - StimulusOnsetTime;
                    behavioral.key = '1';
                    behavioralSecs = behavioral.secs;
                    behavioralKey = behavioral.key;
                    i = i + 1;
                elseif (x >= (pw3QMark1)) && (x <= (pw3QMark2)) && (y >= ph1) && (y <= ph2);
                    behavioral.secs = GetSecs - StimulusOnsetTime;
                    behavioral.key = '0';
                    behavioralSecs = behavioral.secs;
                    behavioralKey = behavioral.key;
                    i = i + 1;
                elseif (x >= (pw3M1)) && (x <= (pw3M2)) && (y >= ph1) && (y <= ph2);
                    behavioral.secs = GetSecs - StimulusOnsetTime;
                    behavioral.key = '2';
                    behavioralSecs = behavioral.secs;
                    behavioralKey = behavioral.key;
                    i = i + 1;
                elseif (x >= (pw3R1)) && (x <= (pw3R2)) && (y >= ph1) && (y <= ph2);
                    behavioral.secs = GetSecs - StimulusOnsetTime;
                    behavioral.key = '3';
                    behavioralSecs = behavioral.secs;
                    behavioralKey = behavioral.key;
                    i = i + 1;
                else
                    i = i + 0;
                end
            end
        elseif number(index) == 4
            i = 1;
            while i == 1
                [~,x,y,~] = GetClicks(w,0); %Record where the click happened and which side it was on
                if (x >= (pw4LL1)) && (x <= (pw4LL2)) && (y >= ph1) && (y <= ph2);
                    behavioral.secs = GetSecs - StimulusOnsetTime;
                    behavioral.key = '1';
                    behavioralSecs = behavioral.secs;
                    behavioralKey = behavioral.key;
                    i = i + 1;
                elseif (x >= (pw4LM1)) && (x <= (pw4LM2)) && (y >= ph1) && (y <= ph2);
                    behavioral.secs = GetSecs - StimulusOnsetTime;
                    behavioral.key = '2';
                    behavioralSecs = behavioral.secs;
                    behavioralKey = behavioral.key;
                    i = i + 1;
                elseif (x >= (pw4QMark1)) && (x <= (pw4QMark2)) && (y >= ph1) && (y <= ph2);
                    behavioral.secs = GetSecs - StimulusOnsetTime;
                    behavioral.key = '0';
                    behavioralSecs = behavioral.secs;
                    behavioralKey = behavioral.key;
                    i = i + 1;
                elseif (x >= (pw4RM1)) && (x <= (pw4RM2)) && (y >= ph1) && (y <= ph2);
                    behavioral.secs = GetSecs - StimulusOnsetTime;
                    behavioral.key = '3';
                    behavioralSecs = behavioral.secs;
                    behavioralKey = behavioral.key;
                    i = i + 1;
                elseif (x >= (pw4RR1)) && (x <= (pw4RR2)) && (y >= ph1) && (y <= ph2);
                    behavioral.secs = GetSecs - StimulusOnsetTime;
                    behavioral.key = '4';
                    behavioralSecs = behavioral.secs;
                    behavioralKey = behavioral.key;
                    i = i + 1;
                else
                    i = i + 0;
                end
            end    
        end
        
    elseif input == 't'
        if number(index) == 2
            i = 1;
            while i == 1
                SetMouse(width/2, height/2 ,w);
                while true;
                    [x,y] = GetMouse(w); %Record where the click happened and which side it was on
                    if x ~= width/2 && y ~= height/2;
                        break;
                    end
                end
                if (x >= pw2L1) && (x <= (pw2L2)) && (y >= ph1) && (y <= ph2);
                    behavioral.secs = GetSecs - StimulusOnsetTime;
                    behavioral.key = '1';
                    behavioralSecs = behavioral.secs;
                    behavioralKey = behavioral.key;
                    i = i + 1;
                elseif (x >= (pw2QMark1)) && (x <= (pw2QMark2)) && (y >= ph1) && (y <= ph2);
                    behavioral.secs = GetSecs - StimulusOnsetTime;
                    behavioral.key = '0';
                    behavioralSecs = behavioral.secs;
                    behavioralKey = behavioral.key;
                    i = i + 1;
                elseif (x >= (pw2R1)) && (x <= (pw2R2)) && (y >= ph1) && (y <= ph2);
                    behavioral.secs = GetSecs - StimulusOnsetTime;
                    behavioral.key = '2';
                    behavioralSecs = behavioral.secs;
                    behavioralKey = behavioral.key;
                    i = i + 1;
                else
                    i = i + 0;
                end
            end
        elseif number(index) == 3
            i = 1;
            while i == 1
                SetMouse(width/2, height/2 ,w);
                while true;
                    [x,y] = GetMouse(w); %Record where the click happened and which side it was on
                    if x ~= width/2 && y ~= height/2;
                        break;
                    end
                end
                if (x >= pw3L1) && (x <= (pw3L2)) && (y >= ph1) && (y <= ph2);
                    behavioral.secs = GetSecs - StimulusOnsetTime;
                    behavioral.key = '1';
                    behavioralSecs = behavioral.secs;
                    behavioralKey = behavioral.key;
                    i = i + 1;
                elseif (x >= (pw3QMark1)) && (x <= (pw3QMark2)) && (y >= ph1) && (y <= ph2);
                    behavioral.secs = GetSecs - StimulusOnsetTime;
                    behavioral.key = '0';
                    behavioralSecs = behavioral.secs;
                    behavioralKey = behavioral.key;
                    i = i + 1;
                elseif (x >= (pw3M1)) && (x <= (pw3M2)) && (y >= ph1) && (y <= ph2);
                    behavioral.secs = GetSecs - StimulusOnsetTime;
                    behavioral.key = '2';
                    behavioralSecs = behavioral.secs;
                    behavioralKey = behavioral.key;
                    i = i + 1;
                elseif (x >= (pw3R1)) && (x <= (pw3R2)) && (y >= ph1) && (y <= ph2);
                    behavioral.secs = GetSecs - StimulusOnsetTime;
                    behavioral.key = '3';
                    behavioralSecs = behavioral.secs;
                    behavioralKey = behavioral.key;
                    i = i + 1;
                else
                    i = i + 0;
                end
            end
        elseif number(index) == 4
            i = 1;
            while i == 1
                SetMouse(width/2, height/2 ,w);
                while true;
                    [x,y] = GetMouse(w); %Record where the click happened and which side it was on
                    if x ~= width/2 && y ~= height/2;
                        break;
                    end
                end
                if (x >= pw4LL1) && (x <= (pw4LL2)) && (y >= ph1) && (y <= ph2);
                    behavioral.secs = GetSecs - StimulusOnsetTime;
                    behavioral.key = '1';
                    behavioralSecs = behavioral.secs;
                    behavioralKey = behavioral.key;
                    i = i + 1;
                elseif (x >= (pw4LM1)) && (x <= (pw4LM2)) && (y >= ph1) && (y <= ph2);
                    behavioral.secs = GetSecs - StimulusOnsetTime;
                    behavioral.key = '2';
                    behavioralSecs = behavioral.secs;
                    behavioralKey = behavioral.key;
                    i = i + 1;
                elseif (x >= (pw4QMark1)) && (x <= (pw4QMark2)) && (y >= ph1) && (y <= ph2);
                    behavioral.secs = GetSecs - StimulusOnsetTime;
                    behavioral.key = '0';
                    behavioralSecs = behavioral.secs;
                    behavioralKey = behavioral.key;
                    i = i + 1;
                elseif (x >= (pw4RM1)) && (x <= (pw4RM2)) && (y >= ph1) && (y <= ph2);
                    behavioral.secs = GetSecs - StimulusOnsetTime;
                    behavioral.key = '3';
                    behavioralSecs = behavioral.secs;
                    behavioralKey = behavioral.key;
                    i = i + 1;
                elseif (x >= (pw4RR1)) && (x <= (pw4RR2)) && (y >= ph1) && (y <= ph2);
                    behavioral.secs = GetSecs - StimulusOnsetTime;
                    behavioral.key = '4';
                    behavioralSecs = behavioral.secs;
                    behavioralKey = behavioral.key;
                    i = i + 1;
                else
                    i = i + 0;
                end
            end
        end
    end
end
        
        


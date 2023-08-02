function [behavioralSecs, behavioralKey, rankKey] = touchRanking( treatment, w, input, rankOrder, items)
% Author: Niree Kodaverdian

screenNumber = max(Screen('Screens'));
[width height] = Screen('WindowSize', screenNumber);
centerw = width/2;  % This the center width of the screen
centerh = height/2; % The center of the height of the screen

behavioralKey = zeros(7,1);
rankKey = zeros(7,1);
behavioralSecs = zeros(7,1);
positionVector = zeros(1,7);

i = 1;
indiffDown = 0;

while i <= 7;
    
    if input  == 'k'; % 'k' for for Keyboard
        [behavioral.secs, keyCode, behavioral.deltaSecs] = KbWait([], 3);
        
        %If a key is pressed, record that key press in the behavioral record.
        if sum(keyCode) == 1;
            behavioral.key = KbName(keyCode);
        end
    
        
    elseif input == 'm'; % 'm' is for mouse
        [~,x,y,~] = GetClicks(w,0);
        if x <= width/7 && (positionVector(1) == 0) && y >= height/7; %if is unclicked 
            if indiffDown == 0;
                rankKey(i) = i;
            elseif indiffDown == 1;
                rankKey(i) = rankKey(i-1);
            end
            behavioralKey(i) = 1;
            behavioralSecs(i) = now;
            positionVector(1) = 1;
            if treatment == 1
                renderFeedback(positionVector, w, input)
                renderRank1(rankOrder, items, w, 0, indiffDown, 'z');
            elseif treatment == 2
                renderFeedback(positionVector, w, input)
                renderRank2(rankOrder, items, w, 0, indiffDown, 'z');
            elseif treatment == 3
                renderFeedback(positionVector, w, input)
                renderRank3(rankOrder, items, w, 0, indiffDown, 'z');
            end
            i = i + 1;
        elseif x <= width/7 && (positionVector(1) == 1) && y >= height/7; %if is already clicked
            if indiffDown == 0;
                positionVector(1) = 0;
            behavioralKey(find(behavioralKey==1):i-1) = behavioralKey(find(behavioralKey==1)+1:i);
            behavioralSecs(find(behavioralKey==1):i-1) = behavioralSecs(find(behavioralKey==1)+1:i);
            rankKey(find(behavioralKey==1):i-1) = rankKey(find(behavioralKey==1)+1:i);
            if treatment == 1
                renderFeedback(positionVector, w, input)
                renderRank1(rankOrder, items, w, 0, indiffDown, 'z');
            elseif treatment == 2
                renderFeedback(positionVector, w, input)
                renderRank2(rankOrder, items, w, 0, indiffDown, 'z');
            elseif treatment == 3
                renderFeedback(positionVector, w, input)
                renderRank3(rankOrder, items, w, 0, indiffDown, 'z');
            end
            i = i - 1;
            elseif indiffDown == 1;
                positionVector(1) = 1;
            end
        elseif x > width/7 && x <= 2*width/7 && (positionVector(2) == 0) && y >= height/7;
            if indiffDown == 0;
                rankKey(i) = i;
            elseif indiffDown == 1;
                rankKey(i) = rankKey(i-1);
            end
            behavioralKey(i) = 2;
            behavioralSecs(i) = now;
            positionVector(2) = 1;
            if treatment == 1
                renderFeedback(positionVector, w, input)
                renderRank1(rankOrder, items, w, 0, indiffDown, 'z');
            elseif treatment == 2
                renderFeedback(positionVector, w, input)
                renderRank2(rankOrder, items, w, 0, indiffDown, 'z');
            elseif treatment == 3
                renderFeedback(positionVector, w, input)
                renderRank3(rankOrder, items, w, 0, indiffDown, 'z');
            end
            i = i + 1;
        elseif x > width/7 && x <= 2*width/7 && (positionVector(2) == 1) && y >= height/7;
            if indiffDown == 0;
                positionVector(2) = 0;
            behavioralKey(find(behavioralKey==2):i-1) = behavioralKey(find(behavioralKey==2)+1:i);
            behavioralSecs(find(behavioralKey==2):i-1) = behavioralSecs(find(behavioralKey==2)+1:i);
            rankKey(find(behavioralKey==2):i-1) = rankKey(find(behavioralKey==2)+1:i);
            if treatment == 1
                renderFeedback(positionVector, w, input)
                renderRank1(rankOrder, items, w, 0, indiffDown, 'z');
            elseif treatment == 2
                renderFeedback(positionVector, w, input)
                renderRank2(rankOrder, items, w, 0, indiffDown, 'z');
            elseif treatment == 3
                renderFeedback(positionVector, w, input)
                renderRank3(rankOrder, items, w, 0, indiffDown, 'z');
            end
            i = i - 1;
            elseif indiffDown == 1;
                positionVector(2) = 1;
            end
        elseif x > 2*width/7 && x <= 3*width/7 && (positionVector(3) == 0) && y >= height/7;
            if indiffDown == 0;
                rankKey(i) = i;
            elseif indiffDown == 1;
                rankKey(i) = rankKey(i-1);
            end
            behavioralKey(i) = 3;
            behavioralSecs(i) = now;
            positionVector(3) = 1;
            if treatment == 1
                renderFeedback(positionVector, w, input)
                renderRank1(rankOrder, items, w, 0, indiffDown, 'z');
            elseif treatment == 2
                renderFeedback(positionVector, w, input)
                renderRank2(rankOrder, items, w, 0, indiffDown, 'z');
            elseif treatment == 3
                renderFeedback(positionVector, w, input)
                renderRank3(rankOrder, items, w, 0, indiffDown, 'z');
            end
            i = i + 1;
        elseif x > 2*width/7 && x <= 3*width/7 && (positionVector(3) == 1) && y >= height/7;
            if indiffDown == 0;
                positionVector(3) = 0;
            behavioralKey(find(behavioralKey==3):i-1) = behavioralKey(find(behavioralKey==3)+1:i);
            behavioralSecs(find(behavioralKey==3):i-1) = behavioralSecs(find(behavioralKey==3)+1:i);
            rankKey(find(behavioralKey==3):i-1) = rankKey(find(behavioralKey==3)+1:i);
            if treatment == 1
                renderFeedback(positionVector, w, input)
                renderRank1(rankOrder, items, w, 0, indiffDown, 'z');
            elseif treatment == 2
                renderFeedback(positionVector, w, input)
                renderRank2(rankOrder, items, w, 0, indiffDown, 'z');
            elseif treatment == 3
                renderFeedback(positionVector, w, input)
                renderRank3(rankOrder, items, w, 0, indiffDown, 'z');
            end
            i = i - 1;
            elseif indiffDown == 1;
                positionVector(3) = 1;
            end
        elseif x > 3*width/7 && x <= 4*width/7 && (positionVector(4) == 0) && y >= height/7;
            if indiffDown == 0;
                rankKey(i) = i;
            elseif indiffDown == 1;
                rankKey(i) = rankKey(i-1);
            end
            behavioralKey(i) = 4;
            behavioralSecs(i) = now;
            positionVector(4) = 1;
            if treatment == 1
                renderFeedback(positionVector, w, input)
                renderRank1(rankOrder, items, w, 0, indiffDown, 'z');
            elseif treatment == 2
                renderFeedback(positionVector, w, input)
                renderRank2(rankOrder, items, w, 0, indiffDown, 'z');
            elseif treatment == 3
                renderFeedback(positionVector, w, input)
                renderRank3(rankOrder, items, w, 0, indiffDown, 'z');
            end
            i = i + 1;
        elseif x > 3*width/7 && x <= 4*width/7 && (positionVector(4) == 1) && y >= height/7;
            if indiffDown == 0;
                positionVector(4) = 0;
            behavioralKey(find(behavioralKey==4):i-1) = behavioralKey(find(behavioralKey==4)+1:i);
            behavioralSecs(find(behavioralKey==4):i-1) = behavioralSecs(find(behavioralKey==4)+1:i);
            rankKey(find(behavioralKey==4):i-1) = rankKey(find(behavioralKey==4)+1:i);
            if treatment == 1
                renderFeedback(positionVector, w, input)
                renderRank1(rankOrder, items, w, 0, indiffDown, 'z');
            elseif treatment == 2
                renderFeedback(positionVector, w, input)
                renderRank2(rankOrder, items, w, 0, indiffDown, 'z');
            elseif treatment == 3
                renderFeedback(positionVector, w, input)
                renderRank3(rankOrder, items, w, 0, indiffDown, 'z');
            end
            i = i - 1;
            elseif indiffDown == 1;
                positionVector(4) = 1;
            end
        elseif x > 4*width/7 && x <= 5*width/7 && (positionVector(5) == 0) && y >= height/7;
            if indiffDown == 0;
                rankKey(i) = i;
            elseif indiffDown == 1;
                rankKey(i) = rankKey(i-1);
            end
            behavioralKey(i) = 5;
            behavioralSecs(i) = now;
            positionVector(5) = 1;
            if treatment == 1
                renderFeedback(positionVector, w, input)
                renderRank1(rankOrder, items, w, 0, indiffDown, 'z');
            elseif treatment == 2
                renderFeedback(positionVector, w, input)
                renderRank2(rankOrder, items, w, 0, indiffDown, 'z');
            elseif treatment == 3
                renderFeedback(positionVector, w, input)
                renderRank3(rankOrder, items, w, 0, indiffDown, 'z');
            end
            i = i + 1;
        elseif x > 4*width/7 && x <= 5*width/7 && (positionVector(5) == 1) && y >= height/7;
            if indiffDown == 0;
                positionVector(5) = 0;
            behavioralKey(find(behavioralKey==5):i-1) = behavioralKey(find(behavioralKey==5)+1:i);
            behavioralSecs(find(behavioralKey==5):i-1) = behavioralSecs(find(behavioralKey==5)+1:i);
            rankKey(find(behavioralKey==5):i-1) = rankKey(find(behavioralKey==5)+1:i);
            if treatment == 1
                renderFeedback(positionVector, w, input)
                renderRank1(rankOrder, items, w, 0, indiffDown, 'z');
            elseif treatment == 2
                renderFeedback(positionVector, w, input)
                renderRank2(rankOrder, items, w, 0, indiffDown, 'z');
            elseif treatment == 3
                renderFeedback(positionVector, w, input)
                renderRank3(rankOrder, items, w, 0, indiffDown, 'z');
            end
            i = i - 1;
            elseif indiffDown == 1;
                positionVector(5) = 1;
            end
        elseif x > 5*width/7 && x <= 6*width/7 && (positionVector(6) == 0) && y >= height/7;
            if indiffDown == 0;
                rankKey(i) = i;
            elseif indiffDown == 1;
                rankKey(i) = rankKey(i-1);
            end
            behavioralKey(i) = 6;
            behavioralSecs(i) = now;
            positionVector(6) = 1;
            if treatment == 1
                renderFeedback(positionVector, w, input)
                renderRank1(rankOrder, items, w, 0, indiffDown, 'z');
            elseif treatment == 2
                renderFeedback(positionVector, w, input)
                renderRank2(rankOrder, items, w, 0, indiffDown, 'z');
            elseif treatment == 3
                renderFeedback(positionVector, w, input)
                renderRank3(rankOrder, items, w, 0, indiffDown, 'z');
            end
            i = i + 1;
        elseif x > 5*width/7 && x <= 6*width/7 && (positionVector(6) == 1) && y >= height/7;
            if indiffDown == 0;
                positionVector(6) = 0;
            behavioralKey(find(behavioralKey==6):i-1) = behavioralKey(find(behavioralKey==6)+1:i);
            behavioralSecs(find(behavioralKey==6):i-1) = behavioralSecs(find(behavioralKey==6)+1:i);
            rankKey(find(behavioralKey==6):i-1) = rankKey(find(behavioralKey==6)+1:i);
            if treatment == 1
                renderFeedback(positionVector, w, input)
                renderRank1(rankOrder, items, w, 0, indiffDown, 'z');
            elseif treatment == 2
                renderFeedback(positionVector, w, input)
                renderRank2(rankOrder, items, w, 0, indiffDown, 'z');
            elseif treatment == 3
                renderFeedback(positionVector, w, input)
                renderRank3(rankOrder, items, w, 0, indiffDown, 'z');
            end
            i = i - 1;
            elseif indiffDown == 1;
                positionVector(6) = 1;
            end
        elseif x > 6*width/7 && (positionVector(7) == 0) && y >= height/7;
            if indiffDown == 0;
                rankKey(i) = i;
            elseif indiffDown == 1;
                rankKey(i) = rankKey(i-1);
            end
            behavioralKey(i) = 7;
            behavioralSecs(i) = now;
            positionVector(7) = 1;
            if treatment == 1
                renderFeedback(positionVector, w, input)
                renderRank1(rankOrder, items, w, 0, indiffDown, 'z');
            elseif treatment == 2
                renderFeedback(positionVector, w, input)
                renderRank2(rankOrder, items, w, 0, indiffDown, 'z');
            elseif treatment == 3
                renderFeedback(positionVector, w, input)
                renderRank3(rankOrder, items, w, 0, indiffDown, 'z');
            end
            i = i + 1;
        elseif x > 6*width/7 && (positionVector(7) == 1) && y >= height/7;
            if indiffDown == 0;
                positionVector(7) = 0;
            behavioralKey(find(behavioralKey==7):i-1) = behavioralKey(find(behavioralKey==7)+1:i);
            behavioralSecs(find(behavioralKey==7):i-1) = behavioralSecs(find(behavioralKey==7)+1:i);
            rankKey(find(behavioralKey==7):i-1) = rankKey(find(behavioralKey==7)+1:i);
            if treatment == 1
                renderFeedback(positionVector, w, input)
                renderRank1(rankOrder, items, w, 0, indiffDown, 'z');
            elseif treatment == 2
                renderFeedback(positionVector, w, input)
                renderRank2(rankOrder, items, w, 0, indiffDown, 'z');
            elseif treatment == 3
                renderFeedback(positionVector, w, input)
                renderRank3(rankOrder, items, w, 0, indiffDown, 'z');
            end
            i = i - 1;
            elseif indiffDown == 1;
                positionVector(7) = 1;
            end
        else
            i = i + 0;
        end
        if treatment == 1
            if (i > 1) && (indiffDown == 0) && (x >= (centerw-width/20)) && (x<= (centerw+width/20)) && (y >= height/40) && (y <= height/7)
                indiffDown = indiffDown + 1;
                renderFeedback(positionVector, w, input)
                renderRank1(rankOrder, items, w, 0, indiffDown, 'z');
            elseif (indiffDown == 1) && (x >= (centerw-width/20)) && (x<= (centerw+width/20)) && (y >= height/40) && (y <= height/7)
                indiffDown = indiffDown - 1;
                renderFeedback(positionVector, w, input)
                renderRank1(rankOrder, items, w, 0, indiffDown, 'z');
            else
                indiffDown = indiffDown + 0;
                renderFeedback(positionVector, w, input)
                renderRank1(rankOrder, items, w, 0, indiffDown, 'z');
            end
        elseif treatment == 2
            if (i > 1) && (indiffDown == 0) && (x >= (centerw-width/20)) && (x<= (centerw+width/20)) && (y >= height/40) && (y <= height/7)
                indiffDown = indiffDown + 1;
                renderFeedback(positionVector, w, input)
                renderRank2(rankOrder, items, w, 0, indiffDown, 'z');
            elseif (indiffDown == 1) && (x >= (centerw-width/20)) && (x<= (centerw+width/20)) && (y >= height/40) && (y <= height/7)
                indiffDown = indiffDown - 1;
                renderFeedback(positionVector, w, input)
                renderRank2(rankOrder, items, w, 0, indiffDown, 'z');
            else
                indiffDown = indiffDown + 0;
                renderFeedback(positionVector, w, input)
                renderRank2(rankOrder, items, w, 0, indiffDown, 'z');
            end
        elseif treatment == 3
            if (i > 1) && (indiffDown == 0) && (x >= (centerw-width/20)) && (x<= (centerw+width/20)) && (y >= height/40) && (y <= height/7)
                indiffDown = indiffDown + 1;
                renderFeedback(positionVector, w, input)
                renderRank3(rankOrder, items, w, 0, indiffDown, 'z');
            elseif (indiffDown == 1) && (x >= (centerw-width/20)) && (x<= (centerw+width/20)) && (y >= height/40) && (y <= height/7)
                indiffDown = indiffDown - 1;
                renderFeedback(positionVector, w, input)
                renderRank3(rankOrder, items, w, 0, indiffDown, 'z');
            else
                indiffDown = indiffDown + 0;
                renderFeedback(positionVector, w, input)
                renderRank3(rankOrder, items, w, 0, indiffDown, 'z');
            end
        end
        Screen('Flip',w);
        
        
        
    elseif input == 't'; % 't' is for tablet
        SetMouse(width/2, height/2 ,w);
        while true;
            [x,y] = GetMouse(w); %Record where the click happened and which side it was on
            if x ~= width/2 && y ~= height/2;
                break;
            end
        end
        if x <= width/7 && (positionVector(1) == 0) && y >= height/7;
            if indiffDown == 0;
                rankKey(i) = i;
            elseif indiffDown == 1;
                rankKey(i) = rankKey(i-1);
            end
            behavioralKey(i) = 1;
            behavioralSecs(i) = now;
            positionVector(1) = 1;
            if treatment == 1
                renderFeedback(positionVector, w, input)
                renderRank1(rankOrder, items, w, 0, indiffDown, 'z');
            elseif treatment == 2
                renderFeedback(positionVector, w, input)
                renderRank2(rankOrder, items, w, 0, indiffDown, 'z');
            elseif treatment == 3
                renderFeedback(positionVector, w, input)
                renderRank3(rankOrder, items, w, 0, indiffDown, 'z');
            end
            i = i + 1;
        elseif x <= width/7 && (positionVector(1) == 1) && y >= height/7;
            if indiffDown == 0;
                positionVector(1) = 0;
            behavioralKey(find(behavioralKey==1):i-1) = behavioralKey(find(behavioralKey==1)+1:i);
            behavioralSecs(find(behavioralKey==1):i-1) = behavioralSecs(find(behavioralKey==1)+1:i);
            rankKey(find(behavioralKey==1):i-1) = rankKey(find(behavioralKey==1)+1:i);
            if treatment == 1
                renderFeedback(positionVector, w, input)
                renderRank1(rankOrder, items, w, 0, indiffDown, 'z');
            elseif treatment == 2
                renderFeedback(positionVector, w, input)
                renderRank2(rankOrder, items, w, 0, indiffDown, 'z');
            elseif treatment == 3
                renderFeedback(positionVector, w, input)
                renderRank3(rankOrder, items, w, 0, indiffDown, 'z');
            end
            i = i - 1;
            elseif indiffDown == 1;
                positionVector(1) = 1;
            end
        elseif x > width/7 && x <= 2*width/7 && (positionVector(2) == 0) && y >= height/7;
            if indiffDown == 0;
                rankKey(i) = i;
            elseif indiffDown == 1;
                rankKey(i) = rankKey(i-1);
            end
            behavioralKey(i) = 2;
            behavioralSecs(i) = now;
            positionVector(2) = 1;
            if treatment == 1
                renderFeedback(positionVector, w, input)
                renderRank1(rankOrder, items, w, 0, indiffDown, 'z');
            elseif treatment == 2
                renderFeedback(positionVector, w, input)
                renderRank2(rankOrder, items, w, 0, indiffDown, 'z');
            elseif treatment == 3
                renderFeedback(positionVector, w, input)
                renderRank3(rankOrder, items, w, 0, indiffDown, 'z');
            end
            i = i + 1;
        elseif x > width/7 && x <= 2*width/7 && (positionVector(2) == 1) && y >= height/7;
            if indiffDown == 0;
                positionVector(2) = 0;
            behavioralKey(find(behavioralKey==2):i-1) = behavioralKey(find(behavioralKey==2)+1:i);
            behavioralSecs(find(behavioralKey==2):i-1) = behavioralSecs(find(behavioralKey==2)+1:i);
            rankKey(find(behavioralKey==2):i-1) = rankKey(find(behavioralKey==2)+1:i);
            if treatment == 1
                renderFeedback(positionVector, w, input)
                renderRank1(rankOrder, items, w, 0, indiffDown, 'z');
            elseif treatment == 2
                renderFeedback(positionVector, w, input)
                renderRank2(rankOrder, items, w, 0, indiffDown, 'z');
            elseif treatment == 3
                renderFeedback(positionVector, w, input)
                renderRank3(rankOrder, items, w, 0, indiffDown, 'z');
            end
            i = i - 1;
            elseif indiffDown == 1;
                positionVector(2) = 1;
            end
        elseif x > 2*width/7 && x <= 3*width/7 && (positionVector(3) == 0) && y >= height/7;
            if indiffDown == 0;
                rankKey(i) = i;
            elseif indiffDown == 1;
                rankKey(i) = rankKey(i-1);
            end
            behavioralKey(i) = 3;
            behavioralSecs(i) = now;
            positionVector(3) = 1;
            if treatment == 1
                renderFeedback(positionVector, w, input)
                renderRank1(rankOrder, items, w, 0, indiffDown, 'z');
            elseif treatment == 2
                renderFeedback(positionVector, w, input)
                renderRank2(rankOrder, items, w, 0, indiffDown, 'z');
            elseif treatment == 3
                renderFeedback(positionVector, w, input)
                renderRank3(rankOrder, items, w, 0, indiffDown, 'z');
            end
            i = i + 1;
        elseif x > 2*width/7 && x <= 3*width/7 && (positionVector(3) == 1) && y >= height/7;
            if indiffDown == 0;
                positionVector(3) = 0;
            behavioralKey(find(behavioralKey==3):i-1) = behavioralKey(find(behavioralKey==3)+1:i);
            behavioralSecs(find(behavioralKey==3):i-1) = behavioralSecs(find(behavioralKey==3)+1:i);
            rankKey(find(behavioralKey==3):i-1) = rankKey(find(behavioralKey==3)+1:i);
            if treatment == 1
                renderFeedback(positionVector, w, input)
                renderRank1(rankOrder, items, w, 0, indiffDown, 'z');
            elseif treatment == 2
                renderFeedback(positionVector, w, input)
                renderRank2(rankOrder, items, w, 0, indiffDown, 'z');
            elseif treatment == 3
                renderFeedback(positionVector, w, input)
                renderRank3(rankOrder, items, w, 0, indiffDown, 'z');
            end
            i = i - 1;
            elseif indiffDown == 1;
                positionVector(3) = 1;
            end
        elseif x > 3*width/7 && x <= 4*width/7 && (positionVector(4) == 0) && y >= height/7;
            if indiffDown == 0;
                rankKey(i) = i;
            elseif indiffDown == 1;
                rankKey(i) = rankKey(i-1);
            end
            behavioralKey(i) = 4;
            behavioralSecs(i) = now;
            positionVector(4) = 1;
            if treatment == 1
                renderFeedback(positionVector, w, input)
                renderRank1(rankOrder, items, w, 0, indiffDown, 'z');
            elseif treatment == 2
                renderFeedback(positionVector, w, input)
                renderRank2(rankOrder, items, w, 0, indiffDown, 'z');
            elseif treatment == 3
                renderFeedback(positionVector, w, input)
                renderRank3(rankOrder, items, w, 0, indiffDown, 'z');
            end
            i = i + 1;
        elseif x > 3*width/7 && x <= 4*width/7 && (positionVector(4) == 1) && y >= height/7;
            if indiffDown == 0;
                positionVector(4) = 0;
            behavioralKey(find(behavioralKey==4):i-1) = behavioralKey(find(behavioralKey==4)+1:i);
            behavioralSecs(find(behavioralKey==4):i-1) = behavioralSecs(find(behavioralKey==4)+1:i);
            rankKey(find(behavioralKey==4):i-1) = rankKey(find(behavioralKey==4)+1:i);
            if treatment == 1
                renderFeedback(positionVector, w, input)
                renderRank1(rankOrder, items, w, 0, indiffDown, 'z');
            elseif treatment == 2
                renderFeedback(positionVector, w, input)
                renderRank2(rankOrder, items, w, 0, indiffDown, 'z');
            elseif treatment == 3
                renderFeedback(positionVector, w, input)
                renderRank3(rankOrder, items, w, 0, indiffDown, 'z');
            end
            i = i - 1;
            elseif indiffDown == 1;
                positionVector(4) = 1;
            end
        elseif x > 4*width/7 && x <= 5*width/7 && (positionVector(5) == 0) && y >= height/7;
            if indiffDown == 0;
                rankKey(i) = i;
            elseif indiffDown == 1;
                rankKey(i) = rankKey(i-1);
            end
            behavioralKey(i) = 5;
            behavioralSecs(i) = now;
            positionVector(5) = 1;
            if treatment == 1
                renderFeedback(positionVector, w, input)
                renderRank1(rankOrder, items, w, 0, indiffDown, 'z');
            elseif treatment == 2
                renderFeedback(positionVector, w, input)
                renderRank2(rankOrder, items, w, 0, indiffDown, 'z');
            elseif treatment == 3
                renderFeedback(positionVector, w, input)
                renderRank3(rankOrder, items, w, 0, indiffDown, 'z');
            end
            i = i + 1;
        elseif x > 4*width/7 && x <= 5*width/7 && (positionVector(5) == 1) && y >= height/7;
            if indiffDown == 0;
                positionVector(5) = 0;
            behavioralKey(find(behavioralKey==5):i-1) = behavioralKey(find(behavioralKey==5)+1:i);
            behavioralSecs(find(behavioralKey==5):i-1) = behavioralSecs(find(behavioralKey==5)+1:i);
            rankKey(find(behavioralKey==5):i-1) = rankKey(find(behavioralKey==5)+1:i);
            if treatment == 1
                renderFeedback(positionVector, w, input)
                renderRank1(rankOrder, items, w, 0, indiffDown, 'z');
            elseif treatment == 2
                renderFeedback(positionVector, w, input)
                renderRank2(rankOrder, items, w, 0, indiffDown, 'z');
            elseif treatment == 3
                renderFeedback(positionVector, w, input)
                renderRank3(rankOrder, items, w, 0, indiffDown, 'z');
            end
            i = i - 1;
            elseif indiffDown == 1;
                positionVector(5) = 1;
            end
        elseif x > 5*width/7 && x <= 6*width/7 && (positionVector(6) == 0) && y >= height/7;
            if indiffDown == 0;
                rankKey(i) = i;
            elseif indiffDown == 1;
                rankKey(i) = rankKey(i-1);
            end
            behavioralKey(i) = 6;
            behavioralSecs(i) = now;
            positionVector(6) = 1;
            if treatment == 1
                renderFeedback(positionVector, w, input)
                renderRank1(rankOrder, items, w, 0, indiffDown, 'z');
            elseif treatment == 2
                renderFeedback(positionVector, w, input)
                renderRank2(rankOrder, items, w, 0, indiffDown, 'z');
            elseif treatment == 3
                renderFeedback(positionVector, w, input)
                renderRank3(rankOrder, items, w, 0, indiffDown, 'z');
            end
            i = i + 1;
        elseif x > 5*width/7 && x <= 6*width/7 && (positionVector(6) == 1) && y >= height/7;
            if indiffDown == 0;
                positionVector(6) = 0;
            behavioralKey(find(behavioralKey==6):i-1) = behavioralKey(find(behavioralKey==6)+1:i);
            behavioralSecs(find(behavioralKey==6):i-1) = behavioralSecs(find(behavioralKey==6)+1:i);
            rankKey(find(behavioralKey==6):i-1) = rankKey(find(behavioralKey==6)+1:i);
            if treatment == 1
                renderFeedback(positionVector, w, input)
                renderRank1(rankOrder, items, w, 0, indiffDown, 'z');
            elseif treatment == 2
                renderFeedback(positionVector, w, input)
                renderRank2(rankOrder, items, w, 0, indiffDown, 'z');
            elseif treatment == 3
                renderFeedback(positionVector, w, input)
                renderRank3(rankOrder, items, w, 0, indiffDown, 'z');
            end
            i = i - 1;
            elseif indiffDown == 1;
                positionVector(6) = 1;
            end
        elseif x > 6*width/7 && (positionVector(7) == 0) && y >= height/7;
            if indiffDown == 0;
                rankKey(i) = i;
            elseif indiffDown == 1;
                rankKey(i) = rankKey(i-1);
            end
            behavioralKey(i) = 7;
            behavioralSecs(i) = now;
            positionVector(7) = 1;
            if treatment == 1
                renderFeedback(positionVector, w, input)
                renderRank1(rankOrder, items, w, 0, indiffDown, 'z');
            elseif treatment == 2
                renderFeedback(positionVector, w, input)
                renderRank2(rankOrder, items, w, 0, indiffDown, 'z');
            elseif treatment == 3
                renderFeedback(positionVector, w, input)
                renderRank3(rankOrder, items, w, 0, indiffDown, 'z');
            end
            i = i + 1;
        elseif x > 6*width/7 && (positionVector(7) == 1) && y >= height/7;
            if indiffDown == 0;
                positionVector(7) = 0;
            behavioralKey(find(behavioralKey==7):i-1) = behavioralKey(find(behavioralKey==7)+1:i);
            behavioralSecs(find(behavioralKey==7):i-1) = behavioralSecs(find(behavioralKey==7)+1:i);
            rankKey(find(behavioralKey==7):i-1) = rankKey(find(behavioralKey==7)+1:i);
            if treatment == 1
                renderFeedback(positionVector, w, input)
                renderRank1(rankOrder, items, w, 0, indiffDown, 'z');
            elseif treatment == 2
                renderFeedback(positionVector, w, input)
                renderRank2(rankOrder, items, w, 0, indiffDown, 'z');
            elseif treatment == 3
                renderFeedback(positionVector, w, input)
                renderRank3(rankOrder, items, w, 0, indiffDown, 'z');
            end
            i = i - 1;
            elseif indiffDown == 1;
                positionVector(7) = 1;
            end
        else
            i = i + 0;
        end
        if treatment == 1
            if (i > 1) && (indiffDown == 0) && (x >= (centerw-width/20)) && (x<= (centerw+width/20)) && (y >= height/40) && (y <= height/7)
                indiffDown = indiffDown + 1;
                renderFeedback(positionVector, w, input)
                renderRank1(rankOrder, items, w, 0, indiffDown, 'z');
            elseif (indiffDown == 1) && (x >= (centerw-width/20)) && (x<= (centerw+width/20)) && (y >= height/40) && (y <= height/7)
                indiffDown = indiffDown - 1;
                renderFeedback(positionVector, w, input)
                renderRank1(rankOrder, items, w, 0, indiffDown, 'z');
            else
                indiffDown = indiffDown + 0;
                renderFeedback(positionVector, w, input)
                renderRank1(rankOrder, items, w, 0, indiffDown, 'z');
            end
        elseif treatment == 2
            if (i > 1) && (indiffDown == 0) && (x >= (centerw-width/20)) && (x<= (centerw+width/20)) && (y >= height/40) && (y <= height/7)
                indiffDown = indiffDown + 1;
                renderFeedback(positionVector, w, input)
                renderRank2(rankOrder, items, w, 0, indiffDown, 'z');
            elseif (indiffDown == 1) && (x >= (centerw-width/20)) && (x<= (centerw+width/20)) && (y >= height/40) && (y <= height/7)
                indiffDown = indiffDown - 1;
                renderFeedback(positionVector, w, input)
                renderRank2(rankOrder, items, w, 0, indiffDown, 'z');
            else
                indiffDown = indiffDown + 0;
                renderFeedback(positionVector, w, input)
                renderRank2(rankOrder, items, w, 0, indiffDown, 'z');
            end
        elseif treatment == 3
            if (i > 1) && (indiffDown == 0) && (x >= (centerw-width/20)) && (x <= (centerw+width/20)) && (y >= height/40) && (y <= height/7)
                indiffDown = indiffDown + 1;
                renderFeedback(positionVector, w, input)
                renderRank3(rankOrder, items, w, 0, indiffDown, 'z');
            elseif (indiffDown == 1) && (x >= (centerw-width/20)) && (x<= (centerw+width/20)) && (y >= height/40) && (y <= height/7)
                indiffDown = indiffDown - 1;
                renderFeedback(positionVector, w, input)
                renderRank3(rankOrder, items, w, 0, indiffDown, 'z');
            else
                indiffDown = indiffDown + 0;
                renderFeedback(positionVector, w, input)
                renderRank3(rankOrder, items, w, 0, indiffDown, 'z');
            end
        end
        Screen('Flip',w);
    end
    
end

end


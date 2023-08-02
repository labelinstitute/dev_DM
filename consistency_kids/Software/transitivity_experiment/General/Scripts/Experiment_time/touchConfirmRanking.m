function [ confirmKey ] = touchConfirmRanking( w, input )
% Author: Niree Kodaverdian

screenNumber = max(Screen('Screens'));
[width height] = Screen('WindowSize', screenNumber);
centerw = width/2;
centerh = height/2;



if input == 'm'; % 'm' is for mouse
    i = 1;
    while i == 1;
        [clicks,x,y,whichButton] = GetClicks(w,0); %Record where the click happened and which side it was on
        if (x >= width/40) && (x <= (width/40+width/10)) && (y >= height/40) && (y <= height/7);
            confirmKey = 'n';
            i = i + 1;
        elseif (x >= (width-width/40-width/10)) && (x <= (width-width/40)) && (y >= height/40) && (y <= height/7);
            confirmKey = 'y';
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
            confirmKey = 'n';
            i = i + 1;
        elseif (x >= (width-width/40-width/10)) && (x <= (width-width/40)) && (y >= height/40) && (y <= height/7);
            confirmKey = 'y';
            i = i + 1;
        else
            i = i + 0;
        end
    end
    
end
end



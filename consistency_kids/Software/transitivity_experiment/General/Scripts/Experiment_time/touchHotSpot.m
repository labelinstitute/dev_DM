function [ output_args ] = touchHotSpot( w, width, height, input )
% Author: Niree Kodaverdian

hotSpotXLeft = width/2 - width/20;
hotSpotXRight = hotSpotXLeft + width/10;
hotSpotY = height - height/10;

m = 1;
while m == 1;
    if input == 'k';
        KbWait([], 3);
    elseif input == 'm';
        [~,x,y,~] = GetClicks(w,0);
        if (x >= hotSpotXLeft) && (y >= hotSpotY) && (x < hotSpotXRight)
            m = m + 1;
        else
            m = m + 0;
        end
    elseif input == 't';
        SetMouse(width/2, height/2 ,w);
        while true;
            [x,y] = GetMouse(w);
            if x ~= width/2 && y ~= height/2;
                break;
            end
        end
        if (x >= hotSpotXLeft) && (y >= hotSpotY) && (x < hotSpotXRight)
            m = m + 1;
        else
            m = m + 0;
        end
    end
    
end


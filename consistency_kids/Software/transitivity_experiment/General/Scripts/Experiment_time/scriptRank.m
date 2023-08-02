function [behavioralSecs, behavioralKey, ranked1st, ranked2nd, ranked3rd] = scriptRank(rankOrder, items, treatment, w, width, height, input )
% Author: Niree Kodaverdian

if treatment == 1;
    renderRank1(rankOrder, items, w, 0, 0, 'z');
    Screen('Flip',w);
    z = 0;
    while z == 0;
        [behavioralSecs, behavioralKey, rankKey] = touchRanking(1, w, input, rankOrder, items);
        newRankOrder(1:7) = rankOrder(behavioralKey(1:7));
        rankOrder = newRankOrder;
        renderRank1(rankOrder, items, w, 1, 0, 'z');
        Screen('Flip',w);
        [confirmKey] = touchConfirmRanking(w, input);
        if confirmKey == 'n';
            z = z + 0;
            renderRank1(rankOrder, items, w, 1, 0, 'n');
            Screen('Flip',w);
        elseif confirmKey == 'y';
            z = z + 1;
            renderRank1(rankOrder, items, w, 1, 0, 'y');
            Screen('Flip',w);
        end
    end
    ranked1st = rankOrder(1);
    ranked2nd = rankOrder(2);
    ranked3rd = rankOrder(3);
    behavioralKey = rankOrder;
    behavioralKey(2,1:7) = rankKey;
    
elseif treatment == 2;
    [width height] = renderKey(items, w);
    Screen('Flip',w);
    WaitSecs(1); %this should be at least 120 secs for the actual experiment
    touchHotSpot(w, width, height,input);
    renderRank2(rankOrder, items, w, 0, 0, 'z');
    Screen('Flip',w);
    z = 0;
    while z == 0;
        [behavioralSecs, behavioralKey, rankKey] = touchRanking(2, w, input, rankOrder, items);
        newRankOrder(1:7) = rankOrder(behavioralKey(1:7));
        rankOrder = newRankOrder;
        renderRank2(rankOrder, items, w, 1, 0, 'z');
        Screen('Flip',w);
        [confirmKey] = touchConfirmRanking(w, input);
        if confirmKey == 'n';
            z = z + 0;
            renderRank2(rankOrder, items, w, 1, 0, 'n');
            Screen('Flip',w);
        elseif confirmKey == 'y';
            z = z + 1;
            renderRank2(rankOrder, items, w, 1, 0, 'y');
            Screen('Flip',w);
        end
    end
    behavioralKey = rankOrder; 
    behavioralKey(2,1:7) = rankKey;
   
elseif treatment == 3;
    [width height] = renderKey(items, w);
    Screen('Flip',w);
    WaitSecs(1); %this should be at least 120 secs for the actual experiment
    touchHotSpot(w, width, height,input);
    renderRank3(rankOrder, items, w, 0, 0, 'z');
    Screen('Flip',w);
    z = 0;
    while z == 0;
        [behavioralSecs, behavioralKey, rankKey] = touchRanking(3, w, input, rankOrder, items);
        newRankOrder(1:7) = rankOrder(behavioralKey(1:7));
        rankOrder = newRankOrder;
        renderRank3(rankOrder, items, w, 1, 0, 'z');
        Screen('Flip',w);
        [confirmKey] = touchConfirmRanking(w, input);
        if confirmKey == 'n';
            z = z + 0;
            renderRank3(rankOrder, items, w, 1, 0, 'n');
            Screen('Flip',w);
        elseif confirmKey == 'y';
            z = z + 1;
            renderRank3(rankOrder, items, w, 1, 0, 'y');
            Screen('Flip',w);
        end
    end
    behavioralKey = rankOrder;
    behavioralKey(2,1:7) = rankKey;
    
end


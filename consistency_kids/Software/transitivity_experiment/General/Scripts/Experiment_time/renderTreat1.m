function [ output_args ] = renderTreat1( itema, itemb, w, responseTime, buttonDown)
% Author: Niree Kodaverdian

    screenNumber = max(Screen('Screens'));
    [width height] = Screen('WindowSize', screenNumber);
    black = imread('black.jpg');
    grey = imread('grey.jpg');
    lightGrey = imread('lightGrey.jpg');

    
    %% Make all of the textures
    itemat = Screen('MakeTexture',w,itema);
    itembt = Screen('MakeTexture',w,itemb); 
    blackt = Screen('MakeTexture',w,black);
    greyt = Screen('MakeTexture',w,grey);
    lightGreyt = Screen('MakeTexture',w,lightGrey);
    
    
    %% These are all of the position constants  

    centerw = width/2;  % This the center width of the screen
    centerh = height/2; % The center of the height of the screen
    eccen =   width/6;       % This is the eccentricity. Distance from the center to the right edge of the array
    itemw =   width/8;       % The width of one item in the array
    itemh =   1.5*itemw;% The height of one item in the array
    
    devLineHeight = height*.9;  % The height of the black box inthe middle of the screen
    devLineWidth  = 1;          % The width of the black box in the middle of the screen
    
    % Everything below here is coded in terms of the numbers above
    
    pwL1= centerw - eccen;
    pwL2= pwL1 - itemw;
    
    pwR1= centerw + eccen;
    pwR2= pwR1 + itemw;
    
    ph1= centerh - (itemh/2);
    ph2= ph1 + itemh;
    
% These are here so that the cat()'s will have something to grab on to.

    draw = [];
    leftPositions = [];
    topPositions = [];
    rightPositions = [];
    bottomPositions = [];

    % The line that divides the the screen in half
    draw = cat(1,draw,blackt);
    leftPositions = cat(2,leftPositions,    centerw - devLineWidth);
    topPositions = cat(2,topPositions,      centerh - devLineHeight/2);
    rightPositions = cat(2,rightPositions,  centerw + devLineWidth);
    bottomPositions = cat(2,bottomPositions,centerh + devLineHeight/2);
    
    % The response boxes
    
    if responseTime == 1
        if buttonDown ~= 1
            firstBox = lightGreyt;
        end
        if buttonDown == 1
            firstBox = greyt;
        end
        if buttonDown ~=2
            secondBox = lightGreyt;
        end
        if buttonDown == 2
            secondBox = greyt;
        end
        if buttonDown ~=3
            thirdBox = lightGreyt;
        end
        if buttonDown == 3
            thirdBox = greyt;
        end
        draw = cat(1,draw,firstBox);
        leftPositions = cat(2,leftPositions,    width/40);
        topPositions = cat(2,topPositions,      height/7);
        rightPositions = cat(2,rightPositions,  width/40+width/10);
        bottomPositions = cat(2,bottomPositions,height/40);
        
        draw = cat(1,draw,secondBox);
        leftPositions = cat(2,leftPositions,    centerw-width/20);
        topPositions = cat(2,topPositions,      height/7);
        rightPositions = cat(2,rightPositions,  centerw+width/20);
        bottomPositions = cat(2,bottomPositions,height/40);
        
        draw = cat(1,draw,thirdBox);
        leftPositions = cat(2,leftPositions,    width-width/40-width/10);
        topPositions = cat(2,topPositions,      height/7);
        rightPositions = cat(2,rightPositions,  width-width/40);
        bottomPositions = cat(2,bottomPositions,height/40);
    end
    

    % Left
    draw = cat(1,draw,itemat);
    leftPositions = cat(2,leftPositions,    pwL2);
    topPositions = cat(2,topPositions,       ph1);
    rightPositions = cat(2,rightPositions,  pwL1);
    bottomPositions = cat(2,bottomPositions, ph2);
    
    % Right
    draw = cat(1,draw,itembt);
    leftPositions = cat(2,leftPositions,    pwR1);
    topPositions = cat(2,topPositions,       ph1); 
    rightPositions = cat(2,rightPositions,  pwR2);
    bottomPositions = cat(2,bottomPositions, ph2);
    
    v = cat(1,leftPositions,topPositions,rightPositions,bottomPositions);

    Screen('DrawTextures',w,draw,[],v);
    
   

end


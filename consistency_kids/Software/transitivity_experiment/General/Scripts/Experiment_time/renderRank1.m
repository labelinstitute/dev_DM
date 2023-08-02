function [] = renderRank1(rankOrder, items, w, confirmTime, indiffDown, buttonDown)
% Author: Niree Kodaverdian

screenNumber = max(Screen('Screens'));
[width height] = Screen('WindowSize', screenNumber);
black = imread('black.jpg');
green = imread('green.jpg');
red = imread('red.jpg');
lightGreen = imread('lightGreen.jpg');
lightRed = imread('lightRed.jpg');
lightGrey = imread('lightGrey.jpg');
grey = imread('grey.jpg');

% Make all of the textures
blackt = Screen('MakeTexture',w,black);
greent = Screen('MakeTexture',w,green);
redt = Screen('MakeTexture',w,red);
lightGreent = Screen('MakeTexture',w,lightGreen);
lightRedt = Screen('MakeTexture',w,lightRed);
lightGreyt = Screen('MakeTexture',w,lightGrey);
greyt = Screen('MakeTexture',w,grey);

item1t = Screen('MakeTexture',w,items{1});
item2t = Screen('MakeTexture',w,items{2});
item3t = Screen('MakeTexture',w,items{3});
item4t = Screen('MakeTexture',w,items{4});
item5t = Screen('MakeTexture',w,items{5});
item6t = Screen('MakeTexture',w,items{6});
item7t = Screen('MakeTexture',w,items{7});

%% These are all of the position constants

centerw = width/2;  % This the center width of the screen
centerh = height/2; % The center of the height of the screen
itemw =   width/11;       % The width of one item in the array
itemh =   1.5*itemw;% The height of one item in the array
eccen =   itemw/4;       % This is the eccentricity. Distance from the center to the right edge of the array
devLineHeight = height*.9;  % The height of the black box inthe middle of the screen
devLineWidth  = 1;          % The width of the black box in the middle of the screen

% Everything below here is coded in terms of the numbers above

pwL7= eccen;
pwL6= eccen + itemw;
pwL5= pwL7 + width/7;
pwL4= pwL6 + width/7;
pwL3= pwL5 + width/7;
pwL2= pwL4 + width/7;
pwL1= pwL3 + width/7;

pwR1= pwL2 + width/7;
pwR2= pwL1 + width/7;
pwR3= pwR1 + width/7;
pwR4= pwR2 + width/7;
pwR5= pwR3 + width/7;
pwR6= pwR4 + width/7;
pwR7= pwR5 + width/7;

ph1= centerh - (itemh/2);
ph2= ph1 + itemh;

% These are here so that the cat()'s will have something to grab on to.

draw = [];
leftPositions = [];
topPositions = [];
rightPositions = [];
bottomPositions = [];

% The lines
%line1
draw = cat(1,draw,blackt);
leftPositions = cat(2,leftPositions,    width/7 - devLineWidth);
topPositions = cat(2,topPositions,      centerh - devLineHeight/2);
rightPositions = cat(2,rightPositions,  width/7 + devLineWidth);
bottomPositions = cat(2,bottomPositions,centerh + devLineHeight/2);

%line2
draw = cat(1,draw,blackt);
leftPositions = cat(2,leftPositions,    2*width/7 - devLineWidth);
topPositions = cat(2,topPositions,      centerh - devLineHeight/2);
rightPositions = cat(2,rightPositions,  2*width/7 + devLineWidth);
bottomPositions = cat(2,bottomPositions,centerh + devLineHeight/2);

%line3
draw = cat(1,draw,blackt);
leftPositions = cat(2,leftPositions,    3*width/7 - devLineWidth);
topPositions = cat(2,topPositions,      centerh - devLineHeight/2);
rightPositions = cat(2,rightPositions,  3*width/7 + devLineWidth);
bottomPositions = cat(2,bottomPositions,centerh + devLineHeight/2);

%line4
draw = cat(1,draw,blackt);
leftPositions = cat(2,leftPositions,    4*width/7 - devLineWidth);
topPositions = cat(2,topPositions,      centerh - devLineHeight/2);
rightPositions = cat(2,rightPositions,  4*width/7 + devLineWidth);
bottomPositions = cat(2,bottomPositions,centerh + devLineHeight/2);

%line5
draw = cat(1,draw,blackt);
leftPositions = cat(2,leftPositions,    5*width/7 - devLineWidth);
topPositions = cat(2,topPositions,      centerh - devLineHeight/2);
rightPositions = cat(2,rightPositions,  5*width/7 + devLineWidth);
bottomPositions = cat(2,bottomPositions,centerh + devLineHeight/2);

%line6
draw = cat(1,draw,blackt);
leftPositions = cat(2,leftPositions,    6*width/7 - devLineWidth);
topPositions = cat(2,topPositions,      centerh - devLineHeight/2);
rightPositions = cat(2,rightPositions,  6*width/7 + devLineWidth);
bottomPositions = cat(2,bottomPositions,centerh + devLineHeight/2);

% The response boxes

drawBox = [];
leftPositionsBox = [];
topPositionsBox = [];
rightPositionsBox = [];
bottomPositionsBox = [];

if buttonDown == 'z'
    yesBox = lightGreent;
    noBox = lightRedt;
    
elseif buttonDown == 'n'
    yesBox = lightGreent;
    noBox = redt;
    
elseif buttonDown == 'y'
    yesBox = greent;
    noBox = lightRedt;
end

if confirmTime == 1
    Screen(w,'TextSize',27)
    text = 'Re-do';
    [newX,newY]=Screen('DrawText', w, text, width/40, height/7.5);
    text = 'Go on';
    [newX,newY]=Screen('DrawText', w, text, width-width/40-width/10, height/7.5);
    
    drawBox = cat(1,drawBox,noBox);
    leftPositionsBox = cat(2,leftPositionsBox,    width/40);
    topPositionsBox = cat(2,topPositionsBox,      height/7);
    rightPositionsBox = cat(2,rightPositionsBox,  width/40+width/10);
    bottomPositionsBox = cat(2,bottomPositionsBox,height/40);
    
    drawBox = cat(1,drawBox,yesBox);
    leftPositionsBox = cat(2,leftPositionsBox,    width-width/40-width/10);
    topPositionsBox = cat(2,topPositionsBox,      height/7);
    rightPositionsBox = cat(2,rightPositionsBox,  width-width/40);
    bottomPositionsBox = cat(2,bottomPositionsBox,height/40);
end


% The indifference box

if confirmTime == 0
    if indiffDown == 0
        indiffBoxColor = lightGreyt;
    elseif indiffDown == 1
        indiffBoxColor = greyt;
    end
    drawBox = cat(1,drawBox,indiffBoxColor);
    leftPositionsBox = cat(2,leftPositionsBox,    centerw-width/20);
    topPositionsBox = cat(2,topPositionsBox,      height/7);
    rightPositionsBox = cat(2,rightPositionsBox,  centerw+width/20);
    bottomPositionsBox = cat(2,bottomPositionsBox,height/40);
    Screen(w,'TextSize',25)
    text = 'Indifferent';
    [newX,newY]=Screen('DrawText', w, text, centerw-width/20, height/7.5);
end

    v1 = cat(1,leftPositionsBox,topPositionsBox,rightPositionsBox,bottomPositionsBox);
    
    Screen('DrawTextures',w,drawBox,[],v1);
    
% Left
% Box 1L
draw = cat(1,draw,item1t);
leftPositions = cat(2,leftPositions,    pwL7 + (find(rankOrder==1) - 1)*(width/7));
topPositions = cat(2,topPositions,       ph1);
rightPositions = cat(2,rightPositions,  pwL6 + (find(rankOrder==1) - 1)*(width/7));
bottomPositions = cat(2,bottomPositions, ph2);

% Box 2L
draw = cat(1,draw,item2t);
leftPositions = cat(2,leftPositions,    pwL7 + (find(rankOrder==2) - 1)*(width/7));
topPositions = cat(2,topPositions,       ph1);
rightPositions = cat(2,rightPositions,  pwL6 + (find(rankOrder==2) - 1)*(width/7));
bottomPositions = cat(2,bottomPositions, ph2);

draw = cat(1,draw,item3t);
leftPositions = cat(2,leftPositions,    pwL7 + (find(rankOrder==3) - 1)*(width/7));
topPositions = cat(2,topPositions,       ph1);
rightPositions = cat(2,rightPositions,  pwL6 + (find(rankOrder==3) - 1)*(width/7));
bottomPositions = cat(2,bottomPositions, ph2);

draw = cat(1,draw,item4t);
leftPositions = cat(2,leftPositions,    pwL7 + (find(rankOrder==4) - 1)*(width/7));
topPositions = cat(2,topPositions,       ph1);
rightPositions = cat(2,rightPositions,  pwL6 + (find(rankOrder==4) - 1)*(width/7));
bottomPositions = cat(2,bottomPositions, ph2);

draw = cat(1,draw,item5t);
leftPositions = cat(2,leftPositions,    pwL7 + (find(rankOrder==5) - 1)*(width/7));
topPositions = cat(2,topPositions,       ph1);
rightPositions = cat(2,rightPositions,  pwL6 + (find(rankOrder==5) - 1)*(width/7));
bottomPositions = cat(2,bottomPositions, ph2);

draw = cat(1,draw,item6t);
leftPositions = cat(2,leftPositions,    pwL7 + (find(rankOrder==6) - 1)*(width/7));
topPositions = cat(2,topPositions,       ph1);
rightPositions = cat(2,rightPositions,  pwL6 + (find(rankOrder==6) - 1)*(width/7));
bottomPositions = cat(2,bottomPositions, ph2);

draw = cat(1,draw,item7t);
leftPositions = cat(2,leftPositions,    pwL7 + (find(rankOrder==7) - 1)*(width/7));
topPositions = cat(2,topPositions,       ph1);
rightPositions = cat(2,rightPositions,  pwL6 + (find(rankOrder==7) - 1)*(width/7));
bottomPositions = cat(2,bottomPositions, ph2);


v = cat(1,leftPositions,topPositions,rightPositions,bottomPositions);

Screen('DrawTextures',w,draw,[],v);

end


function[] = renderRank2( rankOrder, items, w, confirmTime, indiffDown, buttonDown)
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

load('setTreatment2.mat');

pie1 = imread('Pie1.jpg');
pie2 = imread('Pie2.jpg');
pie3 = imread('Pie3.jpg');
pie4 = imread('Pie4.jpg');
pie5 = imread('Pie5.jpg');
pie6 = imread('Pie6.jpg');
pie7 = imread('Pie7.jpg');


pie1t = Screen('MakeTexture',w,pie1);
pie2t = Screen('MakeTexture',w,pie2);
pie3t = Screen('MakeTexture',w,pie3);
pie4t = Screen('MakeTexture',w,pie4);
pie5t = Screen('MakeTexture',w,pie5);
pie6t = Screen('MakeTexture',w,pie6);
pie7t = Screen('MakeTexture',w,pie7);
itemt = Screen('MakeTexture',w,items);

%% These are all of the position constants

centerw = width/2;  % This the center width of the screen
centerh = height/2; % The center of the height of the screen
itemw = 8*width/287;
itemh = 1.5*itemw;
itemEccen = itemw/8;
piew =   2*width/21;       % The width of one pie chart in the array
pieh =   piew; % The height of one pie chart in the array
pieEccen = piew/4;
devLineHeight = height*.9;  % The height of the black box in the middle of the screen
devLineWidth  = 1;          % The width of the black box in the middle of the screen

pwPie6= pieEccen;
pwPie5= pwPie6 + piew;

phPie1= centerh - (pieh);
phPie2= phPie1 + pieh;

pwL1= 3*itemEccen;
pwL2= pwL1 + itemw;
pwL3= pwL2 + itemEccen;
pwL4= pwL3 + itemw;
pwL5= pwL4 + itemEccen;
pwL6= pwL5 + itemw;
pwL7= pwL6 + itemEccen;
pwL8= pwL7 + itemw;

ph1= phPie2 + itemh/3;
ph2= ph1 + itemh;
ph3= ph2 + itemEccen;
ph4= ph3 + itemh;
ph5= ph4 + itemEccen;
ph6= ph5 + itemh;

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
    
r = rankOrder;

for i = 1:length(r)
    amount = (i-1)*(width/7);
    itemAmount = amount;
    if setTreatment2(r(i),2) >= 1;  %If there is supposed to be one or more item(s) on the left, Add all on the numbers that we need to add so that a image will be drawn in the 1 position
        draw = cat(1,draw,pie7t);
        leftPositions = cat(2,leftPositions,    pwPie6 + amount);
        topPositions = cat(2,topPositions,       phPie1);
        rightPositions = cat(2,rightPositions,  pwPie5 + amount);
        bottomPositions = cat(2,bottomPositions, phPie2);
        draw = cat(1,draw,itemt);
        leftPositions = cat(2,leftPositions,   pwL1 + itemAmount);
        topPositions = cat(2,topPositions,       ph1);
        rightPositions = cat(2,rightPositions,  pwL2 + itemAmount);
        bottomPositions = cat(2,bottomPositions, ph2);
    end
    if setTreatment2(r(i),2) >= 2;  %If there is supposed to be one or more item(s) on the left, Add all on the numbers that we need to add so that a image will be drawn in the 1 position
        draw = cat(1,draw,pie6t);
        leftPositions = cat(2,leftPositions,    pwPie6 + amount);
        topPositions = cat(2,topPositions,       phPie1);
        rightPositions = cat(2,rightPositions,  pwPie5 + amount);
        bottomPositions = cat(2,bottomPositions, phPie2);
        draw = cat(1,draw,itemt);
        leftPositions = cat(2,leftPositions,    pwL3 + itemAmount);
        topPositions = cat(2,topPositions,       ph1);
        rightPositions = cat(2,rightPositions,  pwL4 + itemAmount);
        bottomPositions = cat(2,bottomPositions, ph2);
    end
    if setTreatment2(r(i),2) >= 3;  %If there is supposed to be one or more item(s) on the left, Add all on the numbers that we need to add so that a image will be drawn in the 1 position
        draw = cat(1,draw,pie5t);
        leftPositions = cat(2,leftPositions,    pwPie6 + amount);
        topPositions = cat(2,topPositions,       phPie1);
        rightPositions = cat(2,rightPositions,  pwPie5 + amount);
        bottomPositions = cat(2,bottomPositions, phPie2);
        draw = cat(1,draw,itemt);
        leftPositions = cat(2,leftPositions,    pwL5 + itemAmount);
        topPositions = cat(2,topPositions,       ph1);
        rightPositions = cat(2,rightPositions,  pwL6 + itemAmount);
        bottomPositions = cat(2,bottomPositions, ph2);
    end
    if setTreatment2(r(i),2) >= 4;  %If there is supposed to be one or more item(s) on the left, Add all on the numbers that we need to add so that a image will be drawn in the 1 position
        draw = cat(1,draw,pie4t);
        leftPositions = cat(2,leftPositions,    pwPie6 + amount);
        topPositions = cat(2,topPositions,       phPie1);
        rightPositions = cat(2,rightPositions,  pwPie5 + amount);
        bottomPositions = cat(2,bottomPositions, phPie2);
        draw = cat(1,draw,itemt);
        leftPositions = cat(2,leftPositions,    pwL7 + itemAmount);
        topPositions = cat(2,topPositions,       ph1);
        rightPositions = cat(2,rightPositions,  pwL8 + itemAmount);
        bottomPositions = cat(2,bottomPositions, ph2);
    end
    if setTreatment2(r(i),2) >= 5;  %If there is supposed to be one or more item(s) on the left, Add all on the numbers that we need to add so that a image will be drawn in the 1 position
        draw = cat(1,draw,pie3t);
        leftPositions = cat(2,leftPositions,    pwPie6 + amount);
        topPositions = cat(2,topPositions,       phPie1);
        rightPositions = cat(2,rightPositions,  pwPie5 + amount);
        bottomPositions = cat(2,bottomPositions, phPie2);
        draw = cat(1,draw,itemt);
        leftPositions = cat(2,leftPositions,    pwL1 + itemAmount);
        topPositions = cat(2,topPositions,       ph3);
        rightPositions = cat(2,rightPositions,  pwL2 + itemAmount);
        bottomPositions = cat(2,bottomPositions, ph4);
    end
    if setTreatment2(r(i),2) >= 6;  %If there is supposed to be one or more item(s) on the left, Add all on the numbers that we need to add so that a image will be drawn in the 1 position
        draw = cat(1,draw,pie3t);
        leftPositions = cat(2,leftPositions,    pwPie6 + amount);
        topPositions = cat(2,topPositions,       phPie1);
        rightPositions = cat(2,rightPositions,  pwPie5 + amount);
        bottomPositions = cat(2,bottomPositions, phPie2);
        draw = cat(1,draw,itemt);
        leftPositions = cat(2,leftPositions,    pwL3 + itemAmount);
        topPositions = cat(2,topPositions,       ph3);
        rightPositions = cat(2,rightPositions,  pwL4 + itemAmount);
        bottomPositions = cat(2,bottomPositions, ph4);
    end
    if setTreatment2(r(i),2) >= 7;  %If there is supposed to be one or more item(s) on the left, Add all on the numbers that we need to add so that a image will be drawn in the 1 position
        draw = cat(1,draw,pie3t);
        leftPositions = cat(2,leftPositions,    pwPie6 + amount);
        topPositions = cat(2,topPositions,       phPie1);
        rightPositions = cat(2,rightPositions,  pwPie5 + amount);
        bottomPositions = cat(2,bottomPositions, phPie2);
        draw = cat(1,draw,itemt);
        leftPositions = cat(2,leftPositions,    pwL5 + itemAmount);
        topPositions = cat(2,topPositions,       ph3);
        rightPositions = cat(2,rightPositions,  pwL6 + itemAmount);
        bottomPositions = cat(2,bottomPositions, ph4);
    end
    if setTreatment2(r(i),2) >= 8;  %If there is supposed to be one or more item(s) on the left, Add all on the numbers that we need to add so that a image will be drawn in the 1 position
        draw = cat(1,draw,pie2t);
        leftPositions = cat(2,leftPositions,    pwPie6 + amount);
        topPositions = cat(2,topPositions,       phPie1);
        rightPositions = cat(2,rightPositions,  pwPie5 + amount);
        bottomPositions = cat(2,bottomPositions, phPie2);
        draw = cat(1,draw,itemt);
        leftPositions = cat(2,leftPositions,    pwL7 + itemAmount);
        topPositions = cat(2,topPositions,       ph3);
        rightPositions = cat(2,rightPositions,  pwL8 + itemAmount);
        bottomPositions = cat(2,bottomPositions, ph4);
    end
    if setTreatment2(r(i),2) >= 9;  %If there is supposed to be one or more item(s) on the left, Add all on the numbers that we need to add so that a image will be drawn in the 1 position
        draw = cat(1,draw,pie2t);
        leftPositions = cat(2,leftPositions,    pwPie6 + amount);
        topPositions = cat(2,topPositions,       phPie1);
        rightPositions = cat(2,rightPositions,  pwPie5 + amount);
        bottomPositions = cat(2,bottomPositions, phPie2);
        draw = cat(1,draw,itemt);
        leftPositions = cat(2,leftPositions,    pwL1 + itemAmount);
        topPositions = cat(2,topPositions,       ph5);
        rightPositions = cat(2,rightPositions,  pwL2 + itemAmount);
        bottomPositions = cat(2,bottomPositions, ph6);
    end
    if setTreatment2(r(i),2) >= 10;  %If there is supposed to be one or more item(s) on the left, Add all on the numbers that we need to add so that a image will be drawn in the 1 position
        draw = cat(1,draw,pie2t);
        leftPositions = cat(2,leftPositions,    pwPie6 + amount);
        topPositions = cat(2,topPositions,       phPie1);
        rightPositions = cat(2,rightPositions,  pwPie5 + amount);
        bottomPositions = cat(2,bottomPositions, phPie2);
        draw = cat(1,draw,itemt);
        leftPositions = cat(2,leftPositions,    pwL3 + itemAmount);
        topPositions = cat(2,topPositions,       ph5);
        rightPositions = cat(2,rightPositions,  pwL4 + itemAmount);
        bottomPositions = cat(2,bottomPositions, ph6);
    end
    if setTreatment2(r(i),2) >= 11;  %If there is supposed to be one or more item(s) on the left, Add all on the numbers that we need to add so that a image will be drawn in the 1 position
        draw = cat(1,draw,pie2t);
        leftPositions = cat(2,leftPositions,    pwPie6 + amount);
        topPositions = cat(2,topPositions,       phPie1);
        rightPositions = cat(2,rightPositions,  pwPie5 + amount);
        bottomPositions = cat(2,bottomPositions, phPie2);
        draw = cat(1,draw,itemt);
        leftPositions = cat(2,leftPositions,    pwL5 + itemAmount);
        topPositions = cat(2,topPositions,       ph5);
        rightPositions = cat(2,rightPositions,  pwL6 + itemAmount);
        bottomPositions = cat(2,bottomPositions, ph6);
    end
    if setTreatment2(r(i),2) >= 12;  %If there is supposed to be one or more item(s) on the left, Add all on the numbers that we need to add so that a image will be drawn in the 1 position
        draw = cat(1,draw,pie1t);
        leftPositions = cat(2,leftPositions,    pwPie6 + amount);
        topPositions = cat(2,topPositions,       phPie1);
        rightPositions = cat(2,rightPositions,  pwPie5 + amount);
        bottomPositions = cat(2,bottomPositions, phPie2);
        draw = cat(1,draw,itemt);
        leftPositions = cat(2,leftPositions,    pwL7 + itemAmount);
        topPositions = cat(2,topPositions,       ph5);
        rightPositions = cat(2,rightPositions,  pwL8 + itemAmount);
        bottomPositions = cat(2,bottomPositions, ph6);
    end
    
    v = cat(1,leftPositions,topPositions,rightPositions,bottomPositions);
    
    Screen('DrawTextures',w,draw,[],v);
end


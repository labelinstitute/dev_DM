function [] = renderRank3(rankOrder, items, w, confirmTime, indiffDown, buttonDown)
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
    
    me = imread('me.jpg');
    other = imread('other.jpg');
    
    load('setTreatment3.mat');
    
    %% Make all of the textures
    itemt = Screen('MakeTexture',w,items);

    blackt = Screen('MakeTexture',w,black);
    greent = Screen('MakeTexture',w,green);
    redt = Screen('MakeTexture',w,red);
    lightGreent = Screen('MakeTexture',w,lightGreen);
    lightRedt = Screen('MakeTexture',w,lightRed);
    lightGreyt = Screen('MakeTexture',w,lightGrey);
    greyt = Screen('MakeTexture',w,grey);
    
    met = Screen('MakeTexture',w,me);
    othert = Screen('MakeTexture',w,other);
    
  %% These are all of the position constants

centerw = width/2;  % This the center width of the screen
centerh = height/2; % The center of the height of the screen
handw =   width/16;       % The width of one pie chart in the array
handh =   0.8*handw; % The height of one pie chart in the array
itemw = width/45; % The width of one item in the array
itemh = 1.5*itemw; % The height of one item in the array
itemEccen =   itemw/8;       % This is the eccentricity. Distance from the center to the right edge of the array
handEccen = handw/2;
devLineHeight = height*.9;  % The height of the black box inthe middle of the screen
devLineWidth  = 1;          % The width of the black box in the middle of the screen

% Everything below here is coded in terms of the numbers above

pwHand7= width/14 + handw/2;
pwHand8= pwHand7 - handw;

%heights for the "me" hand
phMe1= centerh - 2*handh;
phMe2= phMe1 + handh;

%heights for the "other" hand
phOther1= centerh + itemEccen;
phOther2= phOther1 + handh;

pwL1= width/14 - itemw/2 - itemEccen - itemw - itemEccen - itemw;
pwL2= pwL1 + itemw;
pwL3= pwL2 + itemEccen;
pwL4= pwL3 + itemw;
pwL5= pwL4 + itemEccen;
pwL6= pwL5 + itemw;
pwL7= pwL6 + itemEccen;
pwL8= pwL7 + itemw;
pwL9= pwL8 + itemEccen;
pwL10= pwL9 + itemw;

%item height specifications for the "me" offers
ph1= phMe2 + itemEccen;
ph2= ph1 + itemh;

%item height specifications for the "other" offers
ph5= phOther2 + itemEccen;
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
    amount = (i-1)*(1/7)*width;
    %ME
     if setTreatment3(r(i),1) >= 0;  %If there is supposed to be one or more item(s) on the left, Add all on the numbers that we need to add so that a image will be drawn in the 1 position
        draw = cat(1,draw,met);
        leftPositions = cat(2,leftPositions,    pwHand8 + amount);
        topPositions = cat(2,topPositions,       phMe1);
        rightPositions = cat(2,rightPositions,  pwHand7 + amount);
        bottomPositions = cat(2,bottomPositions, phMe2);
    end
    if setTreatment3(r(i),1) >= 1;  %If there is supposed to be one or more item(s) on the left, Add all on the numbers that we need to add so that a image will be drawn in the 1 position
        draw = cat(1,draw,met);
        leftPositions = cat(2,leftPositions,    pwHand8 + amount);
        topPositions = cat(2,topPositions,       phMe1);
        rightPositions = cat(2,rightPositions,  pwHand7 + amount);
        bottomPositions = cat(2,bottomPositions, phMe2);
        draw = cat(1,draw,itemt);
        leftPositions = cat(2,leftPositions,   pwL1 + amount);
        topPositions = cat(2,topPositions,       ph1);
        rightPositions = cat(2,rightPositions,  pwL2 + amount);
        bottomPositions = cat(2,bottomPositions, ph2);
    end
    if setTreatment3(r(i),1) >= 2;  %If there is supposed to be one or more item(s) on the left, Add all on the numbers that we need to add so that a image will be drawn in the 1 position
        draw = cat(1,draw,met);
        leftPositions = cat(2,leftPositions,    pwHand8 + amount);
        topPositions = cat(2,topPositions,       phMe1);
        rightPositions = cat(2,rightPositions,  pwHand7 + amount);
        bottomPositions = cat(2,bottomPositions, phMe2);
        draw = cat(1,draw,itemt);
        leftPositions = cat(2,leftPositions,    pwL3 + amount);
        topPositions = cat(2,topPositions,       ph1);
        rightPositions = cat(2,rightPositions,  pwL4 + amount);
        bottomPositions = cat(2,bottomPositions, ph2);
    end
    if setTreatment3(r(i),1) >= 3;  %If there is supposed to be one or more item(s) on the left, Add all on the numbers that we need to add so that a image will be drawn in the 1 position
        draw = cat(1,draw,met);
        leftPositions = cat(2,leftPositions,    pwHand8 + amount);
        topPositions = cat(2,topPositions,       phMe1);
        rightPositions = cat(2,rightPositions,  pwHand7 + amount);
        bottomPositions = cat(2,bottomPositions, phMe2);
        draw = cat(1,draw,itemt);
        leftPositions = cat(2,leftPositions,    pwL5 + amount);
        topPositions = cat(2,topPositions,       ph1);
        rightPositions = cat(2,rightPositions,  pwL6 + amount);
        bottomPositions = cat(2,bottomPositions, ph2);
    end
    if setTreatment3(r(i),1) >= 4;  %If there is supposed to be one or more item(s) on the left, Add all on the numbers that we need to add so that a image will be drawn in the 1 position
        draw = cat(1,draw,met);
        leftPositions = cat(2,leftPositions,    pwHand8 + amount);
        topPositions = cat(2,topPositions,       phMe1);
        rightPositions = cat(2,rightPositions,  pwHand7 + amount);
        bottomPositions = cat(2,bottomPositions, phMe2);
        draw = cat(1,draw,itemt);
        leftPositions = cat(2,leftPositions,    pwL7 + amount);
        topPositions = cat(2,topPositions,       ph1);
        rightPositions = cat(2,rightPositions,  pwL8 + amount);
        bottomPositions = cat(2,bottomPositions, ph2);
    end
    if setTreatment3(r(i),1) >= 5;  %If there is supposed to be one or more item(s) on the left, Add all on the numbers that we need to add so that a image will be drawn in the 1 position
        draw = cat(1,draw,met);
        leftPositions = cat(2,leftPositions,    pwHand8 + amount);
        topPositions = cat(2,topPositions,       phMe1);
        rightPositions = cat(2,rightPositions,  pwHand7 + amount);
        bottomPositions = cat(2,bottomPositions, phMe2);
        draw = cat(1,draw,itemt);
        leftPositions = cat(2,leftPositions,    pwL9 + amount);
        topPositions = cat(2,topPositions,       ph1);
        rightPositions = cat(2,rightPositions,  pwL10 + amount);
        bottomPositions = cat(2,bottomPositions, ph2);
    end
    
    %OTHER
    if setTreatment3(r(i),2) >= 0;  %If there is supposed to be one or more item(s) on the left, Add all on the numbers that we need to add so that a image will be drawn in the 1 position
        draw = cat(1,draw,othert);
        leftPositions = cat(2,leftPositions,    pwHand8 + amount);
        topPositions = cat(2,topPositions,       phOther1);
        rightPositions = cat(2,rightPositions,  pwHand7 + amount);
        bottomPositions = cat(2,bottomPositions, phOther2);
    end
    if setTreatment3(r(i),2) >= 1;  %If there is supposed to be one or more item(s) on the left, Add all on the numbers that we need to add so that a image will be drawn in the 1 position
        draw = cat(1,draw,othert);
        leftPositions = cat(2,leftPositions,    pwHand8 + amount);
        topPositions = cat(2,topPositions,       phOther1);
        rightPositions = cat(2,rightPositions,  pwHand7 + amount);
        bottomPositions = cat(2,bottomPositions, phOther2);
        draw = cat(1,draw,itemt);
        leftPositions = cat(2,leftPositions,   pwL1 + amount);
        topPositions = cat(2,topPositions,       ph5);
        rightPositions = cat(2,rightPositions,  pwL2 + amount);
        bottomPositions = cat(2,bottomPositions, ph6);
    end
    if setTreatment3(r(i),2) >= 2;  %If there is supposed to be one or more item(s) on the left, Add all on the numbers that we need to add so that a image will be drawn in the 1 position
        draw = cat(1,draw,othert);
        leftPositions = cat(2,leftPositions,    pwHand8 + amount);
        topPositions = cat(2,topPositions,       phOther1);
        rightPositions = cat(2,rightPositions,  pwHand7 + amount);
        bottomPositions = cat(2,bottomPositions, phOther2);
        draw = cat(1,draw,itemt);
        leftPositions = cat(2,leftPositions,    pwL3 + amount);
        topPositions = cat(2,topPositions,       ph5);
        rightPositions = cat(2,rightPositions,  pwL4 + amount);
        bottomPositions = cat(2,bottomPositions, ph6);
    end
    if setTreatment3(r(i),2) >= 3;  %If there is supposed to be one or more item(s) on the left, Add all on the numbers that we need to add so that a image will be drawn in the 1 position
        draw = cat(1,draw,othert);
        leftPositions = cat(2,leftPositions,    pwHand8 + amount);
        topPositions = cat(2,topPositions,       phOther1);
        rightPositions = cat(2,rightPositions,  pwHand7 + amount);
        bottomPositions = cat(2,bottomPositions, phOther2);
        draw = cat(1,draw,itemt);
        leftPositions = cat(2,leftPositions,    pwL5 + amount);
        topPositions = cat(2,topPositions,       ph5);
        rightPositions = cat(2,rightPositions,  pwL6 + amount);
        bottomPositions = cat(2,bottomPositions, ph6);
    end
    if setTreatment3(r(i),2) >= 4;  %If there is supposed to be one or more item(s) on the left, Add all on the numbers that we need to add so that a image will be drawn in the 1 position
        draw = cat(1,draw,othert);
        leftPositions = cat(2,leftPositions,    pwHand8 + amount);
        topPositions = cat(2,topPositions,       phOther1);
        rightPositions = cat(2,rightPositions,  pwHand7 + amount);
        bottomPositions = cat(2,bottomPositions, phOther2);
        draw = cat(1,draw,itemt);
        leftPositions = cat(2,leftPositions,    pwL7 + amount);
        topPositions = cat(2,topPositions,       ph5);
        rightPositions = cat(2,rightPositions,  pwL8 + amount);
        bottomPositions = cat(2,bottomPositions, ph6);
    end
    if setTreatment3(r(i),2) >= 5;  %If there is supposed to be one or more item(s) on the left, Add all on the numbers that we need to add so that a image will be drawn in the 1 position
        draw = cat(1,draw,othert);
        leftPositions = cat(2,leftPositions,    pwHand8 + amount);
        topPositions = cat(2,topPositions,       phOther1);
        rightPositions = cat(2,rightPositions,  pwHand7 + amount);
        bottomPositions = cat(2,bottomPositions, phOther2);
        draw = cat(1,draw,itemt);
        leftPositions = cat(2,leftPositions,    pwL9 + amount);
        topPositions = cat(2,topPositions,       ph5);
        rightPositions = cat(2,rightPositions,  pwL10 + amount);
        bottomPositions = cat(2,bottomPositions, ph6);
    end
   
    v = cat(1,leftPositions,topPositions,rightPositions,bottomPositions);
    
    Screen('DrawTextures',w,draw,[],v);
end


function [ width height ] = renderKey( items, w)
% Author: Niree Kodaverdian

screenNumber = max(Screen('Screens'));
[width height] = Screen('WindowSize', screenNumber);
circle = imread('circle.jpg');
black = imread('black.jpg');

% Make all of the textures
circlet = Screen('MakeTexture',w,circle);
itemt = Screen('MakeTexture',w,items);
blackt = Screen('MakeTexture',w,black);

centerw = width/2;  % This the center width of the screen
centerh = height/2; % The center of the height of the screen
circlew = width/15;       
circleh = circlew;
itemw = circlew;
itemh = 1.5*itemw;
devLineWidth  = 1;          % The width of the black box in the middle of the screen

pwCircle1= centerw - 2*circlew;
pwCircle2= pwCircle1 + circlew;
phCircle1= centerh - circleh/2;
phCircle2= phCircle1 + circleh;

pwItem1= centerw + itemw;
pwItem2= centerw + 2*itemw;
phItem1= centerh - itemh/2;
phItem2= phItem1 + itemh;

draw = [];
leftPositions = [];
topPositions = [];
rightPositions = [];
bottomPositions = [];


%circle
draw = cat(1,draw,circlet);
leftPositions = cat(2,leftPositions,    pwCircle1);
topPositions = cat(2,topPositions,      phCircle1);
rightPositions = cat(2,rightPositions,  pwCircle2);
bottomPositions = cat(2,bottomPositions,phCircle2);

%equal sign
draw = cat(1,draw,blackt);
leftPositions = cat(2,leftPositions,    centerw - 11);
topPositions = cat(2,topPositions,      centerh - 7 - devLineWidth);
rightPositions = cat(2,rightPositions,  centerw + 22);
bottomPositions = cat(2,bottomPositions,centerh - 7 + devLineWidth);

draw = cat(1,draw,blackt);
leftPositions = cat(2,leftPositions,    centerw - 11);
topPositions = cat(2,topPositions,      centerh + 7 - devLineWidth);
rightPositions = cat(2,rightPositions,  centerw + 22);
bottomPositions = cat(2,bottomPositions,centerh + 7 + devLineWidth);
    
%item
draw = cat(1,draw,itemt);
leftPositions = cat(2,leftPositions,    pwItem1);
topPositions = cat(2,topPositions,      phItem1);
rightPositions = cat(2,rightPositions,  pwItem2);
bottomPositions = cat(2,bottomPositions,phItem2);


v = cat(1,leftPositions,topPositions,rightPositions,bottomPositions);

Screen('DrawTextures',w,draw,[],v)
end


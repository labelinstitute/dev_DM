function [ output_args ] = drawStop( w )
% Author: Niree Kodaverdian

screenNumber = max(Screen('Screens'));
[width height] = Screen('WindowSize', screenNumber);
stop = imread('stop.jpg');

% Make all of the textures
stopt = Screen('MakeTexture',w,stop);
centerw = width/2;  % This the center width of the screen
centerh = height/2; % The center of the height of the screen
itemw = width/8;
itemh = itemw;

draw = [];
leftPositions = [];
topPositions = [];
rightPositions = [];
bottomPositions = [];

%stop
draw = cat(1,draw,stopt);
leftPositions = cat(2,leftPositions,    centerw - itemw/2);
topPositions = cat(2,topPositions,      centerh - itemh/2);
rightPositions = cat(2,rightPositions,  centerw + itemw/2);
bottomPositions = cat(2,bottomPositions,centerh + itemh/2);

v = cat(1,leftPositions,topPositions,rightPositions,bottomPositions);

Screen('DrawTextures',w,draw,[],v)

end


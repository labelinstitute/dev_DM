function [ output_args ] = renderFeedback( positionVector, w, input )
% Author: Niree Kodaverdian

screenNumber = max(Screen('Screens'));
[width height] = Screen('WindowSize', screenNumber);

%% These are all of the position constants
centerw = width/2;  % This the center width of the screen
centerh = height/2; % The center of the height of the screen
itemw =   8*width/63;       % The width of one item in the array
itemh =   1.5*itemw;% The height of one item in the array
eccen =   itemw/16;       % This is the eccentricity. Distance from the center to the right edge of the array

% Everything below here is coded in terms of the numbers above

pwCue1= eccen;
pwCue2= eccen + itemw;

% height of each feedback frame
phCue1= height/4;
phCue2= 6*height/7;


leftPositions = [];
topPositions = [];
rightPositions = [];
bottomPositions = [];
 
% Left
% Frame 1
if positionVector(1) == 1
leftPositions = cat(2,leftPositions,    pwCue1);
topPositions = cat(2,topPositions,       phCue1);
rightPositions = cat(2,rightPositions,  pwCue2);
bottomPositions = cat(2,bottomPositions, phCue2);
end

% Frame 2
if positionVector(2) == 1
leftPositions = cat(2,leftPositions,    pwCue1 + width/7);
topPositions = cat(2,topPositions,       phCue1);
rightPositions = cat(2,rightPositions,  pwCue2 + width/7);
bottomPositions = cat(2,bottomPositions, phCue2);
end

% Frame 3
if positionVector(3) == 1
leftPositions = cat(2,leftPositions,    pwCue1 + 2*width/7);
topPositions = cat(2,topPositions,       phCue1);
rightPositions = cat(2,rightPositions,  pwCue2 + 2*width/7);
bottomPositions = cat(2,bottomPositions, phCue2);
end

% Frame 4
if positionVector(4) == 1
leftPositions = cat(2,leftPositions,    pwCue1 + 3*width/7);
topPositions = cat(2,topPositions,       phCue1);
rightPositions = cat(2,rightPositions,  pwCue2 + 3*width/7);
bottomPositions = cat(2,bottomPositions, phCue2);
end

% Frame 5
if positionVector(5) == 1
leftPositions = cat(2,leftPositions,    pwCue1 + 4*width/7);
topPositions = cat(2,topPositions,       phCue1);
rightPositions = cat(2,rightPositions,  pwCue2 + 4*width/7);
bottomPositions = cat(2,bottomPositions, phCue2);
end

% Frame 6
if positionVector(6) == 1
leftPositions = cat(2,leftPositions,    pwCue1 + 5*width/7);
topPositions = cat(2,topPositions,       phCue1);
rightPositions = cat(2,rightPositions,  pwCue2 + 5*width/7);
bottomPositions = cat(2,bottomPositions, phCue2);
end

% Frame 7
if positionVector(7) == 1
leftPositions = cat(2,leftPositions,    pwCue1 + 6*width/7);
topPositions = cat(2,topPositions,       phCue1);
rightPositions = cat(2,rightPositions,  pwCue2 + 6*width/7);
bottomPositions = cat(2,bottomPositions, phCue2);
end

feedbackRect = cat(1,leftPositions,topPositions,rightPositions,bottomPositions);

Screen('FrameRect', w, 0,feedbackRect,2);



end


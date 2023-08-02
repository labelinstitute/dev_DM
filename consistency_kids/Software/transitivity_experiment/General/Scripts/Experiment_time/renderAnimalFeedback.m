function [ output_args ] = renderAnimalFeedback( buttonDown, number, index, w )
% Author: Niree Kodaverdian

screenNumber = max(Screen('Screens'));
[width height] = Screen('WindowSize', screenNumber);
centerw = width/2;  % This the center width of the screen
centerh = height/2; % The center of the height of the screen


%% These are all of the position constants
centerw = width/2;  % This the center width of the screen
centerh = height/2; % The center of the height of the screen
itemw =   width/8;       % The width of one item in the array
itemh =   1.5*itemw;% The height of one item in the array
eccen =   itemw/3;       % This is the eccentricity. Distance from the center to the right edge of the array

    % Everything below here is coded in terms of the numbers above
    ph1 = centerh - itemh/2 - 10;
    ph2 = centerh + itemh/2 + 10;
    
    % When there are 2 animals on screen (from left to right)
    pw2L1 = centerw - itemw/2 - eccen - itemw - 10;
    pw2L2 = pw2L1 + itemw + 20;
    pw2R1 = pw2L2 + eccen - 20;
    pw2R2 = pw2R1 + itemw + 20;
    pw2QMark1 = pw2R2 + eccen - 20;
    pw2QMark2 = pw2QMark1 + itemw + 20;
    
    % When there are 3 animals on screen (from left to right)
    pw3L1 = centerw - eccen/2 - itemw - eccen - itemw - 10;
    pw3L2 = pw3L1 + itemw + 20;
    pw3M1 = pw3L2 + eccen - 20;
    pw3M2 = pw3M1 + itemw + 20;
    pw3R1 = pw3M2 + eccen - 20;
    pw3R2 = pw3R1 + itemw + 20;
    pw3QMark1 = pw3R2 + eccen - 20;
    pw3QMark2 = pw3QMark1 + itemw + 20;
    
    % When there are 4 animals on screen (from left to right)
    pw4LL1 = centerw - itemw/2 - eccen - itemw - eccen - itemw - 10;
    pw4LL2 = pw4LL1 + itemw + 20;
    pw4LM1 = pw4LL2 + eccen - 20;
    pw4LM2 = pw4LM1 + itemw + 20;
    pw4RM1 = pw4LM2 + eccen - 20;
    pw4RM2 = pw4RM1 + itemw + 20;
    pw4RR1 = pw4RM2 + eccen - 20;
    pw4RR2 = pw4RR1 + itemw + 20;
    pw4QMark1 = pw4RR2 + eccen - 20;
    pw4QMark2 = pw4QMark1 + itemw + 20;

    frame1 = [pw2L1, ph1, pw2L2, ph2];
    frame2 = [pw2R1, ph1, pw2R2, ph2];
    frameQ2 = [pw2QMark1, ph1, pw2QMark2, ph2];
    frame3 = [pw3L1, ph1, pw3L2, ph2];
    frame4 = [pw3M1, ph1, pw3M2, ph2]; 
    frame5 = [pw3R1, ph1, pw3R2, ph2];
    frameQ3 = [pw3QMark1, ph1, pw3QMark2, ph2];
    frame6 = [pw4LL1, ph1, pw4LL2, ph2];
    frame7 = [pw4LM1, ph1, pw4LM2, ph2]; 
    frame8 = [pw4RM1, ph1, pw4RM2, ph2];
    frame9 = [pw4RR1, ph1, pw4RR2, ph2];
    frameQ4 = [pw4QMark1, ph1, pw4QMark2, ph2];

if number(index) == 2 && buttonDown == 1
    frame = frame1;
elseif number(index) == 2 && buttonDown == 2
    frame = frame2;
elseif number(index) == 2 && buttonDown == 0
    frame = frameQ2; %the question mark frame for the 2 animal case
elseif number(index) == 3 && buttonDown == 1
    frame = frame3;
elseif number(index) == 3 && buttonDown == 2
    frame = frame4;
elseif number(index) == 3 && buttonDown == 3
    frame = frame5;
elseif number(index) == 3 && buttonDown == 0
    frame = frameQ3; %the question mark frame for the 3 animal case
elseif number(index) == 4 && buttonDown == 1
    frame = frame6;
elseif number(index) == 4 && buttonDown == 2
    frame = frame7;
elseif number(index) == 4 && buttonDown == 3
    frame = frame8;
elseif number(index) == 4 && buttonDown == 4
    frame = frame9;
elseif number(index) == 4 && buttonDown == 0
    frame = frameQ4; %the question mark frame for the 4 animal case
end


leftPositions = [];
topPositions = [];
rightPositions = [];
bottomPositions = [];
 
leftPositions = cat(2,leftPositions,    frame(1));
topPositions = cat(2,topPositions,       frame(2));
rightPositions = cat(2,rightPositions,  frame(3));
bottomPositions = cat(2,bottomPositions, frame(4));

feedbackRect = cat(1,leftPositions,topPositions,rightPositions,bottomPositions);

Screen('FrameRect', w, 0,feedbackRect,2);


end


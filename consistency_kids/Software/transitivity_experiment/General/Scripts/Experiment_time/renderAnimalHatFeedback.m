function [ output_args ] = renderAnimalHatFeedback( buttonDown, number, index, w )
% Author: Niree Kodaverdian

screenNumber = max(Screen('Screens'));
[width height] = Screen('WindowSize', screenNumber);

hat = imread('hat.jpg');

hatt = Screen('MakeTexture',w,hat);

%% These are all of the position constants
centerw = width/2;  % This the center width of the screen
centerh = height/2; % The center of the height of the screen
itemw =   width/8;       % The width of one item in the array
itemh =   1.5*itemw;% The height of one item in the array
eccen =   itemw/3;       % This is the eccentricity. Distance from the center to the right edge of the array

    % Everything below here is coded in terms of the numbers above
    ph2 = centerh - itemh/2 - 1; %bottom of hat
    ph1 = ph2 - itemh; %top of hat
    
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

    
    hat1 = [pw2L1, ph1, pw2L2, ph2];
    hat2 = [pw2R1, ph1, pw2R2, ph2];
    hatQ2 = [pw2QMark1, ph1, pw2QMark2, ph2];
    hat3 = [pw3L1, ph1, pw3L2, ph2];
    hat4 = [pw3M1, ph1, pw3M2, ph2]; 
    hat5 = [pw3R1, ph1, pw3R2, ph2];
    hatQ3 = [pw3QMark1, ph1, pw3QMark2, ph2];
    hat6 = [pw4LL1, ph1, pw4LL2, ph2];
    hat7 = [pw4LM1, ph1, pw4LM2, ph2]; 
    hat8 = [pw4RM1, ph1, pw4RM2, ph2];
    hat9 = [pw4RR1, ph1, pw4RR2, ph2];
    hatQ4 = [pw4QMark1, ph1, pw4QMark2, ph2];
    
if number(index) == 2 && buttonDown == 1
    hat = hat1;
elseif number(index) == 2 && buttonDown == 2
    hat = hat2;
elseif number(index) == 2 && buttonDown == 0
    hat = hatQ2; %the question mark hat for the 2 animal case
elseif number(index) == 3 && buttonDown == 1
    hat = hat3;
elseif number(index) == 3 && buttonDown == 2
    hat = hat4;
elseif number(index) == 3 && buttonDown == 3
    hat = hat5;
elseif number(index) == 3 && buttonDown == 0
    hat = hatQ3; %the question mark hat for the 3 animal case
elseif number(index) == 4 && buttonDown == 1
    hat = hat6;
elseif number(index) == 4 && buttonDown == 2
    hat = hat7;
elseif number(index) == 4 && buttonDown == 3
    hat = hat8;
elseif number(index) == 4 && buttonDown == 4
    hat = hat9;
elseif number(index) == 4 && buttonDown == 0
    hat = hatQ4; %the question mark hat for the 4 animal case
end


draw = [];
leftPositions = [];
topPositions = [];
rightPositions = [];
bottomPositions = [];
 
draw = cat(1, draw, hatt);
leftPositions = cat(2,leftPositions,    hat(1));
topPositions = cat(2,topPositions,       hat(2));
rightPositions = cat(2,rightPositions,  hat(3));
bottomPositions = cat(2,bottomPositions, hat(4));

v = cat(1,leftPositions,topPositions,rightPositions,bottomPositions);
Screen('DrawTextures',w,draw,[],v);


end



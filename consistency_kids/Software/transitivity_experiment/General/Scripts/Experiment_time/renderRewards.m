function [ output_args ] = renderRewards(w,gradeLevel,items,rewardToday,treat1Item,treat3Item,treat3Me,treat3Other,treat2Item,treat2Amount)
% Author: Niree Kodaverdian

screenNumber = max(Screen('Screens'));
[width height] = Screen('WindowSize', screenNumber);
    
%% Open all of the image files
white = imread('white.jpg');


if gradeLevel == 'p'
    treat2Amount = 1;
    treat2Item = white;
    pie1 = white;
    pie2 = white;
    pie3 = white;
    pie4 = white;
    pie5 = white;
    pie6 = white;
    pie7 = white;
    treat3Item = white;
    treat3Me = 0;
    me = white;
    treat3Other = 0;
    other = white;
end

if gradeLevel ~= 'p' && gradeLevel ~= 'u' %all grade levels but preK and undergraduate
    treat2Item = items{treat2Item};
    pie1 = imread('Pie1.jpg');
    pie2 = imread('Pie2.jpg');
    pie3 = imread('Pie3.jpg');
    pie4 = imread('Pie4.jpg');
    pie5 = imread('Pie5.jpg');
    pie6 = imread('Pie6.jpg');
    pie7 = imread('Pie7.jpg');
    treat3Item = items{treat3Item};
    me = imread('me.jpg');
    other = imread('other.jpg');
end

if gradeLevel == 'u' %only undergraduate
    treat2Item = imread('token2.jpg');
    treat3Item = imread('token2.jpg');
    pie1 = imread('Pie1.jpg');
    pie2 = imread('Pie2.jpg');
    pie3 = imread('Pie3.jpg');
    pie4 = imread('Pie4.jpg');
    pie5 = imread('Pie5.jpg');
    pie6 = imread('Pie6.jpg');
    pie7 = imread('Pie7.jpg');
    me = imread('me.jpg');
    other = imread('other.jpg');
end

% for all grade levels
treat1Item = items{treat1Item};
rewardToday = items{rewardToday};


%% Make all of the textures
treat1Itemt = Screen('MakeTexture',w,treat1Item);
treat2Itemt = Screen('MakeTexture',w,treat2Item);
treat3Itemt = Screen('MakeTexture',w,treat3Item);
rewardTodayt = Screen('MakeTexture',w,rewardToday);

pie1t = Screen('MakeTexture',w,pie1);
pie2t = Screen('MakeTexture',w,pie2);
pie3t = Screen('MakeTexture',w,pie3);
pie4t = Screen('MakeTexture',w,pie4);
pie5t = Screen('MakeTexture',w,pie5);
pie6t = Screen('MakeTexture',w,pie6);
pie7t = Screen('MakeTexture',w,pie7);
    
met = Screen('MakeTexture',w,me);
othert = Screen('MakeTexture',w,other);

%% These are all of the position constants
centerw = width/2;  % This is the center width of the screen
centerh = height/2; % The center of the height of the screen
framew = 2*width/7;   % The width of a frame on the screen
frame1Center = width/6;
frame2Center = centerw;
frame3Center = 5*width/6;
frameEccenw =   framew/6; % This is the eccentricity. Distance from the center to the right edge of the array
frameEccenh = framew/16;
itemw = framew/10;% The width of one item in the array
itemh = 1.5*itemw;  % The height of one item in the array
itemEccen = itemw/3;

% width of feedback frame
pwCue1= frameEccenw/2;
pwCue2= pwCue1 + framew;

% height of feedback frame
phCue1= frameEccenh;
phCue2= 0.9*pwCue2;

frameHeightCenter = phCue2/2;

%% Frames around three delayed rewards

leftPositions = [];
topPositions = [];
rightPositions = [];
bottomPositions = [];

% Frame 1
leftPositions = cat(2,leftPositions,    pwCue1);
topPositions = cat(2,topPositions,       phCue1);
rightPositions = cat(2,rightPositions,  pwCue2);
bottomPositions = cat(2,bottomPositions, phCue2);

% Frame 2
leftPositions = cat(2,leftPositions,    pwCue1 + framew + frameEccenw);
topPositions = cat(2,topPositions,       phCue1);
rightPositions = cat(2,rightPositions,  pwCue2 + framew + frameEccenw);
bottomPositions = cat(2,bottomPositions, phCue2);

% Frame 3
leftPositions = cat(2,leftPositions,    pwCue1 + 2*framew + 2*frameEccenw);
topPositions = cat(2,topPositions,       phCue1);
rightPositions = cat(2,rightPositions,  pwCue2 + 2*framew + 2*frameEccenw);
bottomPositions = cat(2,bottomPositions, phCue2);


frameRect = cat(1,leftPositions,topPositions,rightPositions,bottomPositions);
Screen('FrameRect', w, 0, frameRect, 2);

%% Today reward (first favorite item)

    draw = [];
    leftPositions = [];
    topPositions = [];
    rightPositions = [];
    bottomPositions = [];
    
    draw = cat(1,draw,rewardTodayt);
    leftPositions = cat(2,leftPositions,    3*width/4-itemw);
    topPositions = cat(2,topPositions,       3*height/4-itemh);
    rightPositions = cat(2,rightPositions,  3*width/4+itemw);
    bottomPositions = cat(2,bottomPositions, 3*height/4+itemh);
    
    xPosition = width/3;
    yPosition = 3*height/4-itemh/2;
    Screen(w,'TextSize',50)
    DrawFormattedText(w, 'Also:', xPosition, yPosition, [0 0 0]);
    
%% Treatment1 Reward
    % These are here so that the cat()'s will have something to grab on to.
    
    draw = cat(1,draw,treat1Itemt);
    leftPositions = cat(2,leftPositions,    frame1Center-itemw);
    topPositions = cat(2,topPositions,       frameHeightCenter-itemh);
    rightPositions = cat(2,rightPositions,  frame1Center+itemw);
    bottomPositions = cat(2,bottomPositions, frameHeightCenter+itemh);

%% Treatment2 Reward
    piew = framew/3;
    pieh = piew;
    
    pwPieL1= frame2Center + piew/2;
    pwPieL2= pwPieL1 - piew;
    
    phPie1 = frameEccenh + 10;
    phPie2 = phPie1 + pieh;
    
    pwL1= frame2Center + 2*itemw + 2*itemEccen;
    pwL2= pwL1 - itemw;
    pwL3= pwL2 - itemEccen;
    pwL4= pwL3 - itemw;
    pwL5= pwL4 - itemEccen;
    pwL6= pwL5 - itemw;
    pwL7= pwL6 - itemEccen;
    pwL8= pwL7 - itemw;
    
    ph1= phPie2 + itemEccen;
    ph2= ph1 + itemh;
    ph3= ph2 + itemEccen;
    ph4= ph3 + itemh;
    ph5= ph4 + itemEccen;
    ph6= ph5 + itemh;
    
    % Box 1
     if treat2Amount >= 1;  %If there is supposed to be one or more item(s) on the left, Add all on the numbers that we need to add so that a image will be drawn in the 1 position
         draw = cat(1,draw,treat2Itemt);
         leftPositions = cat(2,leftPositions,    pwL8);
         topPositions = cat(2,topPositions,       ph1);
         rightPositions = cat(2,rightPositions,  pwL7);
         bottomPositions = cat(2,bottomPositions, ph2); 
         draw = cat(1,draw,pie7t);
         leftPositions = cat(2,leftPositions,    pwPieL2);
         topPositions = cat(2,topPositions,       phPie1);
         rightPositions = cat(2,rightPositions,  pwPieL1);
         bottomPositions = cat(2,bottomPositions, phPie2);
     end
     % Box 2
     if treat2Amount >= 2;
         draw = cat(1,draw,treat2Itemt);
         leftPositions = cat(2,leftPositions,    pwL6);
         topPositions = cat(2,topPositions,       ph1);
         rightPositions = cat(2,rightPositions,  pwL5);
         bottomPositions = cat(2,bottomPositions, ph2);
         draw = cat(1,draw,pie6t);
         leftPositions = cat(2,leftPositions,    pwPieL2);
         topPositions = cat(2,topPositions,       phPie1);
         rightPositions = cat(2,rightPositions,  pwPieL1);
         bottomPositions = cat(2,bottomPositions, phPie2);
     end
     % Box 3
     if treat2Amount >= 3;
         draw = cat(1,draw,treat2Itemt);
         leftPositions = cat(2,leftPositions,    pwL4);
         topPositions = cat(2,topPositions,       ph1);
         rightPositions = cat(2,rightPositions,  pwL3);
         bottomPositions = cat(2,bottomPositions, ph2);
         draw = cat(1,draw,pie5t);
         leftPositions = cat(2,leftPositions,    pwPieL2);
         topPositions = cat(2,topPositions,       phPie1);
         rightPositions = cat(2,rightPositions,  pwPieL1);
         bottomPositions = cat(2,bottomPositions, phPie2);
     end
     % Box 4
     if treat2Amount >= 4;
         draw = cat(1,draw,treat2Itemt);
         leftPositions = cat(2,leftPositions,    pwL2);
         topPositions = cat(2,topPositions,       ph1);
         rightPositions = cat(2,rightPositions,  pwL1);
         bottomPositions = cat(2,bottomPositions, ph2);
         draw = cat(1,draw,pie4t);
         leftPositions = cat(2,leftPositions,    pwPieL2);
         topPositions = cat(2,topPositions,       phPie1);
         rightPositions = cat(2,rightPositions,  pwPieL1);
         bottomPositions = cat(2,bottomPositions, phPie2);
     end
     % Box 5
     if treat2Amount >= 5;
         draw = cat(1,draw,treat2Itemt);
         leftPositions = cat(2,leftPositions,    pwL8);
         topPositions = cat(2,topPositions,       ph3);
         rightPositions = cat(2,rightPositions,  pwL7);
         bottomPositions = cat(2,bottomPositions, ph4);
         draw = cat(1,draw,pie3t);
         leftPositions = cat(2,leftPositions,    pwPieL2);
         topPositions = cat(2,topPositions,       phPie1);
         rightPositions = cat(2,rightPositions,  pwPieL1);
         bottomPositions = cat(2,bottomPositions, phPie2);
     end
     % Box 6
     if treat2Amount >= 6;
         draw = cat(1,draw,treat2Itemt);
         leftPositions = cat(2,leftPositions,    pwL6);
         topPositions = cat(2,topPositions,       ph3);
         rightPositions = cat(2,rightPositions,  pwL5);
         bottomPositions = cat(2,bottomPositions, ph4);
         draw = cat(1,draw,pie3t);
         leftPositions = cat(2,leftPositions,    pwPieL2);
         topPositions = cat(2,topPositions,       phPie1);
         rightPositions = cat(2,rightPositions,  pwPieL1);
         bottomPositions = cat(2,bottomPositions, phPie2);
     end
     % Box 7
     if treat2Amount >= 7;
         draw = cat(1,draw,treat2Itemt);
         leftPositions = cat(2,leftPositions,    pwL4);
         topPositions = cat(2,topPositions,       ph3);
         rightPositions = cat(2,rightPositions,  pwL3);
         bottomPositions = cat(2,bottomPositions, ph4);
         draw = cat(1,draw,pie3t);
         leftPositions = cat(2,leftPositions,    pwPieL2);
         topPositions = cat(2,topPositions,       phPie1);
         rightPositions = cat(2,rightPositions,  pwPieL1);
         bottomPositions = cat(2,bottomPositions, phPie2);
     end
     % Box 8
     if treat2Amount >= 8;
         draw = cat(1,draw,treat2Itemt);
         leftPositions = cat(2,leftPositions,    pwL2);
         topPositions = cat(2,topPositions,       ph3);
         rightPositions = cat(2,rightPositions,  pwL1);
         bottomPositions = cat(2,bottomPositions, ph4);
         draw = cat(1,draw,pie2t);
         leftPositions = cat(2,leftPositions,    pwPieL2);
         topPositions = cat(2,topPositions,       phPie1);
         rightPositions = cat(2,rightPositions,  pwPieL1);
         bottomPositions = cat(2,bottomPositions, phPie2);
     end
     % Box 9
     if treat2Amount >= 9;
         draw = cat(1,draw,treat2Itemt);
         leftPositions = cat(2,leftPositions,    pwL8);
         topPositions = cat(2,topPositions,       ph5);
         rightPositions = cat(2,rightPositions,  pwL7);
         bottomPositions = cat(2,bottomPositions, ph6);
         draw = cat(1,draw,pie2t);
         leftPositions = cat(2,leftPositions,    pwPieL2);
         topPositions = cat(2,topPositions,       phPie1);
         rightPositions = cat(2,rightPositions,  pwPieL1);
         bottomPositions = cat(2,bottomPositions, phPie2);
     end
     % Box 10
     if treat2Amount >= 10;
         draw = cat(1,draw,treat2Itemt);
         leftPositions = cat(2,leftPositions,    pwL6);
         topPositions = cat(2,topPositions,       ph5);
         rightPositions = cat(2,rightPositions,  pwL5);
         bottomPositions = cat(2,bottomPositions, ph6);
         draw = cat(1,draw,pie2t);
         leftPositions = cat(2,leftPositions,    pwPieL2);
         topPositions = cat(2,topPositions,       phPie1);
         rightPositions = cat(2,rightPositions,  pwPieL1);
         bottomPositions = cat(2,bottomPositions, phPie2);
     end
     % Box 11
     if treat2Amount >= 11;
         draw = cat(1,draw,treat2Itemt);
         leftPositions = cat(2,leftPositions,    pwL4);
         topPositions = cat(2,topPositions,       ph5);
         rightPositions = cat(2,rightPositions,  pwL3);
         bottomPositions = cat(2,bottomPositions, ph6);
         draw = cat(1,draw,pie2t);
         leftPositions = cat(2,leftPositions,    pwPieL2);
         topPositions = cat(2,topPositions,       phPie1);
         rightPositions = cat(2,rightPositions,  pwPieL1);
         bottomPositions = cat(2,bottomPositions, phPie2);
     end
     % Box 12
     if treat2Amount >= 12;
         draw = cat(1,draw,treat2Itemt);
         leftPositions = cat(2,leftPositions,    pwL2);
         topPositions = cat(2,topPositions,       ph5);
         rightPositions = cat(2,rightPositions,  pwL1);
         bottomPositions = cat(2,bottomPositions, ph6);
         draw = cat(1,draw,pie1t);
         leftPositions = cat(2,leftPositions,    pwPieL2);
         topPositions = cat(2,topPositions,       phPie1);
         rightPositions = cat(2,rightPositions,  pwPieL1);
         bottomPositions = cat(2,bottomPositions, phPie2);
     end
     
     
%% Treatment3 Reward
    pwhand = framew/5;
    
    % Everything below here is coded in terms of the numbers above
    pwHandL1= frame3Center + pwhand/2;
    pwHandL2= pwHandL1 - pwhand;
    
    pwL1= frame3Center + 1/2*itemw + itemEccen + itemw + itemEccen + itemw; %defined in terms of the center of the left side of the screen. This ensures that the left bundles are all centered
    pwL2= pwL1 - itemw;
    pwL3= pwL2 - itemEccen;
    pwL4= pwL3 - itemw;
    pwL5= pwL4 - itemEccen;
    pwL6= pwL5 - itemw;
    pwL7= pwL6 - itemEccen;
    pwL8= pwL7 - itemw;
    pwL9= pwL8 - itemEccen;
    pwL10= pwL9 - itemw;
   
    ph1= frameEccenh + 30;
    ph2= ph1 + 0.8*itemh;
    ph3= ph2;
    ph4= ph3 + itemh;
    ph7= frameHeightCenter + 5;
    ph8= ph7 + 0.8*itemh;
    ph9= ph8;
    ph10= ph9 + itemh;
    
     if treat3Me >= 0;  %If there is supposed to be one or more item(s) on the left, Add all on the numbers that we need to add so that a image will be drawn in the 1 position
         draw = cat(1,draw,met);
         leftPositions = cat(2,leftPositions,    pwHandL2);
         topPositions = cat(2,topPositions,       ph1);
         rightPositions = cat(2,rightPositions,  pwHandL1);
         bottomPositions = cat(2,bottomPositions, ph2);      
     end
     % Box 1
     if treat3Me >= 1;  %If there is supposed to be one or more item(s) on the left, Add all on the numbers that we need to add so that a image will be drawn in the 1 position
         draw = cat(1,draw,treat3Itemt);
         leftPositions = cat(2,leftPositions,    pwL10);
         topPositions = cat(2,topPositions,       ph3);
         rightPositions = cat(2,rightPositions,  pwL9);
         bottomPositions = cat(2,bottomPositions, ph4); 
         draw = cat(1,draw,met);
         leftPositions = cat(2,leftPositions,    pwHandL2);
         topPositions = cat(2,topPositions,       ph1);
         rightPositions = cat(2,rightPositions,  pwHandL1);
         bottomPositions = cat(2,bottomPositions, ph2);      
     end
     % Box 2
     if treat3Me >= 2;
         draw = cat(1,draw,treat3Itemt);
         leftPositions = cat(2,leftPositions,    pwL8);
         topPositions = cat(2,topPositions,       ph3);
         rightPositions = cat(2,rightPositions,  pwL7);
         bottomPositions = cat(2,bottomPositions, ph4);
         draw = cat(1,draw,met);
         leftPositions = cat(2,leftPositions,    pwHandL2);
         topPositions = cat(2,topPositions,       ph1);
         rightPositions = cat(2,rightPositions,  pwHandL1);
         bottomPositions = cat(2,bottomPositions, ph2);
     end
     % Box 3
     if treat3Me >= 3;
         draw = cat(1,draw,treat3Itemt);
         leftPositions = cat(2,leftPositions,    pwL6);
         topPositions = cat(2,topPositions,       ph3);
         rightPositions = cat(2,rightPositions,  pwL5);
         bottomPositions = cat(2,bottomPositions, ph4);
         draw = cat(1,draw,met);
         leftPositions = cat(2,leftPositions,    pwHandL2);
         topPositions = cat(2,topPositions,       ph1);
         rightPositions = cat(2,rightPositions,  pwHandL1);
         bottomPositions = cat(2,bottomPositions, ph2);
     end
     % Box 4
     if treat3Me >= 4;
         draw = cat(1,draw,treat3Itemt);
         leftPositions = cat(2,leftPositions,    pwL4);
         topPositions = cat(2,topPositions,       ph3);
         rightPositions = cat(2,rightPositions,  pwL3);
         bottomPositions = cat(2,bottomPositions, ph4);
         draw = cat(1,draw,met);
         leftPositions = cat(2,leftPositions,    pwHandL2);
         topPositions = cat(2,topPositions,       ph1);
         rightPositions = cat(2,rightPositions,  pwHandL1);
         bottomPositions = cat(2,bottomPositions, ph2);
     end
     % Box 5
     if treat3Me >= 5;
         draw = cat(1,draw,treat3Itemt);
         leftPositions = cat(2,leftPositions,    pwL2);
         topPositions = cat(2,topPositions,       ph3);
         rightPositions = cat(2,rightPositions,  pwL1);
         bottomPositions = cat(2,bottomPositions, ph4);
         draw = cat(1,draw,met);
         leftPositions = cat(2,leftPositions,    pwHandL2);
         topPositions = cat(2,topPositions,       ph1);
         rightPositions = cat(2,rightPositions,  pwHandL1);
         bottomPositions = cat(2,bottomPositions, ph2);
     end
     if treat3Other >= 0;  %If there is supposed to be one or more item(s) on the left, Add all on the numbers that we need to add so that a image will be drawn in the 1 position
         draw = cat(1,draw,othert);
         leftPositions = cat(2,leftPositions,    pwHandL2);
         topPositions = cat(2,topPositions,       ph7);
         rightPositions = cat(2,rightPositions,  pwHandL1);
         bottomPositions = cat(2,bottomPositions, ph8);
     end
     % Box 1
     if treat3Other >= 1;  %If there is supposed to be one or more item(s) on the left, Add all on the numbers that we need to add so that a image will be drawn in the 1 position
         draw = cat(1,draw,treat3Itemt);
         leftPositions = cat(2,leftPositions,    pwL10);
         topPositions = cat(2,topPositions,       ph9);
         rightPositions = cat(2,rightPositions,  pwL9);
         bottomPositions = cat(2,bottomPositions, ph10); 
         draw = cat(1,draw,othert);
         leftPositions = cat(2,leftPositions,    pwHandL2);
         topPositions = cat(2,topPositions,       ph7);
         rightPositions = cat(2,rightPositions,  pwHandL1);
         bottomPositions = cat(2,bottomPositions, ph8);      
     end
     % Box 2
     if treat3Other >= 2;
         draw = cat(1,draw,treat3Itemt);
         leftPositions = cat(2,leftPositions,    pwL8);
         topPositions = cat(2,topPositions,       ph9);
         rightPositions = cat(2,rightPositions,  pwL7);
         bottomPositions = cat(2,bottomPositions, ph10);
         draw = cat(1,draw,othert);
         leftPositions = cat(2,leftPositions,    pwHandL2);
         topPositions = cat(2,topPositions,       ph7);
         rightPositions = cat(2,rightPositions,  pwHandL1);
         bottomPositions = cat(2,bottomPositions, ph8);
     end
     % Box 3
     if treat3Other >= 3;
         draw = cat(1,draw,treat3Itemt);
         leftPositions = cat(2,leftPositions,    pwL6);
         topPositions = cat(2,topPositions,       ph9);
         rightPositions = cat(2,rightPositions,  pwL5);
         bottomPositions = cat(2,bottomPositions, ph10);
         draw = cat(1,draw,othert);
         leftPositions = cat(2,leftPositions,    pwHandL2);
         topPositions = cat(2,topPositions,       ph7);
         rightPositions = cat(2,rightPositions,  pwHandL1);
         bottomPositions = cat(2,bottomPositions, ph8);
     end
     % Box 4
     if treat3Other >= 4;
         draw = cat(1,draw,treat3Itemt);
         leftPositions = cat(2,leftPositions,    pwL4);
         topPositions = cat(2,topPositions,       ph9);
         rightPositions = cat(2,rightPositions,  pwL3);
         bottomPositions = cat(2,bottomPositions, ph10);
         draw = cat(1,draw,othert);
         leftPositions = cat(2,leftPositions,    pwHandL2);
         topPositions = cat(2,topPositions,       ph7);
         rightPositions = cat(2,rightPositions,  pwHandL1);
         bottomPositions = cat(2,bottomPositions, ph8);
     end
     % Box 5
     if treat3Other >= 5;
         draw = cat(1,draw,treat3Itemt);
         leftPositions = cat(2,leftPositions,    pwL2);
         topPositions = cat(2,topPositions,       ph9);
         rightPositions = cat(2,rightPositions,  pwL1);
         bottomPositions = cat(2,bottomPositions, ph10);
         draw = cat(1,draw,othert);
         leftPositions = cat(2,leftPositions,    pwHandL2);
         topPositions = cat(2,topPositions,       ph7);
         rightPositions = cat(2,rightPositions,  pwHandL1);
         bottomPositions = cat(2,bottomPositions, ph8);
     end


%% Combine it all
v = cat(1,leftPositions,topPositions,rightPositions,bottomPositions);
Screen('DrawTextures',w,draw,[],v);
end


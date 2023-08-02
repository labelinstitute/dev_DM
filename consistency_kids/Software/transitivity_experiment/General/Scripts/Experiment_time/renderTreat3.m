function [ output_args ] = renderTreat3( item,amountMeLeft, amountOtherLeft, amountMeRight, amountOtherRight, w, responseTime, buttonDown)
% Author: Niree Kodaverdian

screenNumber = max(Screen('Screens'));
    [width height] = Screen('WindowSize', screenNumber);
    black = imread('black.jpg');
    grey = imread('grey.jpg');
    me = imread('me.jpg');
    other = imread('other.jpg');
    lightGrey = imread('lightGrey.jpg');
    
     %% Make all of the textures
    itemt = Screen('MakeTexture',w,item);
    blackt = Screen('MakeTexture',w,black);
    greyt = Screen('MakeTexture',w,grey);
    met = Screen('MakeTexture',w,me);
    othert = Screen('MakeTexture',w,other);
    lightGreyt = Screen('MakeTexture',w,lightGrey);
    
    
     %% These are all of the position constants  

    centerw = width/2;  % This the center width of the screen
    centerLeft = width/4;
    centerRight = 3*width/4;
    centerh = height/2; % The center of the height of the screen
    itemw =   (2*width)/31;       % The width of one item in the array
    itemh =   1.5*itemw;% The height of one item in the array
    eccen =   itemw/4;       % This is the eccentricity. Distance from the center to the right edge of the array
    eccenh = 0;
    
    devLineHeight = height*.9;  % The height of the black box inthe middle of the screen
    devLineWidth  = 1;          % The width of the black box in the middle of the screen
    
    % Everything below here is coded in terms of the numbers above
    
    pwPieL1= centerLeft + width/20;
    pwPieL2= pwPieL1 - width/10;
    
    pwPieR1= centerRight - width/20;
    pwPieR2= pwPieR1 + width/10;
    
    pwL1= centerLeft + 1/2*itemw + eccen + itemw + eccen + itemw; %defined in terms of the center of the left side of the screen. This ensures that the left bundles are all centered
    pwL2= pwL1 - itemw;
    pwL3= pwL2 - eccen;
    pwL4= pwL3 - itemw;
    pwL5= pwL4 - eccen;
    pwL6= pwL5 - itemw;
    pwL7= pwL6 - eccen;
    pwL8= pwL7 - itemw;
    pwL9= pwL8 - eccen;
    pwL10= pwL9 - itemw;
    
    pwR1= centerRight - 1/2*itemw - eccen - itemw - eccen - itemw; %defined in terms of the center of the right side of the screen. This ensures that the right bundles are all centered
    pwR2= pwR1 + itemw;
    pwR3= pwR2 + eccen;
    pwR4= pwR3 + itemw;
    pwR5= pwR4 + eccen;
    pwR6= pwR5 + itemw;
    pwR7= pwR6 + eccen;
    pwR8= pwR7 + itemw;
    pwR9= pwR8 + eccen;
    pwR10= pwR9 + itemw;
    
    % If arranging the items with 3 in top row and 2 in bottom, then use
    % ph11 and ph12 for the second row items (i.e. for all of those "if"
    % loops that specify display location coordinates for equal/more than 4
    % items, change the height specifications from ph9 and ph10 to ph11 and
    % ph12. When items are arranged in one row, all "other" bundle item
    % heights will be specified by ph9 and ph10. The above statements apply
    % to "me" bundle specifications as well. With the 3-2 arrangement, ph5
    % and ph6 will be used as well. With a one row arrangement, all item
    % heights are defined by ph3 and ph4. 
    ph1= itemh;
    ph2= ph1 + 0.8*itemh;
    ph3= ph2 + eccenh;
    ph4= ph3 + itemh;
    ph5= ph4 + eccenh;
    ph6= ph5 + itemh;
    ph7= centerh + itemh/3;
    ph8= ph7 + 0.8*itemh;
    ph9= ph8 + eccenh;
    ph10= ph9 + itemh;
    ph11= ph10 + eccenh;
    ph12= ph11 + itemh;
    
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
    
     % LEFT
     if amountMeLeft >= 0;  %If there is supposed to be one or more item(s) on the left, Add all on the numbers that we need to add so that a image will be drawn in the 1 position
         draw = cat(1,draw,met);
         leftPositions = cat(2,leftPositions,    pwPieL2);
         topPositions = cat(2,topPositions,       ph1);
         rightPositions = cat(2,rightPositions,  pwPieL1);
         bottomPositions = cat(2,bottomPositions, ph2);      
     end
     % Box 1L
     if amountMeLeft >= 1;  %If there is supposed to be one or more item(s) on the left, Add all on the numbers that we need to add so that a image will be drawn in the 1 position
         draw = cat(1,draw,itemt);
         leftPositions = cat(2,leftPositions,    pwL10);
         topPositions = cat(2,topPositions,       ph3);
         rightPositions = cat(2,rightPositions,  pwL9);
         bottomPositions = cat(2,bottomPositions, ph4); 
         draw = cat(1,draw,met);
         leftPositions = cat(2,leftPositions,    pwPieL2);
         topPositions = cat(2,topPositions,       ph1);
         rightPositions = cat(2,rightPositions,  pwPieL1);
         bottomPositions = cat(2,bottomPositions, ph2);      
     end
     % Box 2L
     if amountMeLeft >= 2;
         draw = cat(1,draw,itemt);
         leftPositions = cat(2,leftPositions,    pwL8);
         topPositions = cat(2,topPositions,       ph3);
         rightPositions = cat(2,rightPositions,  pwL7);
         bottomPositions = cat(2,bottomPositions, ph4);
         draw = cat(1,draw,met);
         leftPositions = cat(2,leftPositions,    pwPieL2);
         topPositions = cat(2,topPositions,       ph1);
         rightPositions = cat(2,rightPositions,  pwPieL1);
         bottomPositions = cat(2,bottomPositions, ph2);
     end
     % Box 3L
     if amountMeLeft >= 3;
         draw = cat(1,draw,itemt);
         leftPositions = cat(2,leftPositions,    pwL6);
         topPositions = cat(2,topPositions,       ph3);
         rightPositions = cat(2,rightPositions,  pwL5);
         bottomPositions = cat(2,bottomPositions, ph4);
         draw = cat(1,draw,met);
         leftPositions = cat(2,leftPositions,    pwPieL2);
         topPositions = cat(2,topPositions,       ph1);
         rightPositions = cat(2,rightPositions,  pwPieL1);
         bottomPositions = cat(2,bottomPositions, ph2);
     end
     % Box 4L
     if amountMeLeft >= 4;
         draw = cat(1,draw,itemt);
         leftPositions = cat(2,leftPositions,    pwL4);
         topPositions = cat(2,topPositions,       ph3);
         rightPositions = cat(2,rightPositions,  pwL3);
         bottomPositions = cat(2,bottomPositions, ph4);
         draw = cat(1,draw,met);
         leftPositions = cat(2,leftPositions,    pwPieL2);
         topPositions = cat(2,topPositions,       ph1);
         rightPositions = cat(2,rightPositions,  pwPieL1);
         bottomPositions = cat(2,bottomPositions, ph2);
     end
     % Box 5L
     if amountMeLeft >= 5;
         draw = cat(1,draw,itemt);
         leftPositions = cat(2,leftPositions,    pwL2);
         topPositions = cat(2,topPositions,       ph3);
         rightPositions = cat(2,rightPositions,  pwL1);
         bottomPositions = cat(2,bottomPositions, ph4);
         draw = cat(1,draw,met);
         leftPositions = cat(2,leftPositions,    pwPieL2);
         topPositions = cat(2,topPositions,       ph1);
         rightPositions = cat(2,rightPositions,  pwPieL1);
         bottomPositions = cat(2,bottomPositions, ph2);
     end
   
     
     % RIGHT
     if amountMeRight >= 0;  %If there is supposed to be one or more item(s) on the left, Add all on the numbers that we need to add so that a image will be drawn in the 1 position
         draw = cat(1,draw,met);
         leftPositions = cat(2,leftPositions,    pwPieR1);
         topPositions = cat(2,topPositions,       ph1);
         rightPositions = cat(2,rightPositions,  pwPieR2);
         bottomPositions = cat(2,bottomPositions, ph2);
     end
     % Box 1R
     if amountMeRight >= 1;  %If there is supposed to be one or more item(s) on the left, Add all on the numbers that we need to add so that a image will be drawn in the 1 position
         draw = cat(1,draw,itemt);
         leftPositions = cat(2,leftPositions,    pwR1);
         topPositions = cat(2,topPositions,       ph3);
         rightPositions = cat(2,rightPositions,  pwR2);
         bottomPositions = cat(2,bottomPositions, ph4);
         draw = cat(1,draw,met);
         leftPositions = cat(2,leftPositions,    pwPieR1);
         topPositions = cat(2,topPositions,       ph1);
         rightPositions = cat(2,rightPositions,  pwPieR2);
         bottomPositions = cat(2,bottomPositions, ph2);
     end
     % Box 2R
     if amountMeRight >= 2;
         draw = cat(1,draw,itemt);
         leftPositions = cat(2,leftPositions,    pwR3);
         topPositions = cat(2,topPositions,       ph3);
         rightPositions = cat(2,rightPositions,  pwR4);
         bottomPositions = cat(2,bottomPositions, ph4);
         draw = cat(1,draw,met);
         leftPositions = cat(2,leftPositions,    pwPieR1);
         topPositions = cat(2,topPositions,       ph1);
         rightPositions = cat(2,rightPositions,  pwPieR2);
         bottomPositions = cat(2,bottomPositions, ph2);
     end
     % Box 3R
     if amountMeRight >= 3;
         draw = cat(1,draw,itemt);
         leftPositions = cat(2,leftPositions,    pwR5);
         topPositions = cat(2,topPositions,       ph3);
         rightPositions = cat(2,rightPositions,  pwR6);
         bottomPositions = cat(2,bottomPositions, ph4);
         draw = cat(1,draw,met);
         leftPositions = cat(2,leftPositions,    pwPieR1);
         topPositions = cat(2,topPositions,       ph1);
         rightPositions = cat(2,rightPositions,  pwPieR2);
         bottomPositions = cat(2,bottomPositions, ph2);
     end
     % Box 4R
     if amountMeRight >= 4;
         draw = cat(1,draw,itemt);
         leftPositions = cat(2,leftPositions,    pwR7);
         topPositions = cat(2,topPositions,       ph3);
         rightPositions = cat(2,rightPositions,  pwR8);
         bottomPositions = cat(2,bottomPositions, ph4);
         draw = cat(1,draw,met);
         leftPositions = cat(2,leftPositions,    pwPieR1);
         topPositions = cat(2,topPositions,       ph1);
         rightPositions = cat(2,rightPositions,  pwPieR2);
         bottomPositions = cat(2,bottomPositions, ph2);
     end
     % Box 5R
     if amountMeRight >= 5;
         draw = cat(1,draw,itemt);
         leftPositions = cat(2,leftPositions,    pwR9);
         topPositions = cat(2,topPositions,       ph3);
         rightPositions = cat(2,rightPositions,  pwR10);
         bottomPositions = cat(2,bottomPositions, ph4);
         draw = cat(1,draw,met);
         leftPositions = cat(2,leftPositions,    pwPieR1);
         topPositions = cat(2,topPositions,       ph1);
         rightPositions = cat(2,rightPositions,  pwPieR2);
         bottomPositions = cat(2,bottomPositions, ph2);
     end
     
     % LEFT 
     if amountOtherLeft >= 0;  %If there is supposed to be one or more item(s) on the left, Add all on the numbers that we need to add so that a image will be drawn in the 1 position
         draw = cat(1,draw,othert);
         leftPositions = cat(2,leftPositions,    pwPieL2);
         topPositions = cat(2,topPositions,       ph7);
         rightPositions = cat(2,rightPositions,  pwPieL1);
         bottomPositions = cat(2,bottomPositions, ph8);      
     end
     % Box 1L
     if amountOtherLeft >= 1;  %If there is supposed to be one or more item(s) on the left, Add all on the numbers that we need to add so that a image will be drawn in the 1 position
         draw = cat(1,draw,itemt);
         leftPositions = cat(2,leftPositions,    pwL10);
         topPositions = cat(2,topPositions,       ph9);
         rightPositions = cat(2,rightPositions,  pwL9);
         bottomPositions = cat(2,bottomPositions, ph10); 
         draw = cat(1,draw,othert);
         leftPositions = cat(2,leftPositions,    pwPieL2);
         topPositions = cat(2,topPositions,       ph7);
         rightPositions = cat(2,rightPositions,  pwPieL1);
         bottomPositions = cat(2,bottomPositions, ph8);      
     end
     % Box 2L
     if amountOtherLeft >= 2;
         draw = cat(1,draw,itemt);
         leftPositions = cat(2,leftPositions,    pwL8);
         topPositions = cat(2,topPositions,       ph9);
         rightPositions = cat(2,rightPositions,  pwL7);
         bottomPositions = cat(2,bottomPositions, ph10);
         draw = cat(1,draw,othert);
         leftPositions = cat(2,leftPositions,    pwPieL2);
         topPositions = cat(2,topPositions,       ph7);
         rightPositions = cat(2,rightPositions,  pwPieL1);
         bottomPositions = cat(2,bottomPositions, ph8);
     end
     % Box 3L
     if amountOtherLeft >= 3;
         draw = cat(1,draw,itemt);
         leftPositions = cat(2,leftPositions,    pwL6);
         topPositions = cat(2,topPositions,       ph9);
         rightPositions = cat(2,rightPositions,  pwL5);
         bottomPositions = cat(2,bottomPositions, ph10);
         draw = cat(1,draw,othert);
         leftPositions = cat(2,leftPositions,    pwPieL2);
         topPositions = cat(2,topPositions,       ph7);
         rightPositions = cat(2,rightPositions,  pwPieL1);
         bottomPositions = cat(2,bottomPositions, ph8);
     end
     % Box 4L
     if amountOtherLeft >= 4;
         draw = cat(1,draw,itemt);
         leftPositions = cat(2,leftPositions,    pwL4);
         topPositions = cat(2,topPositions,       ph9);
         rightPositions = cat(2,rightPositions,  pwL3);
         bottomPositions = cat(2,bottomPositions, ph10);
         draw = cat(1,draw,othert);
         leftPositions = cat(2,leftPositions,    pwPieL2);
         topPositions = cat(2,topPositions,       ph7);
         rightPositions = cat(2,rightPositions,  pwPieL1);
         bottomPositions = cat(2,bottomPositions, ph8);
     end
     % Box 5L
     if amountOtherLeft >= 5;
         draw = cat(1,draw,itemt);
         leftPositions = cat(2,leftPositions,    pwL2);
         topPositions = cat(2,topPositions,       ph9);
         rightPositions = cat(2,rightPositions,  pwL1);
         bottomPositions = cat(2,bottomPositions, ph10);
         draw = cat(1,draw,othert);
         leftPositions = cat(2,leftPositions,    pwPieL2);
         topPositions = cat(2,topPositions,       ph7);
         rightPositions = cat(2,rightPositions,  pwPieL1);
         bottomPositions = cat(2,bottomPositions, ph8);
     end

     
     % RIGHT
     if amountOtherRight >= 0;  %If there is supposed to be one or more item(s) on the left, Add all on the numbers that we need to add so that a image will be drawn in the 1 position
         draw = cat(1,draw,othert);
         leftPositions = cat(2,leftPositions,    pwPieR1);
         topPositions = cat(2,topPositions,       ph7);
         rightPositions = cat(2,rightPositions,  pwPieR2);
         bottomPositions = cat(2,bottomPositions, ph8);
     end
     % Box 1R
     if amountOtherRight >= 1;  %If there is supposed to be one or more item(s) on the left, Add all on the numbers that we need to add so that a image will be drawn in the 1 position
         draw = cat(1,draw,itemt);
         leftPositions = cat(2,leftPositions,    pwR1);
         topPositions = cat(2,topPositions,       ph9);
         rightPositions = cat(2,rightPositions,  pwR2);
         bottomPositions = cat(2,bottomPositions, ph10);
         draw = cat(1,draw,othert);
         leftPositions = cat(2,leftPositions,    pwPieR1);
         topPositions = cat(2,topPositions,       ph7);
         rightPositions = cat(2,rightPositions,  pwPieR2);
         bottomPositions = cat(2,bottomPositions, ph8);
     end
     % Box 2R
     if amountOtherRight >= 2;
         draw = cat(1,draw,itemt);
         leftPositions = cat(2,leftPositions,    pwR3);
         topPositions = cat(2,topPositions,       ph9);
         rightPositions = cat(2,rightPositions,  pwR4);
         bottomPositions = cat(2,bottomPositions, ph10);
         draw = cat(1,draw,othert);
         leftPositions = cat(2,leftPositions,    pwPieR1);
         topPositions = cat(2,topPositions,       ph7);
         rightPositions = cat(2,rightPositions,  pwPieR2);
         bottomPositions = cat(2,bottomPositions, ph8);
     end
     % Box 3R
     if amountOtherRight >= 3;
         draw = cat(1,draw,itemt);
         leftPositions = cat(2,leftPositions,    pwR5);
         topPositions = cat(2,topPositions,       ph9);
         rightPositions = cat(2,rightPositions,  pwR6);
         bottomPositions = cat(2,bottomPositions, ph10);
         draw = cat(1,draw,othert);
         leftPositions = cat(2,leftPositions,    pwPieR1);
         topPositions = cat(2,topPositions,       ph7);
         rightPositions = cat(2,rightPositions,  pwPieR2);
         bottomPositions = cat(2,bottomPositions, ph8);
     end
     % Box 4R
     if amountOtherRight >= 4;
         draw = cat(1,draw,itemt);
         leftPositions = cat(2,leftPositions,    pwR7);
         topPositions = cat(2,topPositions,       ph9);
         rightPositions = cat(2,rightPositions,  pwR8);
         bottomPositions = cat(2,bottomPositions, ph10);
         draw = cat(1,draw,othert);
         leftPositions = cat(2,leftPositions,    pwPieR1);
         topPositions = cat(2,topPositions,       ph7);
         rightPositions = cat(2,rightPositions,  pwPieR2);
         bottomPositions = cat(2,bottomPositions, ph8);
     end
     % Box 5R
     if amountOtherRight >= 5;
         draw = cat(1,draw,itemt);
         leftPositions = cat(2,leftPositions,    pwR9);
         topPositions = cat(2,topPositions,       ph9);
         rightPositions = cat(2,rightPositions,  pwR10);
         bottomPositions = cat(2,bottomPositions, ph10);
         draw = cat(1,draw,othert);
         leftPositions = cat(2,leftPositions,    pwPieR1);
         topPositions = cat(2,topPositions,       ph7);
         rightPositions = cat(2,rightPositions,  pwPieR2);
         bottomPositions = cat(2,bottomPositions, ph8);
     end
   
    
     v = cat(1,leftPositions,topPositions,rightPositions,bottomPositions);
     
     Screen('DrawTextures',w,draw,[],v)
end


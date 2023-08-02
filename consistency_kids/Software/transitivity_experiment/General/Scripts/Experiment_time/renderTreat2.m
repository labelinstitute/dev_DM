function [ output_args ] = renderTreat2( item, amountLeft, amountRight, w, responseTime, buttonDown)
% Author: Niree Kodaverdian

screenNumber = max(Screen('Screens'));
    [width height] = Screen('WindowSize', screenNumber);
    black = imread('black.jpg');
    grey = imread('grey.jpg');
    lightGrey = imread('lightGrey.jpg');
    
    pie1 = imread('Pie1.jpg');
    pie2 = imread('Pie2.jpg');
    pie3 = imread('Pie3.jpg');
    pie4 = imread('Pie4.jpg');
    pie5 = imread('Pie5.jpg');
    pie6 = imread('Pie6.jpg');
    pie7 = imread('Pie7.jpg');

    
    %% Make all of the textures
    itemt = Screen('MakeTexture',w,item);

    blackt = Screen('MakeTexture',w,black);
    greyt = Screen('MakeTexture',w,grey);
    lightGreyt = Screen('MakeTexture',w,lightGrey);
    
    pie1t = Screen('MakeTexture',w,pie1);
    pie2t = Screen('MakeTexture',w,pie2);
    pie3t = Screen('MakeTexture',w,pie3);
    pie4t = Screen('MakeTexture',w,pie4);
    pie5t = Screen('MakeTexture',w,pie5);
    pie6t = Screen('MakeTexture',w,pie6);
    pie7t = Screen('MakeTexture',w,pie7);
    
    
    %% These are all of the position constants  

    centerw = width/2;    % This the center width of the screen
    centerLeft = width/4;
    centerRight = 3*width/4;
    centerh = height/2;   % The center of the height of the screen
    itemw =   (2*width)/31;   % The width of one item in the array
    itemh =   1.5*itemw;  % The height of one item in the array
    piew = width/8;
    pieh = piew; 
    eccen =   itemw/6;    % This is the eccentricity. Distance from the center to the right edge of the array
    eccenh = itemw/8;
    
    devLineHeight = height*.9;  % The height of the black box inthe middle of the screen
    devLineWidth  = 1;          % The width of the black box in the middle of the screen
    
    % Everything below here is coded in terms of the numbers above

    pwPieL1= centerLeft + piew/2;
    pwPieL2= pwPieL1 - piew;
    
    pwPieR1= centerRight - piew/2;
    pwPieR2= pwPieR1 + piew;
    
    phPie1 = centerh - 1.5*pieh;
    phPie2 = phPie1 + pieh;
    
    pwL1= centerw - itemw - eccen*3.5;
    pwL2= pwL1 - itemw;
    pwL3= pwL2 - eccen;
    pwL4= pwL3 - itemw;
    pwL5= pwL4 - eccen;
    pwL6= pwL5 - itemw;
    pwL7= pwL6 - eccen;
    pwL8= pwL7 - itemw;
    
    pwR1= centerw + itemw + eccen*3.5;
    pwR2= pwR1 + itemw;
    pwR3= pwR2 + eccen;
    pwR4= pwR3 + itemw;
    pwR5= pwR4 + eccen;
    pwR6= pwR5 + itemw;
    pwR7= pwR6 + eccen;
    pwR8= pwR7 + itemw;
    
    ph1= phPie2 + eccenh;
    ph2= ph1 + itemh;
    ph3= ph2 + eccenh;
    ph4= ph3 + itemh;
    ph5= ph4 + eccenh;
    ph6= ph5 + itemh;
    
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
    
    % Box 1L
     if amountLeft >= 1;  %If there is supposed to be one or more item(s) on the left, Add all on the numbers that we need to add so that a image will be drawn in the 1 position
         draw = cat(1,draw,itemt);
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
     % Box 2L
     if amountLeft >= 2;
         draw = cat(1,draw,itemt);
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
     % Box 3L
     if amountLeft >= 3;
         draw = cat(1,draw,itemt);
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
     % Box 4L
     if amountLeft >= 4;
         draw = cat(1,draw,itemt);
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
     % Box 5L
     if amountLeft >= 5;
         draw = cat(1,draw,itemt);
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
     % Box 6L
     if amountLeft >= 6;
         draw = cat(1,draw,itemt);
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
     % Box 7L
     if amountLeft >= 7;
         draw = cat(1,draw,itemt);
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
     % Box 8L
     if amountLeft >= 8;
         draw = cat(1,draw,itemt);
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
     % Box 9L
     if amountLeft >= 9;
         draw = cat(1,draw,itemt);
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
     % Box 10L
     if amountLeft >= 10;
         draw = cat(1,draw,itemt);
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
     % Box 11L
     if amountLeft >= 11;
         draw = cat(1,draw,itemt);
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
     % Box 12L
     if amountLeft >= 12;
         draw = cat(1,draw,itemt);
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
     
     % RIGHT
     
     % Box 1R
     if amountRight >= 1;  %If there is supposed to be one or more item(s) on the left, Add all on the numbers that we need to add so that a image will be drawn in the 1 position
         draw = cat(1,draw,itemt);
         leftPositions = cat(2,leftPositions,    pwR1);
         topPositions = cat(2,topPositions,       ph1);
         rightPositions = cat(2,rightPositions,  pwR2);
         bottomPositions = cat(2,bottomPositions, ph2);
         draw = cat(1,draw,pie7t);
         leftPositions = cat(2,leftPositions,    pwPieR1);
         topPositions = cat(2,topPositions,       phPie1);
         rightPositions = cat(2,rightPositions,  pwPieR2);
         bottomPositions = cat(2,bottomPositions, phPie2);
     end
     % Box 2R
     if amountRight >= 2;
         draw = cat(1,draw,itemt);
         leftPositions = cat(2,leftPositions,    pwR3);
         topPositions = cat(2,topPositions,       ph1);
         rightPositions = cat(2,rightPositions,  pwR4);
         bottomPositions = cat(2,bottomPositions, ph2);
         draw = cat(1,draw,pie6t);
         leftPositions = cat(2,leftPositions,    pwPieR1);
         topPositions = cat(2,topPositions,       phPie1);
         rightPositions = cat(2,rightPositions,  pwPieR2);
         bottomPositions = cat(2,bottomPositions, phPie2);
     end
     % Box 3R
     if amountRight >= 3;
         draw = cat(1,draw,itemt);
         leftPositions = cat(2,leftPositions,    pwR5);
         topPositions = cat(2,topPositions,       ph1);
         rightPositions = cat(2,rightPositions,  pwR6);
         bottomPositions = cat(2,bottomPositions, ph2);
         draw = cat(1,draw,pie5t);
         leftPositions = cat(2,leftPositions,    pwPieR1);
         topPositions = cat(2,topPositions,       phPie1);
         rightPositions = cat(2,rightPositions,  pwPieR2);
         bottomPositions = cat(2,bottomPositions, phPie2);
     end
     % Box 4R
     if amountRight >= 4;
         draw = cat(1,draw,itemt);
         leftPositions = cat(2,leftPositions,    pwR7);
         topPositions = cat(2,topPositions,       ph1);
         rightPositions = cat(2,rightPositions,  pwR8);
         bottomPositions = cat(2,bottomPositions, ph2);
         draw = cat(1,draw,pie4t);
         leftPositions = cat(2,leftPositions,    pwPieR1);
         topPositions = cat(2,topPositions,       phPie1);
         rightPositions = cat(2,rightPositions,  pwPieR2);
         bottomPositions = cat(2,bottomPositions, phPie2);
     end
     % Box 5R
     if amountRight >= 5;
         draw = cat(1,draw,itemt);
         leftPositions = cat(2,leftPositions,    pwR1);
         topPositions = cat(2,topPositions,       ph3);
         rightPositions = cat(2,rightPositions,  pwR2);
         bottomPositions = cat(2,bottomPositions, ph4);
         draw = cat(1,draw,pie3t);
         leftPositions = cat(2,leftPositions,    pwPieR1);
         topPositions = cat(2,topPositions,       phPie1);
         rightPositions = cat(2,rightPositions,  pwPieR2);
         bottomPositions = cat(2,bottomPositions, phPie2);
     end
     % Box 6R
     if amountRight >= 6;
         draw = cat(1,draw,itemt);
         leftPositions = cat(2,leftPositions,    pwR3);
         topPositions = cat(2,topPositions,       ph3);
         rightPositions = cat(2,rightPositions,  pwR4);
         bottomPositions = cat(2,bottomPositions, ph4);
         draw = cat(1,draw,pie3t);
         leftPositions = cat(2,leftPositions,    pwPieR1);
         topPositions = cat(2,topPositions,       phPie1);
         rightPositions = cat(2,rightPositions,  pwPieR2);
         bottomPositions = cat(2,bottomPositions, phPie2);
     end
     % Box 7R
     if amountRight >= 7;
         draw = cat(1,draw,itemt);
         leftPositions = cat(2,leftPositions,    pwR5);
         topPositions = cat(2,topPositions,       ph3);
         rightPositions = cat(2,rightPositions,  pwR6);
         bottomPositions = cat(2,bottomPositions, ph4);
         draw = cat(1,draw,pie3t);
         leftPositions = cat(2,leftPositions,    pwPieR1);
         topPositions = cat(2,topPositions,       phPie1);
         rightPositions = cat(2,rightPositions,  pwPieR2);
         bottomPositions = cat(2,bottomPositions, phPie2);
     end
     % Box 8R
     if amountRight >= 8;
         draw = cat(1,draw,itemt);
         leftPositions = cat(2,leftPositions,    pwR7);
         topPositions = cat(2,topPositions,       ph3);
         rightPositions = cat(2,rightPositions,  pwR8);
         bottomPositions = cat(2,bottomPositions, ph4);
         draw = cat(1,draw,pie2t);
         leftPositions = cat(2,leftPositions,    pwPieR1);
         topPositions = cat(2,topPositions,       phPie1);
         rightPositions = cat(2,rightPositions,  pwPieR2);
         bottomPositions = cat(2,bottomPositions, phPie2);
     end
     % Box 9R
     if amountRight >= 9;
         draw = cat(1,draw,itemt);
         leftPositions = cat(2,leftPositions,    pwR1);
         topPositions = cat(2,topPositions,       ph5);
         rightPositions = cat(2,rightPositions,  pwR2);
         bottomPositions = cat(2,bottomPositions, ph6);
         draw = cat(1,draw,pie2t);
         leftPositions = cat(2,leftPositions,    pwPieR1);
         topPositions = cat(2,topPositions,       phPie1);
         rightPositions = cat(2,rightPositions,  pwPieR2);
         bottomPositions = cat(2,bottomPositions, phPie2);
     end
     % Box 10R
     if amountRight >= 10;
         draw = cat(1,draw,itemt);
         leftPositions = cat(2,leftPositions,    pwR3);
         topPositions = cat(2,topPositions,       ph5);
         rightPositions = cat(2,rightPositions,  pwR4);
         bottomPositions = cat(2,bottomPositions, ph6);
         draw = cat(1,draw,pie2t);
         leftPositions = cat(2,leftPositions,    pwPieR1);
         topPositions = cat(2,topPositions,       phPie1);
         rightPositions = cat(2,rightPositions,  pwPieR2);
         bottomPositions = cat(2,bottomPositions, phPie2);
     end 
      % Box 11R
     if amountRight >= 11;
         draw = cat(1,draw,itemt);
         leftPositions = cat(2,leftPositions,    pwR5);
         topPositions = cat(2,topPositions,       ph5);
         rightPositions = cat(2,rightPositions,  pwR6);
         bottomPositions = cat(2,bottomPositions, ph6);
         draw = cat(1,draw,pie2t);
         leftPositions = cat(2,leftPositions,    pwPieR1);
         topPositions = cat(2,topPositions,       phPie1);
         rightPositions = cat(2,rightPositions,  pwPieR2);
         bottomPositions = cat(2,bottomPositions, phPie2);
     end
       % Box 12R
     if amountRight >= 12;
         draw = cat(1,draw,itemt);
         leftPositions = cat(2,leftPositions,    pwR7);
         topPositions = cat(2,topPositions,       ph5);
         rightPositions = cat(2,rightPositions,  pwR8);
         bottomPositions = cat(2,bottomPositions, ph6);
         draw = cat(1,draw,pie1t);
         leftPositions = cat(2,leftPositions,    pwPieR1);
         topPositions = cat(2,topPositions,       phPie1);
         rightPositions = cat(2,rightPositions,  pwPieR2);
         bottomPositions = cat(2,bottomPositions, phPie2);
     end
     
     v = cat(1,leftPositions,topPositions,rightPositions,bottomPositions);
     
     Screen('DrawTextures',w,draw,[],v)
     
end



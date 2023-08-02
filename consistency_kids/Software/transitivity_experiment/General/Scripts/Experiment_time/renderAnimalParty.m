function [ output_args ] = renderAnimalParty( number, animalsTX, index, w, confirmTime )
% Author: Niree Kodaverdian

    screenNumber = max(Screen('Screens'));
    [width height] = Screen('WindowSize', screenNumber);
    
    load('animalParty.mat');
    qmark = imread('qmark.png');
    lightGreen = imread('lightGreen.jpg');
    lightRed = imread('lightRed.jpg');
    qmarkt = Screen('MakeTexture',w,qmark);
    lightGreent = Screen('MakeTexture',w,lightGreen);
    lightRedt = Screen('MakeTexture',w,lightRed);

    %% These are all of the position constants  
    centerw = width/2;  % This is the center width of the screen
    centerh = height/2;
    itemw = width/8;
    itemh = 1.5*itemw;
    eccen = itemw/3;
    
    ph1 = centerh - itemh/2;
    ph2 = centerh + itemh/2;
    
    % When there are 2 animals on screen (from left to right)
    pw2L1 = centerw - itemw/2 - eccen - itemw;
    pw2L2 = pw2L1 + itemw;
    pw2R1 = pw2L2 + eccen;
    pw2R2 = pw2R1 + itemw;
    pw2QMark1 = pw2R2 + eccen;
    pw2QMark2 = pw2QMark1 + itemw;
    
    % When there are 3 animals on screen (from left to right)
    pw3L1 = centerw - eccen/2 - itemw - eccen - itemw;
    pw3L2 = pw3L1 + itemw;
    pw3M1 = pw3L2 + eccen;
    pw3M2 = pw3M1 + itemw;
    pw3R1 = pw3M2 + eccen;
    pw3R2 = pw3R1 + itemw;
    pw3QMark1 = pw3R2 + eccen;
    pw3QMark2 = pw3QMark1 + itemw;
    
    % When there are 4 animals on screen (from left to right)
    pw4LL1 = centerw - itemw/2 - eccen - itemw - eccen - itemw;
    pw4LL2 = pw4LL1 + itemw;
    pw4LM1 = pw4LL2 + eccen;
    pw4LM2 = pw4LM1 + itemw;
    pw4RM1 = pw4LM2 + eccen;
    pw4RM2 = pw4RM1 + itemw;
    pw4RR1 = pw4RM2 + eccen;
    pw4RR2 = pw4RR1 + itemw;
    pw4QMark1 = pw4RR2 + eccen;
    pw4QMark2 = pw4QMark1 + itemw;
    
    draw2 = [];
    leftPositions2 = [];
    topPositions2 = [];
    rightPositions2 = [];
    bottomPositions2 = [];
    
    draw3 = [];
    leftPositions3 = [];
    topPositions3 = [];
    rightPositions3 = [];
    bottomPositions3 = [];
    
    draw4 = [];
    leftPositions4 = [];
    topPositions4 = [];
    rightPositions4 = [];
    bottomPositions4 = [];
    
    yesBox = lightGreent;
    noBox = lightRedt;
        
    
    if number(index) == 2
        %the left animal
         draw2 = cat(1,draw2,animalsTX{animalParty(index,1)});
         leftPositions2 = cat(2,leftPositions2,    pw2L1);
         topPositions2 = cat(2,topPositions2,       ph1);
         rightPositions2 = cat(2,rightPositions2,  pw2L2);
         bottomPositions2 = cat(2,bottomPositions2, ph2); 
         
         %the question mark
         draw2 = cat(1,draw2,qmarkt);
         leftPositions2 = cat(2,leftPositions2,    pw2QMark1);
         topPositions2 = cat(2,topPositions2,       ph1);
         rightPositions2 = cat(2,rightPositions2,  pw2QMark2);
         bottomPositions2 = cat(2,bottomPositions2, ph2); 
         
         %the right animal
         draw2 = cat(1,draw2,animalsTX{animalParty(index,2)});
         leftPositions2 = cat(2,leftPositions2,    pw2R1);
         topPositions2 = cat(2,topPositions2,       ph1);
         rightPositions2 = cat(2,rightPositions2,  pw2R2);
         bottomPositions2 = cat(2,bottomPositions2, ph2); 
         
         if confirmTime == 1
             draw2 = cat(1,draw2,noBox);
             leftPositions2 = cat(2,leftPositions2,    width/40);
             topPositions2 = cat(2,topPositions2,      height/7);
             rightPositions2 = cat(2,rightPositions2,  width/40+width/10);
             bottomPositions2 = cat(2,bottomPositions2,height/40);
             
             draw2 = cat(1,draw2,yesBox);
             leftPositions2 = cat(2,leftPositions2,    width-width/40-width/10);
             topPositions2 = cat(2,topPositions2,      height/7);
             rightPositions2 = cat(2,rightPositions2,  width-width/40);
             bottomPositions2 = cat(2,bottomPositions2,height/40);
         end

         v2 = cat(1,leftPositions2,topPositions2,rightPositions2,bottomPositions2);
         Screen('DrawTextures',w,draw2,[],v2)
         
         
    elseif number(index) == 3
        %the left-most animal
         draw3 = cat(1,draw3,animalsTX{animalParty(index,1)});
         leftPositions3 = cat(2,leftPositions3,    pw3L1);
         topPositions3 = cat(2,topPositions3,       ph1);
         rightPositions3 = cat(2,rightPositions3,  pw3L2);
         bottomPositions3 = cat(2,bottomPositions3, ph2); 
         
         %the question mark
         draw3 = cat(1,draw3,qmarkt);
         leftPositions3 = cat(2,leftPositions3,    pw3QMark1);
         topPositions3 = cat(2,topPositions3,       ph1);
         rightPositions3 = cat(2,rightPositions3,  pw3QMark2);
         bottomPositions3 = cat(2,bottomPositions3, ph2); 
        
         %the middle-right animal
         draw3 = cat(1,draw3,animalsTX{animalParty(index,2)});
         leftPositions3 = cat(2,leftPositions3,    pw3M1);
         topPositions3 = cat(2,topPositions3,       ph1);
         rightPositions3 = cat(2,rightPositions3,  pw3M2);
         bottomPositions3 = cat(2,bottomPositions3, ph2); 
         
         %the right-most animal
         draw3 = cat(1,draw3,animalsTX{animalParty(index,3)});
         leftPositions3 = cat(2,leftPositions3,    pw3R1);
         topPositions3 = cat(2,topPositions3,       ph1);
         rightPositions3 = cat(2,rightPositions3,  pw3R2);
         bottomPositions3 = cat(2,bottomPositions3, ph2); 
         
         if confirmTime == 1
             draw3 = cat(1,draw3,noBox);
             leftPositions3 = cat(2,leftPositions3,    width/40);
             topPositions3 = cat(2,topPositions3,      height/7);
             rightPositions3 = cat(2,rightPositions3,  width/40+width/10);
             bottomPositions3 = cat(2,bottomPositions3,height/40);
             
             draw3 = cat(1,draw3,yesBox);
             leftPositions3 = cat(2,leftPositions3,    width-width/40-width/10);
             topPositions3 = cat(2,topPositions3,      height/7);
             rightPositions3 = cat(2,rightPositions3,  width-width/40);
             bottomPositions3 = cat(2,bottomPositions3,height/40);
         end

         v3 = cat(1,leftPositions3,topPositions3,rightPositions3,bottomPositions3); 
         Screen('DrawTextures',w,draw3,[],v3)

         
    elseif number(index) == 4
        %the left-most animal
         draw4 = cat(1,draw4,animalsTX{animalParty(index,1)});
         leftPositions4 = cat(2,leftPositions4,    pw4LL1);
         topPositions4 = cat(2,topPositions4,       ph1);
         rightPositions4 = cat(2,rightPositions4,  pw4LL2);
         bottomPositions4 = cat(2,bottomPositions4, ph2); 
         
         %the second to left animal
         draw4 = cat(1,draw4,animalsTX{animalParty(index,2)});
         leftPositions4 = cat(2,leftPositions4,    pw4LM1);
         topPositions4 = cat(2,topPositions4,       ph1);
         rightPositions4 = cat(2,rightPositions4,  pw4LM2);
         bottomPositions4 = cat(2,bottomPositions4, ph2); 
         
         %the question mark 
         draw4 = cat(1,draw4,qmarkt);
         leftPositions4 = cat(2,leftPositions4,    pw4QMark1);
         topPositions4 = cat(2,topPositions4,       ph1);
         rightPositions4 = cat(2,rightPositions4,  pw4QMark2);
         bottomPositions4 = cat(2,bottomPositions4, ph2); 
         
         %the second to right animal
         draw4 = cat(1,draw4,animalsTX{animalParty(index,3)});
         leftPositions4 = cat(2,leftPositions4,    pw4RM1);
         topPositions4 = cat(2,topPositions4,       ph1);
         rightPositions4 = cat(2,rightPositions4,  pw4RM2);
         bottomPositions4 = cat(2,bottomPositions4, ph2);
         
         %the right-most animal
         draw4 = cat(1,draw4,animalsTX{animalParty(index,4)});
         leftPositions4 = cat(2,leftPositions4,    pw4RR1);
         topPositions4 = cat(2,topPositions4,       ph1);
         rightPositions4 = cat(2,rightPositions4,  pw4RR2);
         bottomPositions4 = cat(2,bottomPositions4, ph2);
         
         if confirmTime == 1
             draw4 = cat(1,draw4,noBox);
             leftPositions4 = cat(2,leftPositions4,    width/40);
             topPositions4 = cat(2,topPositions4,      height/7);
             rightPositions4 = cat(2,rightPositions4,  width/40+width/10);
             bottomPositions4 = cat(2,bottomPositions4,height/40);
             
             draw4 = cat(1,draw4,yesBox);
             leftPositions4 = cat(2,leftPositions4,    width-width/40-width/10);
             topPositions4 = cat(2,topPositions4,      height/7);
             rightPositions4 = cat(2,rightPositions4,  width-width/40);
             bottomPositions4 = cat(2,bottomPositions4,height/40);
         end
         
         v4 = cat(1,leftPositions4,topPositions4,rightPositions4,bottomPositions4);
         Screen('DrawTextures',w,draw4,[],v4);


    end
    
 
    
end


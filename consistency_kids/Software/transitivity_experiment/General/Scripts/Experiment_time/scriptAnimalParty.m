function [behavioralSecs, behavioralKey] = scriptAnimalParty( w, input, width, height)
% Author: Niree Kodaverdian

bee = imread('beeWhite.png');
chicken = imread('chickenWhite.png');
owl = imread('owlWhite.png'); 
goat = imread('goatWhite.png');
llama = imread('llamaWhite.png'); 
mouse = imread('tan_mouseWhite.png');
squirrel = imread('squirrelWhite.png'); 
dog = imread('dogWhite.png');
pterodactyl = imread('pterodactylWhite.png'); 
rhino = imread('rhinoWhite.png');
zebra = imread('zebraWhite.png'); 
penguin = imread('penguinWhite.png');
beaver = imread('beaverWhite.png');
sheep = imread('sheepWhite.png');
bunny = imread('bunnyWhite.png');
peacock = imread('peacockWhite.png');

animals = {chicken bee llama mouse owl goat zebra beaver penguin sheep bunny...
    rhino pterodactyl peacock squirrel dog}; 

animalNames = {'chicken' 'bee' 'llama' 'mouse' 'owl' 'goat' 'zebra' 'beaver'...
    'penguin' 'sheep' 'bunny' 'rhino' 'pterodactyl' 'peacock' 'squirrel' ...
    'dog'}; 

load('animalParty.mat');

number = zeros(1,7); % NUMBER OF ANIMAL PARTY TRIALS

for i = 1:7 % NUMBER OF ANIMAL PARTY TRIALS
    if animalParty(i,3) == 0
        number(i) = 2;
    elseif animalParty(i,3) > 0
        number(i) = 3;
    end
end

for i = 1:16 % CHANGE IF CHANGING NUMBER OF ANIMAL PARTY TRIALS - THIS IS TOTAL NUMBER OF ANIMALS THAT WILL BE RENDERED FOR RESPONSE PROMPTS
    animalsTX{i} = genvarname(strcat(animalNames{i},'TX'));  % make an array of the names that will be assigned to textured images
    animalsTX{i} = Screen('MakeTexture',w,animals{i}); % texturize images and match .TX names of array to textured images
end

behavioralKey = zeros(1,length(number));

z = 0;
a = 1; %this is just for the 

for i = 1:length(number); %length of number == length of animalParty == 7 trials
    while z == 0;
        index = i;
        confirmTime = 0;
        renderAnimalParty(number, animalsTX, index, w, confirmTime);
        [VBLTimestamp StimulusOnsetTime FlipTimestamp] = Screen('Flip',w);
        [behavioralSecs, behavioralKey] = touchAnimalResponse(w, input, number, index, StimulusOnsetTime);
        if behavioralKey == '1'
            buttonDown = 1;
        elseif behavioralKey == '2'
            buttonDown = 2;
        elseif behavioralKey == '3'
            buttonDown = 3;
        elseif behavioralKey == '4'
            buttonDown = 4;
        elseif behavioralKey == '0'
            buttonDown = 0;
        end
        %renderAnimalFeedback(buttonDown, number, index, w); use this if
        %you want feedback to be a frame drawn around the selected animal
        renderAnimalHatFeedback(buttonDown, number, index, w); % use this if you want feedback to be in form of party hat on animal's head!
        confirmTime = 1;
        renderAnimalParty(number, animalsTX, index, w, confirmTime);
        Screen('Flip',w);
        [ confirmKey ] = touchConfirmRanking( w, input );
        behavioral.secs(index,1) = behavioralSecs;
        behavioral.key(index,1) = behavioralKey;
        if confirmKey == 'n';
            z = z + 0;
        elseif confirmKey == 'y';
            z = z + 1;
        end
    end
        if index < 7 % NUMBER OF ANIMAL PARTY TRIALS
            drawEar(w);
            Screen('Flip',w);
            WaitSecs(0.3); % should be 3 make this longer for actual experiment (60 secs)
            touchHotSpot(w, width, height,input);
        elseif index == 7  % NUMBER OF ANIMAL PARTY TRIALS
            a = a + 0;
        end
        z = 0;
end

behavioralSecs = behavioral.secs;
behavioralKey = behavioral.key;

end 


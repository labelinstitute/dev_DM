function [ output_args ] = drawStart(w)
% Author: Niree Kodaverdian

screenNumber = max(Screen('Screens'));
[width height] = Screen('WindowSize', screenNumber);


    if exist('w','var') == 0;
        w = Screen(screenNumber, 'OpenWindow',[],[],[],[]);
    end
Screen(w,'TextSize',70)
DrawFormattedText(w, 'Wait for Instructions.\n\nDo not touch anything.', 'center', 'center', [0 0 0]);

% Screen('Flip',w);
% WaitSecs(.2)
% KbWait
% Screen('CloseAll') 

end


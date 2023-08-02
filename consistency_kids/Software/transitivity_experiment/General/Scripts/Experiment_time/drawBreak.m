function [ output_args ] = drawBreak( w )
% Author: Niree Kodaverdian

    if exist('w','var') == 0;
        screenNumber = max(Screen('Screens'));
        w = Screen(screenNumber, 'OpenWindow',[],[],[],[]);
    end
Screen(w,'TextSize',300)
DrawFormattedText(w, 'break', 'center', 'center', [0 0 0]);


end


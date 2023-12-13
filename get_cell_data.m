% Function that receives the cell index and it returns the tiff file name, the MATLAB data file, the frame of the laser wound and the time interval in seconds.

%% Beginning of function
function [cell_data, name, fr_lw, time_int] = get_cell_data(cell_id)

if cell_id == 1
    name = 'Exp1 cell1';
    load(fullfile('..', ['Data/' name '.mat']));
    cell_data = lifeact;
    fr_lw = 19; time_int = 20;
elseif cell_id == 2
    name = 'Exp1 cell2';
    load(fullfile('..', ['Data/' name '.mat']));
    cell_data = lifeact;
    fr_lw = 23; time_int = 20;
end



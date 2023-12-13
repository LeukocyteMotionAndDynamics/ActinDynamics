% Function that receives the neutrophil index and returns the cell tiff file name, 
% the pixel size, the time interval, the cell centroid, the laser wound perimeter
% and the frame at the tiff file that the laser wound was done
% Cell centroid and wound perimeter are given in pixels, pixel size in um/pix.


%% Beginning of function

function [name, pixel, time_int, cell_x, cell_y, lw_x, lw_y, fr_lw] = lifeact_data(cell_id)

if cell_id == 1
    name = 'Exp1 cell1';
    pixel = 0.6729163;
    time_int = 20;
    cell_x = 306; cell_y = 18;
    lw_x = [345;327;323;330;341;358;378;392;395;388;385;366];
    lw_y = [161;175;195;212;229;244;247;233;214;190;170;160];
    fr_lw = 20;
elseif cell_id == 2
    name = 'Exp1 cell2';
    pixel = 0.6729163;
    time_int = 20;
    cell_x = 231; cell_y = 106;
    lw_x = [345;327;323;330;341;358;378;392;395;388;385;366];
    lw_y = [161;175;195;212;229;244;247;233;214;190;170;160];
    fr_lw = 23;
end



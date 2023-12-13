% Function that receives the cell index, cell image file, frame from cell image file,
% the cell coorinates in 2D for the first time frame, the centroid of cell for time 
% frames > 2 and the threshold of size of objects to eliminate

%% Beginning of function

function [bw, mask] = cell_segment(cell_id, im, kk, cell_x, cell_y, ...
    centroids, size_thresh)

if cell_id == 1
    % Create the mask
    mask = zeros(size(im));
    if kk == 1
        mask(cell_y-7:cell_y+7, cell_x-7:cell_x+7) = 1;
    else
        mask(round(centroids(kk-1,1))-3:round(centroids(kk-1,1))+3, ...
            round(centroids(kk-1,2))-3:round(centroids(kk-1,2))+3) = 1;
    end
    % Apply active contour segmentation
    bw = activecontour(im, mask, 300, 'Chan-Vese', 'SmoothFactor', 0.7, ...
        'ContractionBias', -0.6);
    end
    % Eliminate any small particles that resulted from segmentation
    bw = bwareaopen(bw, size_thresh);
    
elseif cell_id == 2
    % Create the mask
    mask = zeros(size(im));
    if kk == 1
        mask(cell_y-7:cell_y+7, cell_x-7:cell_x+7) = 1;
    else
        mask(round(centroids(kk-1,1))-3:round(centroids(kk-1,1))+3, ...
            round(centroids(kk-1,2))-3:round(centroids(kk-1,2))+3) = 1;
    end
    % Apply active contour segmentation
    bw = activecontour(im, mask, 200, 'Chan-Vese', 'SmoothFactor', 0.7, ...
        'ContractionBias', -0.4);
    end
    % Eliminate any small particles that resulted from segmentation
    bw = bwareaopen(bw, size_thresh);

end


% Script to segment and track cells using active contours; then it 
% calculates front and rear lifeact intensity


%% Initialise some parameters


% Define the number of cells
num_cell = 21;

% Threshold on size of detected objects
size_thresh = 10;

% Select to draw cell contour and to save the contour
draw_contour = 1; save_contour = 1; 


%% Loop over all neutrophils
for cell_id = 1:num_cell
    
    % Get cell data
    [name, pixel, time_int, cell_x, cell_y, wound_x, wound_y, fr_lw] = cell_data(cell_id);
    
    % Get the image file
    file = ['Images/' name '.tif'];
    
    % Get the file information so as to find the number of time-frames
    info = imfinfo(file);
    num_images = numel(info);
    
    % Initialise the centroid list
    centroids = zeros(num_images,2);
    
    % Initialise the structure to save data
    cell_data_output = struct();
    
    % Loop over all frames of this cell
    for frame_id = 1:num_images
        
        % Comment in command window to confirm which frame is analysed
        disp(['Running neutrophil ' num2str(cell_id) ' / time-point ' ...
            num2str(frame_id) '/' num2str(num_images)]);    
        
        % Read image and save as variable 
        im = imread(file, frame_id, 'Info', info); im_init = im;
        
        % Transform the image into 2D if it is 3D
        if ndims(im) == 3
            im = rgb2gray(im);   
        end
        
        % Transform image into 2D and double-precision
        im = im2double(im);
        
        % Initialise the final binary mask
        bwfinal = zeros(size(im));
        
        % Apply active contour segmentation
        bw = cell_segment(cell_id, im, frame_id, cell_x, cell_y, ...
            centroids, size_thresh);
        
        % Get the cell centroid ; the centroid comes as [y,x]
        [cell_image, centroids(frame_id,:), boundary] = get_cell(im, bw);
        cell_data_output(frame_id).centroid = centroids(frame_id,:);
        
        % Calculate the mean front and rear lifeact intensity
        if frame_id > 1
            
            % Find the line to separate the neutrophil to front and back
            [line_x, line_y] = find_line(centroids, frame_id);
            
            % Divide cell in front and back
            [pix_front, pix_back, cell_x_all, cell_y_all, idx_back, ...
                idx_front] = divide_cell(cell_image, line_x, line_y);
            
            % Calculate mean and std for neutrophil front and back
            cell_data_output(frame_id).lifeact_mean_back = mean(pix_back(:));
            cell_data_output(frame_id).lifeact_mean_front = mean(pix_front(:));
        
    %% Save neutrophil data into file
    save([name '.mat'], 'cell_data_output', 'time_int', 'pixel', 'num_images');
    
end



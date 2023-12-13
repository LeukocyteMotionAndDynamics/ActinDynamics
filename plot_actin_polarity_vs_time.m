% Script to plot the actin polarity (front/rear) with time and the SEM
% It uses the following function:
% https://se.mathworks.com/matlabcentral/fileexchange/27485-boundedline-m


%% Define parameters

% Define the number of cells
num_cells = 2;

% Define the number of frames to get data before and after wound
num_fr_calc = 40;

% Define smoothing factor
smooth_factor = 5;

% Initialise matrix for all data
actin_norm_pre = nan(num_cells, num_fr_calc)';
actin_norm_post = nan(num_cells, num_fr_calc)';


%% Loop over all cells to calculate the actin polarity pre-wound
for cell_id = 1:num_cells
    
    % Get the cell data
    [cell_data, name, fr_lw, time_int] = get_cell_data(cell_id);
    
    % Get the rear actin and smooth
    actin_back = [cell_data.lifeact_mean_back]';
    actin_back = smooth(actin_back, smooth_factor);
    
    % Add a NaN at the beginning as rear actin is calculated from the 2nd frame
    actin_back = [NaN; actin_back];
    
    % Get the front actin and smooth
    actin_front = [cell_data.lifeact_mean_front]';
    actin_front = smooth(actin_front, smooth_factor);

    % Add a NaN at the beginning as front actin is calculated from the 2nd frame
    actin_front = [NaN; actin_front];
    
    % Get the actin polarity
    actin_norm = actin_front ./ actin_back;

    % Define the time frames pre-wound
    time_pre = [(-num_fr_calc+1:1:-1),0]*time_int;

    % Append all data in matrix
    if num_fr_calc > fr_lw
        actin_norm_pre(num_fr_calc-fr_lw+2:num_fr_calc, cell_id) = actin_norm(1:fr_lw-1);
    elseif num_fr_calc == fr_lw
        actin_norm_pre(2:num_fr_calc, cell_id) = actin_norm(fr_lw-num_fr_calc+1:fr_lw-1);
    else
        actin_norm_pre(1:num_fr_calc, cell_id) = actin_norm(fr_lw-num_fr_calc:fr_lw-1);            
    end
        
end

% Get the time-axis in minutes
time_pre = time_pre / 60;


%% Loop over all cells to calculate the actin plarity post-wound
for cell_id = 1:num_cells
    
    % Get the cell data
    [cell_data, name, fr_lw, time_int] = get_lifeact(cell_id);
    
    % Get the rear actin and smooth
    actin_back = [cell_data.lifeact_mean_back]';
    actin_back = smooth(actin_back, smooth_factor);
    
    % Add a NaN at the beginning as rear actin is calculated from the 2nd frame
    actin_back = [NaN; actin_back];
    
    % Get the front actin and smooth
    actin_front = [cell_data.lifeact_mean_front]';
    actin_front = smooth(actin_front, smooth_factor);
    
    % Add a NaN at the beginning as front actin is calculated from the 2nd frame
    actin_front = [NaN; actin_front];
    
    % Get the actin polarity
    actin_norm = actin_front ./ actin_back;
    
    % Define the time frames post-wound
    time_post = [0, (1:1:num_fr_calc-1)]*time_int;
    
    % Get the number of frames post-moving post-wound
    num_fr_post_actual = length(actin_norm) - fr_lw;
    
    % Append all data in matrix
    if num_fr_post_actual <= num_fr_calc
        actin_norm_post(1:num_fr_post_actual+1, cell_id) = actin_norm(fr_lw:end);
    else
        actin_norm_post(1:num_fr_calc, cell_id) = actin_norm(fr_lw:fr_lw+num_fr_calc-1);
    end
    
end

% Get the time-axis in minutes
time_post = time_post / 60;


%% Calculate the mean and SEM for pre- and post-wound
for kk = 1:num_fr_calc
    actin_pol_pre_mean(kk) = nanmean(actin_norm_pre(kk,:));
    actin_pol_pre_sem(kk) = sem(actin_norm_pre(kk,:));
end
for kk = 1:num_fr_calc
    actin_pol_post_mean(kk) = nanmean(actin_norm_post(kk,:));
    actin_pol_post_sem(kk) = sem(actin_norm_post(kk,:));
end


%% Plot the actin polarity vs time

f = figure;
xline(0, 'k--'); hold on;
plot(time_pre, actin_pol_pre_mean, 'Color', [0 0 0.8]);
hold on
boundedline(time_pre, actin_pol_pre_mean, actin_pol_pre_sem, 'alpha', 'transparency', 0.3);
plot(time_post, actin_pol_post_mean, 'Color', [0 0 0.8]);
boundedline(time_post, actin_pol_post_mean, actin_pol_post_sem, 'alpha', 'transparency', 0.3);

% Properties
xlabel('Time (min)'); ylabel('Actin polarity');
axis([-8 8 0.8 1.4]);
xticks(-8:2:8); yticks(0.8:0.1:1.4);
title({'Actin polarity with time'});
set(gcf,'color','w');





%load("log_weights_sim_1.mat")

% Step 0: Setup
nTime = numel(weights);                % Number of matrices (should be 3600)
matSize = size(weights{1});            % e.g., 800 x 100
%post:
post = post(1:800,:);
post_flat = post(:);
pyr_ins = post_flat<801;
% Step 1: Find logical mask of top 1% values from weights{1}
flat1 = double(weights{1}(:));         % Flatten to 80000x1
flat1 = flat1(pyr_ins);
cutoff = prctile(flat1, 99);           % 99th percentile threshold
topMask = flat1 >= cutoff;             % Logical mask of top 1%
nTop = sum(topMask);                   % Number of top 1% values
fprintf('Top 1%% includes %d connections.\n', nTop);

% Step 2: Preallocate matrix to hold values across time
topMatrix = NaN(nTime, nTop);          % Each row = second, each col = a top-1% weight

% Step 3: Extract those same positions from every matrix
for t = 1:nTime
    flat = double(weights{t}(:));
    topMatrix(t, :) = flat(topMask);   % Apply logical mask
end

% Step 4: Compute correlation to weights{1} over time
ref_vals = topMatrix(1, :);            % Reference = top 1% values from matrix 1
corrVals = NaN(1, nTime);
for t = 1:nTime
    R = corrcoef(ref_vals, topMatrix(t, :));
    corrVals(t) = R(1, 2);             % Store correlation coefficient
end

% Step 5: Plot correlation vs. time
figure;
plot(corrVals, 'LineWidth', 1.5);
xlabel('Time (seconds)');
ylabel('Correlation to Matrix 1');
title('Temporal Correlation to Top 1% of Matrix 1');
ylim([-1 1]);
grid on;

% Step 6: Track a specific connection from the top 1%
% Get the linear indices of top 1% positions
topIndices = find(topMask);

% Choose one connection from the top 1%
whichTop = 3;
targetIdx = topIndices(whichTop);
[row, col] = ind2sub(matSize, targetIdx);

% Track that weight across time
conn_trace = NaN(1, nTime);
for t = 1:nTime
    conn_trace(t) = double(weights{t}(row, col));
end

% Plot weight change of that connection
figure;
plot(conn_trace, 'LineWidth', 1.5);
xlabel('Time (seconds)');
ylabel('Weight Value');
title(sprintf('Weight Change Over Time at Top 1%% Position %d (%d, %d)', ...
    whichTop, row, col));
grid on;

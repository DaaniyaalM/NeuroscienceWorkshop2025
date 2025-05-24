% Setup
nTime = numel(weights);
flat1 = double(weights{1}(:)) / 100;  % Convert to mV
%post
post = post(1:800,:);
post_flat = post(:);
pyr_ins = post_flat<801;

% Create figure with 5x5 subplots
figure;
tl = tiledlayout(5, 5, 'Padding', 'compact', 'TileSpacing', 'compact');

for binMin = 0:24
    binMax = binMin + 1;

    % Get indices in this bin range at t=1
    inds = find(flat1 >= binMin & flat1 < binMax);
    inds = intersect(inds, find(pyr_ins==1));

    % Skip if no weights in this bin
    if isempty(inds)
        nexttile;
        title(sprintf('[%d,%d): No Data', binMin, binMax));
        axis off;
        continue;
    end

    % Preallocate matrix for tracked weights
    nW = numel(inds);
    binValues = NaN(nTime, nW);

    % Track weights over time for these indices
    for t = 1:nTime
        flatT = double(weights{t}(:)) / 100;
        binValues(t, :) = flatT(inds);
    end

    % Compute correlations with t=1 safely
    ref = binValues(1, :);
    correlations = NaN(nTime, 1);

    if numel(ref) < 2 || all(ref == ref(1))
        continue;  % fallback for constant or singleton ref
    else
        for t = 1:nTime
            curr = binValues(t, :);

            if numel(curr) < 2 || all(curr == curr(1))
                correlations(t) = 1;  % fallback for constant curr
            else
                R = corrcoef(ref, curr);
                if size(R,1) < 2 || size(R,2) < 2 || isnan(R(1,2))
                    correlations(t) = NaN;
                else
                    correlations(t) = R(1,2);
                end
            end
        end
    end

    % Plot in a subplot
    nexttile;
    plot(correlations, 'LineWidth', 1.2);
    title(sprintf('[%d, %d) mV', binMin, binMax), 'FontSize', 8);
    ylim([-1 1]);
    xlim([1 nTime]);
    grid on;
    set(gca, 'FontSize', 6);
end

% Add shared labels and title
xlabel(tl, 'Time (s)', 'FontSize', 10);
ylabel(tl, 'Correlation with t=1', 'FontSize', 10);
sgtitle(tl, 'Correlation Over Time for Bins 0–25 mV (Based on t=1)', 'FontWeight', 'bold');

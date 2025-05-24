load Data_For_Daniel2\add_weights_sim_1.mat
nTime = numel(weights);
correlations_all = NaN(nTime, 1);

% Flatten all weights at t=1
post = post(1:800,:);
post_flat = post(:);
pyr_ins = post_flat<801;
ref = double(weights{1}(:)) / 100;
ref = ref(pyr_ins);
for t = 1:nTime
    curr = double(weights{t}(:)) / 100;
    curr = curr(pyr_ins);
    if all(ref == ref(1)) || all(curr == curr(1)) || numel(ref) < 2
        correlations_all(t) = 1;  % fallback for constant or singleton
    else
        R = corrcoef(ref, curr);
        if size(R,1) < 2 || size(R,2) < 2 || isnan(R(1,2))
            correlations_all(t) = NaN;
        else
            correlations_all(t) = R(1,2);
        end
    end
end

% Plot the overall correlation over time
figure;
plot(correlations_all, 'LineWidth', 2);
xlabel('Time (s)');
ylabel('Correlation with t = 1 (All Weights)');
title('Overall Synaptic Stability Over Time');
ylim([-1 1]);
grid on;

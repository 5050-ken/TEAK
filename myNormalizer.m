function [normalDataset] = myNormalizer(dataset)
% normalize dataset to 0-1 interval

% make a same size matrix for discrete values
normalDataset = zeros(size(dataset,1),size(dataset,2));

% normalize each row
for i = 1:size(dataset,1)
    normalDataset(i,:) = (dataset(i,:) - min(dataset))./(max(dataset) - min(dataset));
end

% paste the actual effort values back, since they should not be normalized
normalDataset(:,size(normalDataset,2)) = dataset(:,size(dataset,2));
normalDataset(find(isnan(normalDataset) == 1)) = 1;     % replace nan values
                                                        % nan values occur
                                                        % when all
                                                        % instances of an
                                                        % attribute are the
                                                        % same valued
end

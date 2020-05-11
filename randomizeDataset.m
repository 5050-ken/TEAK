function [randomizedDataset] = randomizeDataset (dataset)

% randomized instances will be kept here
randomizedDataset = [];

for i = 1:size(dataset,1)
   index = randi([1 size(dataset,1)],1,1);

   % add a random instance
   randomizedDataset = [randomizedDataset;dataset(index,:)];

   % delete it from the dataset
   dataset(index,:) = [];
end



end

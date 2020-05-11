function [fold1, fold2, fold3] = divideInto3(dataset)

% define folds
fold1 = [];
fold2 = [];
fold3 = [];

% firstly sort the dataset according to the effort values in inc. order
effortValues = dataset(:,size(dataset,2));
[sortedEffortValues sortedIndices] = sort(effortValues, 'ascend');
sortedDataset = dataset(sortedIndices,:);

% now dividing dataset into 3 pieces
foldSize = ceil(size(dataset,1)/3);
dataPiece1 = dataset(1:foldSize,:);
dataPiece2 = dataset((foldSize+1):(2*foldSize),:);
dataPiece3 = dataset((2*foldSize+1):size(dataset,1),:);

% randomize these pieces
dataPiece1 = randomizeDataset(dataPiece1);
dataPiece2 = randomizeDataset(dataPiece2);
dataPiece3 = randomizeDataset(dataPiece3);
% then bring them together
datasetToDistribute = [dataPiece1;dataPiece2;dataPiece3];

% now distribute the parts into folds
for i = 1:size(dataset,1)
    if mod(i,3) == 1
        fold1 = [fold1;datasetToDistribute(i,:)];
    elseif mod(i,3) == 2
        fold2 = [fold2;datasetToDistribute(i,:)];
    else
        fold3 = [fold3;datasetToDistribute(i,:)];
    end
end

end

% this function finds the closes k neighbors to a row within a dataset
% and returns the median of those k projects' effort values
% and also the mre value


function [knnMedian, mre, kEffort] = nnk(myRow,dataset,kValue)
featureSize = size(dataset,2);
% normalize dataset to 0-1 interval
trainActualCostValues = dataset(:,size(dataset,2));
actualRowCost = myRow(:,size(dataset,2));

dataset = [myRow;dataset];    % combine test and train
dataset = myNormalizer(dataset); % normalize combination
myRow = dataset(1,:);   % separate test from normalized data
dataset(1,:) = [];  % delete test from train

% below array keeps the kNN effort values
kEffort = zeros(kValue,1);

% below array keeps all the distance values
allDistances = zeros(size(dataset,1),1);
%find all the distances
for distCounter = 1:size(dataset,1)
    allDistances(distCounter) = sqrt(sum(abs(myRow(1,1:1:(featureSize-1)).^2 - dataset(distCounter,1:1:(featureSize-1)).^2)));
end
%sort the distances in an ascending order and keep the indices
[sortedDistances sortIndices] = sort(allDistances, 'ascend');
%pick up top k indices
selectedIndices = sortIndices(1:kValue);
%pick up the selected k effort values
kEffort = trainActualCostValues(selectedIndices);
% take the median of selected values
knnMedian = median(kEffort);

mre = abs(knnMedian - myRow(1,featureSize))/myRow(1,featureSize);
ar = abs(knnMedian - myRow(1,featureSize));

end

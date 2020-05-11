% this function tries all the k valules from 1 to size of the dataset
% and then it returns the best k value for -let us say- 10 instances

function [bestKValue] = bestk(train)

% below array keeps the best k values and related mres
bestKValues = 1 * ones(10,1);
bestMres = 1e9 * ones(10,1);

% normalize dataset to 0-1 interval
train = myNormalizer(train); % normalize train

% find best k value for 10 random instances
for i = 1:10
    % keep a temp train data so as not to lose the actual one
    tempTrain = train;

    selectedIndex = randi([1 size(tempTrain,1)], 1, 1);
    selectedRow = tempTrain(selectedIndex,:);
    tempTrain(selectedIndex,:) = [];

    % initially let the best Mre value be 1
    [tempEffort, bestMre] = nnk(selectedRow, tempTrain, 1);

    % now try out other k values
    tempMreValues = 1e15*ones(size(tempTrain,1),1);
    for j = 2:size(tempTrain,1)

        [tempEffort, tempMre] = nnk(selectedRow, tempTrain, j);
        tempMreValues(j,1) = tempMre;
        % if the new mre is better, then update best k value
        if tempMre < bestMre
           bestMres(i,1) = tempMre;
           bestMre = tempMre;
           bestKValues(i,1) = j;
           if bestKValues(i,1) == 0
               i
           end
        end

    end

end

% % now find the index of the minimum MRE
% [C I] = min(bestMres);
% % get the actual value of the minimum MRE
% bestKValue = bestKValues(I);
%bestKValues(find(bestKValues == -1)) = [];
bestKValue = round(mean(bestKValues));

end

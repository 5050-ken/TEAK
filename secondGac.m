% Ekrem Kocaguneli
% Bogazici University Computer Engineering Department
% Code Below Written in Partial Fullfilment of Master Thesis in CMPE

function [prediction, mre, instanceSize, selectedVariance, predictionZone] = secondGac(tree, startPoint, myRow)

% this will be the GAC2 tree's code
[allSubtrees] = getSubtreesForGAC2(tree, startPoint);

% find variance of all subtrees
variancesOfAllSubtrees = zeros(size(allSubtrees,1),1);
for i = 1:size(allSubtrees,1)
   variancesOfAllSubtrees(i) = var(allSubtrees(i).features(:,size(allSubtrees(i).features,2)));
end

% convert variance to log(var)/max(log(var))
convertedVar = log(variancesOfAllSubtrees);
tempMax = max(convertedVar);
convertedVar = convertedVar/tempMax;

% now select instances from GAC tree 1 at random
bias = 9; % select a bias, this bias parameter will be like a tuning switch
selectedInstances = []; % keeps selected instances from GAC tree1

tempCounter = 0;    % counts how many times selectedInstances were added
for i = 1:size(allSubtrees,1)
    if convertedVar(i) < rand()^bias
        selectedInstances = [selectedInstances;allSubtrees(i).features];
        tempCounter = tempCounter + 1;
    end
end

% since there are multiple nodes from multiple levels that contribute to
% our tree, we need to remove the duplicates from selected instances if
% there are any
% delete the copies of it from the messed up values
cleanedSelectedInstances = [];  % keeps the unique instances within selectedInstances
while size(selectedInstances,1) > 0
    tempInstance = selectedInstances(1,:);
    head = 1;                           % keeps track of the head as deletion
    tail = size(selectedInstances,1);    % keeps track of the tail as deletion
    while 1==1
        if sum(selectedInstances(head,:) - tempInstance) == 0
            selectedInstances(head,:) = [];
            tail = tail -1;
        else
            head = head + 1;
        end

        % when we processed them all
        if head > tail
            break;
        end
    end
    cleanedSelectedInstances = [cleanedSelectedInstances;tempInstance];
end

% now we can re-build the GAC tree on the selected instances only and
% report the prediction as well as mre value
if size(cleanedSelectedInstances,1) < 2
    prediction = -1;
    mre = -1;
    instanceSize = -1;
    selectedVariance = -1;
    predictionZone = [];
else
    [prediction, mre, selBestLevel, selectedVariance, dummy1, dummy2,predictionZone] = treeK(myRow, cleanedSelectedInstances);
    instanceSize = size(cleanedSelectedInstances,1);
end

end

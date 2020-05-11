function [comingNode,tree,newLevelElements] = addOddInstance(tree,newLevelElements,levelElements)

minDist = 999999999999999999999999;
nodeToAdd = 0; % meaning that no node is chosen yet

columnNumber = size(newLevelElements(1).features(1,:),2);

% find odd instance
for i = 1:length(levelElements)
    if levelElements(i).isProcessed == 0
       comingNode = levelElements(i);
    end
end

for i = 1:size(newLevelElements,1)
    tempDist = 0;
    for j = 1:size(newLevelElements(i).features,1)
        for k = 1:size(comingNode.features,1)

            tempDist = tempDist + sqrt(sum( (newLevelElements(i).features(j,1:(columnNumber-1))).^2 - (comingNode.features(k,(1:columnNumber-1))).^2 ));

        end
    end

    if tempDist < minDist
       minDist = tempDist;
       nodeToAdd = i;
    end

end

if nodeToAdd == 0
   nodeToAdd
end

newLevelElements(nodeToAdd).middleChild = comingNode.ownId;
newLevelElements(nodeToAdd).features = [newLevelElements(nodeToAdd).features;comingNode.features];
tree.allNodes(newLevelElements(nodeToAdd).ownId) = newLevelElements(nodeToAdd);

end

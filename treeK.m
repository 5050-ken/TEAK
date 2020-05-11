function [pred0, mre0, levelToReturn, varToReturn, tree, myRoot, predictionZone] = treeK(myRow,train)

rootExists = 0;

% define node
node = struct('ownId',0,'level',0,'isProcessed',0,'features',[],'parentId',0,'leftChildId',0,'rightChildId',0,'middleChild',0);
% define tree
tree = struct('allNodes',[]);

columnNumber = size(myRow,2);

% fill out the active set
[tree] = fillActiveSet(tree,node,train);

level = 0;
levelElements = tree.allNodes;
newLevelElements = [];

% within the following while loop, the tree is built up
while length(levelElements) > 1 || level < 1
    level = level + 1;
    levelElementsLength = length(levelElements);
    for i = 1:levelElementsLength

        leftInst = 0;
        rightInst = 0;

        % if we are done
        if levelElementsLength == 0
            break;
        end


        % a dummy to check root's existence
        rootExists = 0;

        % if we reached root, then form the root and we are done
        if levelElementsLength <= 3 && level >= ceil(log2(size(train,1)))-1 %i > 2
            [newNode,tree,levelElements] = addNewNode(levelElements,node,tree,1,2);

            % in case of a special occasion such that 3 nodes make up the
            % root
            if levelElementsLength == 3
                newNode.middleChild = levelElements(3).ownId;
                newNode.features = [newNode.features;levelElements(3).features];
                tree.allNodes(newNode.ownId) = newNode;
            end

            rootExists = 1;
            myRoot = newNode;
            %             root.leftChildId = levelElements(1).ownId;
            %             root.rightChildId = levelElements(2).ownId;
            %             root.features = [levelElements(1).features;levelElements(2).features];
            level = level + 1; % increment level by 1 due to root
            %             [newNode,tree,newLevelElements] = addOddInstance(tree,newLevelElements,levelElements);
            break;
        end


        % if it is an odd instance
        if levelElementsLength < 2
            [newNode,tree,newLevelElements] = addOddInstance(tree,newLevelElements,levelElements);
            break;
        end

        bestDist = 999999999999999999999999999999;
        tempDist = 999999999999999999999999999999;
        shallICombine = 0;
        leftInst = i;
        for  j = 1:length(levelElements)
            if i~=j && levelElements(i).isProcessed == 0 && levelElements(j).isProcessed == 0
               if j == 93
                    j
                end
                tempDist = findDistance(levelElements,i,j);
                if tempDist < bestDist
                    bestDist = tempDist;
                    leftInst = i;
                    rightInst = j;
                    shallICombine = 1;
                end

            end
        end

        if shallICombine == 1
            [newNode,tree,levelElements] = addNewNode(levelElements,node,tree,leftInst,rightInst);
            levelElementsLength = levelElementsLength - 2; % two nodes are processed
            newLevelElements = [newLevelElements;newNode];
        end
    end
    eval(['level_',num2str(level),'_elements = levelElements;']);
    levelElements = newLevelElements;
    newLevelElements = [];
end

% above we have built up the tree and now we will find the best node
% for our row and we will predict its cost
% at this point if we havent created root, then we are in troublle
if rootExists == 0
    fprintf('No root was formed, there is smt. wrong!!!');
end

startPoint = myRoot;      % firstly set the root as start point



while level > 0            % as long as we can go down

    % calculate variances of nodes and find size of nodes for weighted var.
    [leftWeightedVar,rightWeightedVar] = getWeightedVar(tree,startPoint);

    varLeaves = var(startPoint.features(:,columnNumber));

    % if we are doing better, i.e. weighted variance is better
    % then choose the closer branch
    % else, we are done and return the predicted effort and mre
    if leftWeightedVar < varLeaves || rightWeightedVar < varLeaves

        if startPoint.middleChild == 0

            [leftDist,rightDist, middleDist] = findCloserBranch(myRow, tree.allNodes(startPoint.leftChildId),tree.allNodes(startPoint.rightChildId),0,0);

        else

            [leftDist,rightDist, middleDist] = findCloserBranch(myRow, tree.allNodes(startPoint.leftChildId),tree.allNodes(startPoint.rightChildId),tree.allNodes(startPoint.middleChild),1);

        end

        if leftDist < rightDist && leftDist < middleDist                                   % if left is better
            startPoint = tree.allNodes(startPoint.leftChildId);     % jump to left node
        elseif rightDist < middleDist
            startPoint = tree.allNodes(startPoint.rightChildId);
        else                                                     % else jump to right node
            startPoint = tree.allNodes(startPoint.middleChild);
        end
    else
        pred0 = median(startPoint.features(:,columnNumber));      % we found the node
        mre0 = abs(myRow(1,columnNumber) - pred0)/ myRow(1,columnNumber);
        levelToReturn = level;
        varToReturn = var(startPoint.features(:,columnNumber));
        predictionZone = startPoint.features;
        break;                                          % so get out of the loop
    end


    level = level - 1;     % decrement level by 1

    % if we reached the end
    if level == 2
        pred0 = median(startPoint.features(:,columnNumber));      % we found the node
        mre0 = abs(myRow(1,columnNumber) - pred0)/ myRow(1,columnNumber);
        levelToReturn = level;
        varToReturn = var(startPoint.features(:,columnNumber));
        predictionZone = startPoint.features;
        break;
    end
end


end

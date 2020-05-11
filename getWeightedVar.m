function [leftWeightedVar,rightWeightedVar] = getWeightedVar(tree,startPoint)

% define a queues that keep the nodes of subtrees
myLeftQ = [];
myRightQ = [];

% the first position will belong to start point itself, so it will not be
% considered while calculating the weighted variance
if startPoint.leftChildId < 1
    leftWeightedVar = 1e20;
    rightWeightedVar = 1e20;
else


    myLeftQ = [myLeftQ;tree.allNodes(startPoint.leftChildId)];
    myRightQ = [myRightQ;tree.allNodes(startPoint.rightChildId)];

    % calculate weighted variance of the left child
    QSize = 1;
    counter = 1;
    while counter <= QSize
        if myLeftQ(counter).leftChildId > 0 && (tree.allNodes(myLeftQ(counter).leftChildId).leftChildId > 0 || tree.allNodes(myLeftQ(counter).leftChildId).rightChildId > 0)
            myLeftQ = [myLeftQ;tree.allNodes(myLeftQ(counter).leftChildId)];
        end
        if myLeftQ(counter).rightChildId > 0 && (tree.allNodes(myLeftQ(counter).leftChildId).leftChildId > 0 || tree.allNodes(myLeftQ(counter).leftChildId).rightChildId > 0)
            myLeftQ = [myLeftQ;tree.allNodes(myLeftQ(counter).rightChildId)];
        end
        QSize = size(myLeftQ,1);
        counter = counter + 1;
    end

    % get total size of the left subtree
    totalSizeLeft = 0;
    for i = 1:size(myLeftQ,1)
        totalSizeLeft = totalSizeLeft + size(myLeftQ(i).features,1);
    end

    % get total size of the right subtree
    totalSizeRight = 0;
    for i = 1:size(myRightQ,1)
        totalSizeRight = totalSizeRight + size(myRightQ(i).features,1);
    end

    % get weighted variance of the left subtree
    leftWeightedVar = 0;
    for i = 1:size(myLeftQ,1)
        leftWeightedVar = leftWeightedVar + (size(myLeftQ(i).features,1)/totalSizeLeft)*var(myLeftQ(i).features(:,size(myLeftQ(i).features,2)));
    end

    %%%%% now we calculate the weighted variance for the right subtree
    %%%%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % calculate weighted variance of the right child
    QSize = 1;
    counter = 1;
    while counter <= QSize
        if myRightQ(counter).leftChildId > 0 && (tree.allNodes(myRightQ(counter).leftChildId).leftChildId > 0 || tree.allNodes(myRightQ(counter).leftChildId).rightChildId > 0)
            myRightQ = [myRightQ;tree.allNodes(myRightQ(counter).leftChildId)];
        end
        if myRightQ(counter).rightChildId > 0 && (tree.allNodes(myRightQ(counter).leftChildId).leftChildId > 0 || tree.allNodes(myRightQ(counter).leftChildId).rightChildId > 0)
            myRightQ = [myRightQ;tree.allNodes(myRightQ(counter).rightChildId)];
        end
        QSize = size(myRightQ,1);
        counter = counter + 1;
    end

    % get weighted variance of the right subtree
    rightWeightedVar = 0;
    for i = 1:size(myRightQ,1)
        rightWeightedVar = rightWeightedVar + (size(myRightQ(i).features,1)/totalSizeRight)*var(myRightQ(i).features(:,size(myRightQ(i).features,2)));
    end

    temp = (rightWeightedVar*totalSizeRight)/(totalSizeRight+totalSizeLeft) + (leftWeightedVar*totalSizeLeft)/(totalSizeRight+totalSizeLeft);
    rightWeightedVar = temp;
    leftWeightedVar = temp;

end

end

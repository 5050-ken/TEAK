function [subtrees] = getSubtreesForGAC2(tree, startPoint)
% this function will return all the subtrees of the root in an array
% define a queues that keep the nodes of subtrees
myLeftQ = [];
myRightQ = [];

% the first position will belong to start point itself, so it will not be
% considered while calculating the weighted variance
myLeftQ = [myLeftQ;tree.allNodes(startPoint.leftChildId)];
myRightQ = [myRightQ;tree.allNodes(startPoint.rightChildId)];

% get all subtrees coming from left child
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

% get all subtrees coming from right child
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

% now combine left and right subtrees and return all the subtrees
subtrees = [myLeftQ;myRightQ];

end

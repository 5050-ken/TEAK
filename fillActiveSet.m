function [tree] = fillActiveSet(tree,node,train)

% first column is function Id and the last one is TRUE or FALSE
for i = 1:size(train,1)
    node.ownId = i;
    node.features = [node.features;train(i,:)];
    node.level = 1;
    tree.allNodes = [tree.allNodes;node];
    node.features = [];
end

end

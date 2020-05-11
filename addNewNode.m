function [node,tree,levelElements] = addNewNode(levelElements,node,tree,i,j)

node.ownId = length(tree.allNodes) + 1;
node.features = [levelElements(i).features;levelElements(j).features];
node.leftChildId = levelElements(i).ownId;
levelElements(i).isProcessed = 1;
levelElements(j).isProcessed = 1;
node.rightChildId = levelElements(j).ownId;
node.isProcessed = 0;
node.level = levelElements(i).level + 1;
tree.allNodes = [tree.allNodes;node];

end

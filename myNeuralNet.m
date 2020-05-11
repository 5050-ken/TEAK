function [predictedValue, mre] = myNeuralNet(testSet, trainSet)

% design a regression neural network based on radial basis networks
% note how the matrices are transposed
% independent variable matrix is an RxQ matrix, where Q is instance number
% dependent variable is a matrix SxQ, where Q is instance number
spreads = [10:10:50]';
bestSpread = 1;
if size(trainSet,1) < 5    % if reduced dataset has less than 5 instances
    spreads = [10:10:30]';
end

% find a good spread value by using validation set
validationSet = trainSet;
minErr = inf;
for i = 1:size(spreads,1)
    validationSet = trainSet;
    validationInstance = validationSet(i,:);
    validationSet(i,:) = [];
    myTempNet = newgrnn(validationSet(:,1:(size(validationSet,2)-1))', validationSet(:,size(validationSet,2))',spreads(i));
    tempPrediction = sim(myTempNet,validationInstance(1,1:(size(validationInstance,2)-1))');
    tempError = abs(validationInstance(1,size(validationInstance,2)) - tempPrediction)/validationInstance(1,size(validationInstance,2));
    if tempError < minErr
        minErr = tempError;
        bestSpread = spreads(i);
    end
end
% simulate network for a new input
% i.e. evaluate it for the test instance
% then store the predicted value
myNet = newgrnn(trainSet(:,1:(size(trainSet,2)-1))', trainSet(:,size(trainSet,2))',spreads(i));
predictedValue = sim(myNet,testSet(1,1:(size(trainSet,2)-1))');

% calculate mre
actualValue = testSet(1,size(testSet,2));
mre = abs(actualValue - predictedValue)/actualValue;

end

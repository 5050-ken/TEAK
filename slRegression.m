function [predictedValue, mre] = slRegression(testSet, trainSet)

xTrain = trainSet(:,1:(size(trainSet,2)-1));
yTrain = trainSet(:,size(trainSet,2));
xTest = testSet(1,(1:size(testSet,2)-1));

% apply simple multivariate linear regression
predictedValue = abs(xTest*regress(yTrain,xTrain));

% calculate mre
actualValue = testSet(1,size(testSet,2));
mre = abs(actualValue - predictedValue)/actualValue;

end

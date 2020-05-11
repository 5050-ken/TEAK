% below are the load commands for different databases
% depending on which database you would like to be processed
% just uncomment the related lines
allMyDatasets = {...
        'cocomo81','cocomo81e','cocomo81o',...
        'nasa93','nasa93_center_2','nasa93_center_5',...
        'desharnais',...
        'sdr','albrecht','isbsg_banking'...
        };


for datasetCounter = 1:size(allMyDatasets,2)
    % define datasets of experiment
    allMyDatasets = {...
        'cocomo81','cocomo81e','cocomo81o',...
        'nasa93','nasa93_center_2','nasa93_center_5',...
        'desharnais',...
        'sdr','isbsg_banking'...
        };

    % define random run-size
    randomRunSize = 10;

    eval(['load ',char(allMyDatasets(datasetCounter)),'.csv;']);
    eval(['dataset = ',char(allMyDatasets(datasetCounter)),';']);
    eval(['clear ',char(allMyDatasets(datasetCounter)),';']);

    % define the variables to keep tract of.. well pretty much everything
    selectedBestLevels = -1 * ones(randomRunSize,size(dataset,1));
    varianceOfSelectedBestPlaces = -1 * ones(randomRunSize,size(dataset,1));
    varianceOfSelectedBestPlacesGAC2 = -1 * ones(randomRunSize,size(dataset,1));

    actuals = -1 * ones(randomRunSize,size(dataset,1));
    actualsWithFeatures = [];

    pred0 = -1 * ones(randomRunSize,size(dataset,1));
    mre0 = -1 * ones(randomRunSize,size(dataset,1));

    predGac2 = -1 * ones(randomRunSize,size(dataset,1));
    mreGac2 = -1 * ones(randomRunSize,size(dataset,1));
    arGac2 = -1 * ones(randomRunSize,size(dataset,1));
    instanceSizeGac2 = -1 * ones(randomRunSize,size(dataset,1));

    pred1 = -1 * ones(randomRunSize,size(dataset,1));
    mre1 = -1 * ones(randomRunSize,size(dataset,1));
    ar1 = -1 * ones(randomRunSize,size(dataset,1));

    pred2 = -1 * ones(randomRunSize,size(dataset,1));
    mre2 = -1 * ones(randomRunSize,size(dataset,1));
    ar2 = -1 * ones(randomRunSize,size(dataset,1));

    pred4 = -1 * ones(randomRunSize,size(dataset,1));
    mre4 = -1 * ones(randomRunSize,size(dataset,1));
    ar4 = -1 * ones(randomRunSize,size(dataset,1));

    pred8  = -1 * ones(randomRunSize,size(dataset,1));
    mre8 = -1 * ones(randomRunSize,size(dataset,1));
    ar8 = -1 * ones(randomRunSize,size(dataset,1));

    pred16 = -1 * ones(randomRunSize,size(dataset,1));
    mre16 = -1 * ones(randomRunSize,size(dataset,1));
    ar16 = -1 * ones(randomRunSize,size(dataset,1));

    predx = -1 * ones(randomRunSize,size(dataset,1));
    mrex = -1 * ones(randomRunSize,size(dataset,1));
    arx = -1 * ones(randomRunSize,size(dataset,1));

    predSLReg  = -1 * ones(randomRunSize,size(dataset,1));
    mreSLReg = -1 * ones(randomRunSize,size(dataset,1));
    arSLReg = -1 * ones(randomRunSize,size(dataset,1));

    predNNet = -1 * ones(randomRunSize,size(dataset,1));
    mreNNet = -1 * ones(randomRunSize,size(dataset,1));
    arNNet = -1 * ones(randomRunSize,size(dataset,1));

    % a dummy to keep track of whether the best k value was found
    bestKFound = 0;
    % find the best k value for the train data
    if bestKFound == 0
        myBestK = bestk(dataset);
    end

    % repeat n-many times
    for counter = 1:randomRunSize

        % randomize dataset
        [fold1, fold2, fold3] = divideInto3(dataset);

        % for each row in the randomized dataset do the following
        i = 0;
        for foldCounter = 1:3
            if foldCounter == 1
                testSet = fold1; train = [fold2;fold3];
            elseif foldCounter == 2
                testSet = fold2; train = [fold1;fold3];
            else
                testSet = fold3; train = [fold1;fold2];
            end

            foldIndexCounter = 0;
            while foldIndexCounter < size(testSet,1)
                % increment i and foldIndexCounter by 1
                i = i + 1;
                foldIndexCounter = foldIndexCounter + 1;

                % pick up the row
                myRow = testSet(foldIndexCounter,:);

                % record it into actuals
                actuals(counter,i) = myRow(1,size(myRow,2));
                % record also the features of that instance (since a lot of instances
                % have the same effort value, I needed to record the features too)
                actualsWithFeatures = [actualsWithFeatures;myRow(1,:)];


                % now start predictions
                % the one below -treeK- is our guy to defend
                % firstly normalize the data for TEAK
                trainTemp = myNormalizer([myRow;train]);
                myRowTemp = trainTemp(1,:);
                trainTemp(1,:) = [];
                [pred0(counter,i), mre0(counter,i),selectedBestLevels(counter,i),varianceOfSelectedBestPlaces(counter,i), gac2Tree, gac2Root] = treeK(myRowTemp,trainTemp);

                % at this point we have build our GAC tree -above executable line- and we can check the
                % instances with the second tree

                [predGac2(counter,i), mreGac2(counter,i),instanceSizeGac2(counter,i),varianceOfSelectedBestPlacesGAC2(counter,i)] = secondGac(gac2Tree, gac2Root, myRowTemp);
                if predGac2(counter,i) == -1    % meaning there were not enough instances for gac2 tree
                    i = i-1;
                    foldIndexCounter = foldIndexCounter - 1;
                    continue;
                end
                arGac2(counter,i) = abs(actuals(counter,i) - predGac2(counter,i));

                % below are the ones for various k values
                [pred1(counter,i), mre1(counter,i)] = nnk(myRow,train,1);
                ar1(counter,i) = abs(actuals(counter,i) - pred1(counter,i));

                [pred2(counter,i), mre2(counter,i)] = nnk(myRow,train,2);
                ar2(counter,i) = abs(actuals(counter,i) - pred2(counter,i));

                [pred4(counter,i), mre4(counter,i)] = nnk(myRow,train,4);
                ar4(counter,i) = abs(actuals(counter,i) - pred4(counter,i));

                [pred8(counter,i), mre8(counter,i)] = nnk(myRow,train,8);
                ar8(counter,i) = abs(actuals(counter,i) - pred8(counter,i));

                [pred16(counter,i), mre16(counter,i)] = nnk(myRow,train,16);
                ar16(counter,i) = abs(actuals(counter,i) - pred16(counter,i));

                [predx(counter,i), mrex(counter,i)] = nnk(myRow,train,myBestK);
                arx(counter,i) = abs(actuals(counter,i) - predx(counter,i));

                [predSLReg(counter,i), mreSLReg(counter,i)] = slRegression(myRow,train);
                arSLReg(counter,i) = abs(actuals(counter,i) - predSLReg(counter,i));

                [predNNet(counter,i), mreNNet(counter,i)] = myNeuralNet(myRow,train);
                arNNet(counter,i) = abs(actuals(counter,i) - predNNet(counter,i));
            end
        end

        runNumberOutOfrandomRunSize = counter
    end

    % save workspace
    eval(['save 10_by_3_way_results_workspaces\',char(allMyDatasets(datasetCounter)),'.mat;']);
    % clear workspace and screen for next dataset
    clear;clc;
end

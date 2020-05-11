function  [leftDist,rightDist,middleDist] = findCloserBranch(myRow, left, right, middle, isThereMiddleChild)

leftDist = sqrt(sum(abs(myRow.^2 - left.features(1,:).^2)));   % distance to left branch
rightDist = sqrt(sum(abs(myRow.^2 - right.features(1,:).^2)));  % distance to right branch
middleDist = 0;  % distance to middle branch

    % calculate distance to left
    for i = 2:size(left.features,1)
       leftTemp = sqrt(sum(abs(myRow.^2 - left.features(i,:).^2)));

       % min-dist approach
%        if leftTemp < leftDist
%           leftDist = leftTemp;
%        end

%        % max-dist approach
       if leftTemp > leftDist
          leftDist = leftTemp;
       end
    end

    % calculate distance to right
    for i = 2:size(right.features,1)
       rightTemp = sqrt(sum(abs(myRow.^2 - right.features(i,:).^2)));

       % min-dist approach
       if rightTemp < rightDist
          rightDist = rightTemp;
       end

%        % max-dist approach
%        if rightTemp > leftDist
%           leftDist = leftTemp;
%        end
    end

    % calculate distance to middle, if there is a middle
    if isThereMiddleChild == 1
        if middle.ownId > 0
            middleDist = middleDist + sqrt(sum(abs(myRow.^2 - middle.features(1,:).^2)));
            for i = 2:size(middle.features,1)
                middleTemp = middleDist + sqrt(sum(abs(myRow.^2 - middle.features(i,:).^2)));
%                 % min-dist approach
%                if middleTemp < middleDist
%                   middleDist = middleTemp;
%                end

                % max-dist approach
               if middleTemp > middleDist
                  middleDist = middleTemp;
               end
            end
        else
            middleDist = 1e100;
        end
    else
        middleDist = 1e100;
    end

end

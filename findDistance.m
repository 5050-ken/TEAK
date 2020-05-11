function [distance] = findDistance(levelElements,i,j)

distance = 0;
for k = 1:size(levelElements(i).features,1)

    for l = 1:size(levelElements(j).features,1)
        tempDist = sqrt(sum( (levelElements(i).features(k)).^2 + (levelElements(j).features(l)).^2 ));

%         % min-dist approach - uncomment this and comment other one
%         depending on which one you want to use
%         if tempDist < distance
%            distance = tempDist;
%         end

         % max-dist approach
        if tempDist > distance
           distance = tempDist;
        end
    end
end

end

function F = eFM(points1, points2)

sizes = size(points1,1);

x1_x = points1(:,1); points1X = points2(:,1);
x1_y = points1(:,2); points2Y = points2(:,2);

cent_x1_x = mean(x1_x); cent_x1_y = mean(x1_y);
x1_x = x1_x - cent_x1_x * ones(sizes,1); x1_y = x1_y - cent_x1_y * ones(sizes,1);
averageDistance = sqrt(sum(x1_x.^2  + x1_y.^2)) / sizes;
scalingFactor = sqrt(2) / averageDistance;
points1(:,1) = scalingFactor * x1_x; points1(:,2) = scalingFactor * x1_y;
distanceX = (-scalingFactor*cent_x1_x); distanceY = (-scalingFactor*cent_x1_y);

tempArray1 = [scalingFactor,0,distanceX;0,scalingFactor,distanceY;0,0,1];  
points1CenterX = mean(points1X);
points2CenterY = mean(points2Y);
points1X = points1X - points1CenterX * ones(sizes,1);
points2Y = points2Y - points2CenterY * ones(sizes,1);
averageDistance = sqrt(sum(points1X.^2  + points2Y.^2)) / sizes;
scalingFactor = sqrt(2) / averageDistance;
points2(:,1) = scalingFactor * points1X;
points2(:,2) = scalingFactor * points2Y;
tempArray2 = [scalingFactor 0 -scalingFactor*points1CenterX;
       0 scalingFactor -scalingFactor*points2CenterY;
       0 0 1];

aMatrix = [points1(:,1).* points2(:,1) points1(:,1).* points2(:,2) points1(:,1) points1(:,2).* points2(:,1) points1(:,2) .* points2(:,2) points1(:,2) points2(:,1) points2(:,2) ones(size(points1,1),1)];
[~,~,v] = svd(aMatrix);
fundM = v(:,end);
fRank1 =reshape(fundM,3,3);
fRank1 = fRank1 / norm(fRank1);
[u,d,v] = svd(fRank1);
d(3,3) = 0;
fRank2 = u * d * v';
F = tempArray2' * fRank2 * tempArray1;
end


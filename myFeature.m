function [Points_2 , Feature_2, vPoints_2] = myFeature(image)
if size(image,3) == 3
image=rgb2gray(image);
end
Points_2 = detectSURFFeatures(image,'MetricThreshold', 1000);
% points = detectFASTFeatures(image);
Points_2 = selectUniform(Points_2, 500, size(image));
% points = selectStrongest(points, 200);%, size(image));
[Feature_2, vPoints_2] = extractFeatures(image, Points_2, 'Upright', true);
end
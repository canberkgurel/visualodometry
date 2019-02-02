function [Points_2,Feature_2,IndexPairs,vPoints_2]=myMatchFeature(undistortedImg_2,Feature_1,undistortedImg_1,vPoints_1)
if size(undistortedImg_2,3) == 3
    undistortedImg_2=rgb2gray(undistortedImg_2);
end
[Points_2 , Feature_2, vPoints_2]=myFeature(undistortedImg_2);
IndexPairs = matchFeatures(Feature_1, Feature_2, 'Unique', true);
end
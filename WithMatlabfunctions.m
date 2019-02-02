% ENPM673 PROJECT 2 VISUAL ODOMETRY CANBERK SUAT GUREL 115595972
clc;clear all;close all;warning off;

[fx, fy, cx, cy, G_camera_image, LUT] = ReadCameraModel('./stereo/centre','./model');
K = [fx 0 cx;0 fy cy;0 0 1]; %Intrinsic Matrix of the camera
cameraParams = cameraParameters('IntrinsicMatrix',K');  %intrinsicMatrix = [fx,0,0;s,fy,0;cx,cy,1]

timestamps = dlmread('./model/stereo.timestamps');
FrameNum = length(timestamps(:,1));
player = vision.VideoPlayer('Name', 'Processed Frame','Position',[30, 40, 800, 600]);    %[left bottom width height]
waitBar = waitbar(0,'Frames are processing...','Position',[820, 200, 280, 70]);

movegui(figure,'northeast');
hold on;
grid on; view([0 0]);
xlabel('X (m)'); ylabel('Y (m)'); zlabel('Z (m)');
set(gca,'Xdir','reverse'); set(gca,'Zdir','reverse');
axis equal 

Rot = eye(3); Trans = [0;0;0]; Location = [0 0 0;0 0 0;0 0 0];

start=20;     %Starting Frame
for i = start:FrameNum-1

    imageName_1 = strcat('stereo/','centre/',num2str(timestamps(i-1,1)),'.png');
    image_1 = demosaic(imread(imageName_1),'gbrg');
    undistortedImg_1 = UndistortImage(image_1,LUT);
    
    step(player, undistortedImg_1); %Refresh the video player
    
    imageName_2 = strcat('stereo/','centre/',num2str(timestamps(i,1)),'.png');
    image_2 = demosaic(imread(imageName_2),'gbrg');
    undistortedImg_2 = UndistortImage(image_2,LUT);
    
    I1gray = rgb2gray(undistortedImg_1);
    I2gray = rgb2gray(undistortedImg_2);
    
    imagePoints1 = detectSURFFeatures(I1gray,'MetricThreshold', 1000);
    imagePoints2 = detectSURFFeatures(I2gray,'MetricThreshold', 1000);
    
    imagePoints1 = selectUniform(imagePoints1, 500, size(I1gray));
    imagePoints2 = selectUniform(imagePoints2, 500, size(I2gray));
    
    [features1, Points_1] = extractFeatures(I1gray,imagePoints1,'Upright',true);
    [features2, Points_2] = extractFeatures(I2gray,imagePoints2,'Upright',true);
    
    indexPairs = matchFeatures(features1,features2);
    matchedPoints1 = Points_1(indexPairs(:,1));
    matchedPoints2 = Points_2(indexPairs(:,2));
    
    [F,inliers] = estimateFundamentalMatrix(matchedPoints1,matchedPoints2,'Method','RANSAC','NumTrials',2000,'DistanceThreshold',1e-4);
    
    inlierPoints1 = matchedPoints1(inliers);
    inlierPoints2 = matchedPoints2(inliers);
    
    [relativeOrientation,relativeLocation] = relativeCameraPose(F,cameraParams,inlierPoints1,inlierPoints2);
    
    [rotationMatrix,translationVector] = cameraPoseToExtrinsics(relativeOrientation,relativeLocation);
     
    Rot = rotationMatrix*Rot;
    Trans = Trans + (Rot*translationVector');
    Location = horzcat(Location, Trans);
        
    waitbar((i-start)/(FrameNum-1-start), waitBar);
end

hold off
saveas(gcf,'VisOdo_New_v2.2.1.png')
waitbar(1, waitBar, 'Completed!');
pause(10); close(waitBar)
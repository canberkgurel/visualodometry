%% ENPM673 PROJECT 2 VISUAL ODOMETRY CANBERK SUAT GUREL 115595972
clc;clear all;close all;warning off;

[fx, fy, cx, cy, G_camera_image, LUT] = ReadCameraModel('./stereo/centre','./model');
K=[fx 0 cx;0 fy cy;0 0 1];
timestamps = dlmread('./model/stereo.timestamps');
FrameNum = length(timestamps(:,1));
player = vision.VideoPlayer('Name', 'Processed Frame','Position',[30, 40, 800, 600]);    %[left bottom width height]
waitBar = waitbar(0,'Frames are processing...','Position',[820, 200, 280, 70]);
cameraPose = viewSet;

%% Main loop
start=20;     %Starting Frame
for i = start:FrameNum-1
    
    if(i==start)
        imageName_1 = strcat('stereo/','centre/',num2str(timestamps(i-1,1)),'.png');
        image_1 = demosaic(imread(imageName_1),'gbrg');
        undistortedImg_1 = UndistortImage(image_1,LUT);
        [Points_1, Feature_1, vPoints_1] = myFeature(undistortedImg_1);
        cameraPose = addView(cameraPose, start, 'Points', Points_1, 'Orientation', eye(3),'Location', [0 0 0]);
    end
    step(player, undistortedImg_1);
    
    imageName_2 = strcat('stereo/','centre/',num2str(timestamps(i,1)),'.png');
    image_2 = demosaic(imread(imageName_2),'gbrg');
    undistortedImg_2 = UndistortImage(image_2,LUT);
    
    [Points_2,Feature_2,IndexPairs,vPoints_2] = myMatchFeature(undistortedImg_2,Feature_1,undistortedImg_1, vPoints_1);
    matchedPoints1 = Points_1(IndexPairs(:,1));
    matchedPoints2 = Points_2(IndexPairs(:,2));
    
    [F,inlierIdx] = estimateFundamentalMatrix(matchedPoints1,matchedPoints2,...
        'Method','RANSAC','NumTrials',2000,'DistanceThreshold',1e-4);
    IndexPairs = IndexPairs(inlierIdx,:);
    
    E = findEssentialMatrix2(F,K);
    [Cset,Rset] = findCameraPose(E);
    
    [Rot,Trans,~] = selectCorrectEssential(Rset,Cset,...
        [matchedPoints1.Location ones(matchedPoints1.Count,1)]',...
        [matchedPoints2.Location ones(matchedPoints2.Count,1)]',K);
    
    Trans = Trans'*cameraPose.Views.Orientation{i-start+1} + cameraPose.Views.Location{i-start+1};
    Rot = Rot * cameraPose.Views.Orientation{i-start+1};
    
    cameraPose = addView(cameraPose, i+1, 'Points', Points_2,...
        'Orientation',Rot,'Location', Trans);
    
    undistortedImg_1 = undistortedImg_2;
    Points_1 = Points_2;
    Feature_1 = Feature_2;
    vPoints_1 = vPoints_2;
    
    waitbar((i-start)/(FrameNum-1-start), waitBar);
end
close(waitBar);
%% Display Results
figure
locations = vertcat(cameraPose.Views.Location{:});
plot3(locations(:,1),zeros(size(locations,1),1),locations(:,3),'Color','b','LineWidth',2)
view([0 0]);
set(gca,'Xdir','reverse');
set(gca,'Zdir','reverse');
grid on;
xlabel('X (m)');ylabel('Y (m)');zlabel('Z (m)');
saveas(gcf,'VisOdo_New_v2.1.4.png')

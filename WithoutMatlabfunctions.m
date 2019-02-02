%% ENPM673 PROJECT 2 VISUAL ODOMETRY CANBERK SUAT GUREL 115595972

clc;clear all;close all;warning off;

[fx, fy, cx, cy, G_camera_image, LUT] = ReadCameraModel('./stereo/centre','./model');
K=[fx 0 cx;0 fy cy;0 0 1];
timestamps = dlmread('./model/stereo.timestamps');
FrameNum = length(timestamps(:,1));
player = vision.VideoPlayer('Name', 'Processed Frame','Position',[30, 40, 800, 600]);    %[left bottom width height]
waitBar = waitbar(0,'Frames are processing...','Position',[820, 200, 280, 70]);
Rot = eye(3); Trans = [0;0;0]; Location = [0,0];
%%
start=20;     %Starting Frame
for i = start:FrameNum-1
    
    if(i==start)
        imageName_1 = strcat('stereo/','centre/',num2str(timestamps(i-1,1)),'.png');
        image_1 = demosaic(imread(imageName_1),'gbrg');
        undistortedImg_1 = UndistortImage(image_1,LUT);
        [Points_1, Feature_1, vPoints_1] = myFeature(undistortedImg_1);
    end
    step(player, undistortedImg_1);
    
    imageName_2 = strcat('stereo/','centre/',num2str(timestamps(i,1)),'.png');
    image_2 = demosaic(imread(imageName_2),'gbrg');
    undistortedImg_2 = UndistortImage(image_2,LUT);
    
    [Points_2,Feature_2,IndexPairs_find,vPoints_2] = myMatchFeature(undistortedImg_2,Feature_1,undistortedImg_1, vPoints_1);
    matchedPoints1 = Points_1(IndexPairs_find(:,1));
    matchedPoints2 = Points_2(IndexPairs_find(:,2));
    
    F = fundamentalRANSAC(matchedPoints1, matchedPoints2);
    
    E = findEssentialMatrix(F,K);
    [Cset,Rset] = findCameraPose(E);
    
    [rotationMatrix, translationVector] = selectCorrect(Cset, Rset);
    Trans = Trans + Rot * translationVector;
    Rot = Rot * rotationMatrix;

    Location = [Location;[Trans(1),Trans(3)]];

    undistortedImg_1 = undistortedImg_2;
    Points_1 = Points_2;
    Feature_1 = Feature_2;
    vPoints_1 = vPoints_2;
    
    waitbar((i-start)/(FrameNum-1-start), waitBar);
end
close(waitBar);
%% Display Results
figure 
Location = [Location;[Trans(1),Trans(3)]];
plot3(-Location(:,1), zeros(size(Location,1),1), Location(:,2),'Color','r','LineWidth',2)
view([0 0]);
xlabel('X (m)');ylabel('Y (m)');zlabel('Z (m)');
set(gca,'Xdir','reverse');
set(gca,'Zdir','reverse');
grid on;
saveas(gcf,'WithoutMatlabFunctions.png')

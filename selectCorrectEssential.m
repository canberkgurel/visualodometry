function [Rotation,Translation,correct] = selectCorrectEssential(rot,t,x1,x2,k)
% This function extracts the cameras from the essential matrix

nx1 = findNCoordinates(x1,k);
nx2 = findNCoordinates(x2,k);
for i=1:4
    x3D(:,:,i) = computeLTriangulation(nx1, nx2, rot(:,:,i), t(:,:,i));
    x3D(:,:,i) = computeHCoordinates(x3D(:,:,i),'3D');
end

for i=1:4    
    % compute the depth & sum the sign
    pDepth(i,1) = sum(sign(findPointDepth(x3D(:,:,i),eye(3),zeros(3,1)))); %using canonical camera
    pDepth(i,2) = sum(sign(findPointDepth(x3D(:,:,i),rot(:,:,i),t(:,:,i)))); % using the recovered camera
end

if(pDepth(1,1)<0 && pDepth(1,2)<0)
    correct = 1;
elseif(pDepth(2,1)<0 && pDepth(2,2)<0)
    correct = 2;
elseif(pDepth(3,1)<0 && pDepth(3,2)<0)
    correct = 3;
elseif(pDepth(4,1)<0 && pDepth(4,2)<0)
    correct = 4;
else
    correct = randi([1,4],1);
    disp('PVC!')
end

% return the selected solution
Rotation = rot(:,:,correct);
Translation = t(:,correct);
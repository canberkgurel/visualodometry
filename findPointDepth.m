function d = findPointDepth(x3D,rot,t)

[k,r,c] = DecomposeCameraMatrix([rot t]); 

x3D = computeHCoordinates(x3D,'3D');

for i=1:size(x3D,2)
    w = rot(3,:) * (x3D(1:3,i) - c(1:3,:));
    
    depth = (sign(det(rot)) * w) / x3D(4,i) * norm(rot(3,:));
    
    d(i) = depth(1,1);
end

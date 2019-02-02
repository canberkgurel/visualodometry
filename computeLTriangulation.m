function x3D = computeLTriangulation(x1,x2,rot,t)

p1 = eye(3,4);
p2 = [rot t];

for i=1:size(x1,2)
    a = [ x1(1,i)*p1(3,:) - p1(1,:); ...
          x1(2,i)*p1(3,:) - p1(2,:); ... 
          x2(1,i)*p2(3,:) - p2(1,:); ...
          x2(2,i)*p2(3,:) - p2(2,:) ];
    
    [u,d,v] = svd(a);
    x3D(:,i) = v(:,4);
end

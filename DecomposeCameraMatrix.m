function [k,r,c] = DecomposeCameraMatrix(p) 

x =  det([ p(:,2), p(:,3), p(:,4) ]);
y = -det([ p(:,1), p(:,3), p(:,4) ]);
z =  det([ p(:,1), p(:,2), p(:,4) ]);
t = -det([ p(:,1), p(:,2), p(:,3) ]);

c = [ x/t; y/t; z/t ];

[k,r] = decomposition(p(:,1:3));

function nx = findNCoordinates(x,k)
%This function returns the normalized coordinates
nx = inv(k) * x;
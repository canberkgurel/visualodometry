function q = rotMatrix(Matrix, Axis)
if (Axis == 1)
	c = -Matrix(3,3)/sqrt(Matrix(3,2)^2 + Matrix(3,3)^2);
	s = Matrix(3,2)/sqrt(Matrix(3,2)^2 + Matrix(3,3)^2);
	q = [1 0 0; 0 c -s; 0 s c];
elseif (Axis == 2)
	c = Matrix(3,3)/sqrt(Matrix(3,1)^2 + Matrix(3,3)^2);
	s = Matrix(3,1)/sqrt(Matrix(3,1)^2 + Matrix(3,3)^2);
	q = [c 0 s; 0 1 0; -s 0 c];
elseif (Axis == 3)
	c = -Matrix(2,2)/sqrt(Matrix(2,2)^2 + Matrix(2,1)^2);
	s = Matrix(2,1)/sqrt(Matrix(2,2)^2 + Matrix(2,1)^2);
	q = [c -s 0; s c 0; 0 0 1];
end

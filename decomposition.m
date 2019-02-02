function [k,r] = decomposition(Matrix)
    qx = rotMatrix(Matrix,1);
    k = Matrix * qx;
    qy = rotMatrix(k,2);
    k = k * qy;
    qz = rotMatrix(k,3);
    k = k * qz;
    r = qz' * qy' * qx';
    if r(1,1) < 0
        d = diag([-1 -1 ones(1,1)]);
        r = r * d;
        k = d * k;
    end
end
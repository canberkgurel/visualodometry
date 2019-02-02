function E = findEssentialMatrix(F,K)
E=K'*F*K;
[u,~,v]=svd(E);
E = u*[1 0 0;0 1 0;0 0 0]*v';
E=E/norm(E);
end
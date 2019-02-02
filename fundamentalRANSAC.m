function F = fundamentalRANSAC(matchedpoints1, matchedpoints2)
global thresh;
thresh = 3;
F = zeros(3,3); n = 0; N = 2000; p = 0.95;
sizes = int32(size(matchedpoints1,1));
previousScore = findFitnessScore(F, matchedpoints1.Location, matchedpoints2.Location);
pointIndices = [];
while n < N
    %Select 8 Points at random
    ind = randi(sizes,1,8);
    x1 = matchedpoints1(ind);
    x2 = matchedpoints2(ind);
    f = eFM(x1.Location, x2.Location);
    [currentScore, chosenIndices] = findFitnessScore(f,matchedpoints1.Location, matchedpoints2.Location);
    if  currentScore > previousScore
        F = f;
        pointIndices = chosenIndices;
        N = min(N,log(1-p) / log(1 - currentScore^8));
        previousScore = currentScore;
    end
    n = n + 1;
end
%Compute fundamental matrix using best fundamental matrix
x1 = matchedpoints1(pointIndices);
x2 = matchedpoints2(pointIndices);
F = eFM(x1.Location, x2.Location);
end
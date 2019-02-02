function [R, t] = selectCorrect(Cset, Rset)
ind = [];
for i = 1: length(Cset)
    if (Cset(3,1,i) > 0)
        ind = [ind;i];
    end
end
new_Rset = {};
j = 1;
ind_2 = [];
if (size(ind,1) > 0)
    for i=1:size(ind,1)
        R_test = Rset(:,:,ind(i));
        if R_test(2,2) > 0.9 && abs(R_test(1,2)) < 0.1 && abs(R_test(2,1)) < 0.1 && ...
                abs(R_test(2,3)) < 0.1 && abs(R_test(3,2)) < 0.1
            new_Rset{j} = R_test;
            j = j + 1;
            ind_2 = [ind_2;ind(i)];
        end
    end
    if (size(ind_2,1) > 0)
        R = new_Rset{1};
        t = [Cset(1,:,ind_2(1));0;Cset(3,:,ind_2(1))];
        min_y = abs(Cset(2,:,ind_2(1)));
        for i = 2: size(ind_2,1)
            curr_min_y = abs(Cset(2,:,ind_2(i)));
            if curr_min_y < min_y
                min_y = curr_min_y;
                R = new_Rset{i};
                t = [Cset(1,:,ind_2(i));0;Cset(3,:,ind_2(i))];
            end
        end
        R(1,2) = 0;
        R(2,1) = 0;
        R(2,3) = 0;
        R(3,2) = 0;
        if abs(R(1,3)) < 0.001
            R(1,3) = 0;
        end
        if abs(R(3,1)) < 0.001
            R(3,1) = 0;
        end
        if abs(t(1)) < 0 || R(1,1) > 0.99
            t = [0;0;t(3)];
        end
    else
        R = eye(3);
        t = [0;0;0];
    end
else
    R = eye(3);
    t = [0;0;0];
end
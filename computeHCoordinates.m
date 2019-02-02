function h = computeHCoordinates(p,Points)

if (strcmp(Points,'2D'))
    if (size(p,1) == 2)
        h = [p;  ones(size(p,2),1)'];
    else if (size(p,1) == 3)
            h(1,:) = p(1,:)./p(3,:);
            h(2,:) = p(2,:)./p(3,:);
            h(3,:) = p(3,:)./p(3,:);
        end
    end
else if (strcmp(Points,'3D'))
        if (size(p,1) == 3)
            h = [p;  ones(size(p,2),1)'];
        else if (size(p,1) == 4)
                h(1,:) = p(1,:)./(p(4,:)+eps);
                h(2,:) = p(2,:)./(p(4,:)+eps);
                h(3,:) = p(3,:)./(p(4,:)+eps);
                h(4,:) = p(4,:)./(p(4,:)+eps);
            end
        end
    else if (strcmp(Points,'2Dforce'))
            h = [p(1:2,:);  ones(size(p,2),1)'];
        end
    end
end
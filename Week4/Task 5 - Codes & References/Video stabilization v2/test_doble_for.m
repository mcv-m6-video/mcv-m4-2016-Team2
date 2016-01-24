for i = 1:height
        for j = 1:width
            if ((u1(i,j,k) ~= 0) || (v1(i,j,k) ~= 0))
                l = l + 1;
                m1(: , l) = [i , j];
                m2(: , l) = [i+v1(i,j,k) , j+u1(i,j,k)];
            end
        end
end
    
nonZeroU1 = find(u1Frame);
nonZeroV1 = find(v1Frame);
nonZero = intersect(nonZeroU1, nonZeroV1);
[I, J] = ind2sub(size(u1Frame), nonZero);
pointsA = zeros(2, length(I));
pointsA(1, :) = I;
pointsA(2, :) = J;

pointsB = zeros(2, length(I));
pointsB(1, :) = I + u1Frame(nonZero);
pointsB(2, :) = J + v1Frame(nonZero);
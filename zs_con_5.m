% Condition 5 for Zhang-Suen Thinning Algorithm.

function condition_5 = zs_con_5(image , r , c)
    % Pixel value of north neighbour.
    x3 = image(r-1,c);

    % Pixel value of east neighbour.
    x1 = image(r,c+1);

    % Pixel value of west neighbour.
    x5 = image(r,c-1);
    
    if (x3 == 1 || x1 == 1 || x5 == 1)
        condition_5 = true;
    else
        condition_5 = false;
    end
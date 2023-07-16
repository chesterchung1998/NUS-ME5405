% Condition 4 for Zhang-Suen Thinning Algorithm.

function condition_4 = zs_con_4(image , r , c)
    % Pixel value of east neighbour.
    x1 = image(r,c+1);

    % Pixel value of south neighbour.
    x7 = image(r+1,c);

    % Pixel value of west neighbour.
    x5 = image(r,c-1);
    
    if (x5 == 1 || x1 == 1 || x7 == 1)
        condition_4 = true;
    else
        condition_4 = false;
    end
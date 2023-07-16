% Condition 6 for Zhang-Suen Thinning Algorithm.

function condition_6 = zs_con_6(image , r , c)
    % Pixel value of north neighbour.
    x3 = image(r-1,c);

    % Pixel value of south neighbour.
    x7 = image(r+1,c);

    % Pixel value of west neighbour.
    x5 = image(r,c-1);
    
    if (x3 == 1 || x7 == 1 || x5 == 1)
        condition_6 = true;
    else
        condition_6 = false;
    end
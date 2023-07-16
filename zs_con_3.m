% Condition 3 for Zhang-Suen Thinning Algorithm.

function condition_3 = zs_con_3(image , r , c)
    % Pixel value of north neighbour.
    x3 = image(r-1,c);

    % Pixel value of east neighbour.
    x1 = image(r,c+1);

    % Pixel value of south neighbour.
    x7 = image(r+1,c);
    
    if (x3 == 1 || x1 == 1 || x7 == 1)
        condition_3 = true;
    else
        condition_3 = false;
    end

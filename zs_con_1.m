% Condition 1 for Zhang-Suen Thinning Algorithm.

function condition_1 = zs_con_1(image , r , c)
    % Pixel values of the eight neighbours.
    x1 = image(r,c+1);
    x2 = image(r-1,c+1);
    x3 = image(r-1,c);
    x4 = image(r-1,c-1);
    x5 = image(r,c-1);
    x6 = image(r+1,c-1);
    x7 = image(r+1,c);
    x8 = image(r+1,c+1);
    
    % Number of black pixels
    black_pixels = 8 - (x1+x2+x3+x4+x5+x6+x7+x8);

    % 2 <= B(i,j) <= 6
    if (black_pixels >= 2 && black_pixels <= 6)
        condition_1 = true;
    else
        condition_1 = false;
    end


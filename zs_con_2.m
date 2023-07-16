% Condition 2 for Zhang-Suen Thinning Algorithm.

function condition_2 = zs_con_2(image , r , c)
    % Pixel values of the eight neighbours.
    x1 = image(r,c+1);
    x2 = image(r-1,c+1);
    x3 = image(r-1,c);
    x4 = image(r-1,c-1);
    x5 = image(r,c-1);
    x6 = image(r+1,c-1);
    x7 = image(r+1,c);
    x8 = image(r+1,c+1);

    % Calculate the number of transitions from white to black for eight
    % neighbours.

    if (x1 == 1 && x8 == 0)
        t1 = 1;
    else
        t1 = 0;
    end

    if (x8 == 1 && x7 == 0)
        t2 = 1;
    else
        t2 = 0;
    end

    if (x7 == 1 && x6 == 0)
        t3 = 1;
    else
        t3 = 0;
    end

    if (x6 == 1 && x5 == 0)
        t4 = 1;
    else
        t4 = 0;
    end

    if (x5 == 1 && x4 == 0)
        t5 = 1;
    else
        t5 = 0;
    end

    if (x4 == 1 && x3 == 0)
        t6 = 1;
    else
        t6 = 0;
    end

    if (x3 == 1 && x2 == 0)
        t7 = 1;
    else
        t7 = 0;
    end

    if (x2 == 1 && x1 == 0)
        t8 = 1;
    else
        t8 = 0;
    end

    w2b_transitions = t1+t2+t3+t4+t5+t6+t7+t8;

    if (w2b_transitions == 1)
        condition_2 = true;
    else
        condition_2 = false;
    end

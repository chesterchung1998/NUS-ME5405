function [connectivity, is_end_point] = checkconnectivity(window)
    
    % central pixel
    i = 2; j = 2;

    N0 = window(i, j);
    N1 = window(i, j+1);
    N2 = window(i-1, j+1);
    N3 = window(i-1, j);
    N4 = window(i-1, j-1);
    N5 = window(i, j-1);
    N6 = window(i+1, j-1);
    N7 = window(i+1, j);
    N8 = window(i+1, j+1);

    val = [N1 N2 N3 N4 N5 N6 N7 N8];
    arr = [N1<N2 N2<N3 N3<N4 N4<N5 N5<N6 N6<N7 N7<N8 N8<N1];

    connectivity = sum(arr);
    is_end_point = abs(N0 - sum(val));

end
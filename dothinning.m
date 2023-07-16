function [thinned_image] = dothinning(binary_image)

% Matcher templates
T1 = [0; 1; 1]; % remove top
T2 = T1';       % remove left
T3 = [1; 1; 0]; % remove bottom
T4 = T3';       % remove right

[row, col] = size(binary_image);
mark_pixels = zeros(row, col);
thinned_image = ~binary_image;
template = 1;
count = 1;

while (count < 5)
    for i = 2:row-1
        for j = 2:col-1
            window = thinned_image(i-1:i+1, j-1:j+1);
            if (template == 1)
                match = isequal(window(:,2) , T1);
            elseif (template == 2)
                match = isequal(window(2,:) , T2);
            elseif (template == 3)
                match = isequal(window(:,2) , T3);
            elseif (template == 4)
                match = isequal(window(2,:) , T4);
            end

            % Connectivity number
            [connectivity, is_end_point] = checkconnectivity(window);

            if (thinned_image(i, j) == 1 && match == 1 && connectivity == 1 && (is_end_point ~= 0))
                mark_pixels(i, j) = 1;
            end
        end
    end

    if (sum(sum(mark_pixels)) == 0)
        count = count + 1;
    else
        count = 1;
    end

    thinned_image = thinned_image > mark_pixels;
    mark_pixels = zeros(row, col);
    template = template + 1;

    % Reset
    if template == 5
        template = 1;
    end
end

thinned_image = ~thinned_image;
end
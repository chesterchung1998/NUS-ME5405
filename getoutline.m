% Function for getting outline of image.

function [outlined_image] = getoutline(binary_image)

[row, col] = size(binary_image);
outlined_image = ones(row, col);

% Pass 1 (detect changes in y direction)
for i = 2:row
    for j = 1:col
        if (binary_image(i, j) ~= binary_image(i-1, j))
            outlined_image(i, j) = 0;
        end
    end
end

% Pass 2 (detect changes in x direction)
for i = 1:row
    for j = 1:col-1
        if (binary_image(i, j) ~= binary_image(i, j+1))
            outlined_image(i, j) = 0;
        end
    end
end

end
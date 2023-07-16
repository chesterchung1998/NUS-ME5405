% Function for obtaining binary image.

function final_img = binary_image(origin_image , threshold_value)
    % img = imread(origin_image);
    img = origin_image;
    img = im2gray(img);
    [m , n] = size(img);
    threshold_image = zeros(m,n);
    for i = 1:m
        for j = 1:n
            if (img(i,j) > threshold_value)
            threshold_image(i,j) = 0;
            else
            threshold_image(i,j) = 1;
            end
        end
    end
    final_img = threshold_image;
end

    
    
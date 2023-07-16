% ME5405 Main Script for Image 1 (chromo.txt).
% Group Members: Brina Shong (A0170862A), Chester Chung (A0201459J), Zhu
% Rundong (A0263429Y).

clc;
clear;
close all;

% Reading the text file into array.
% fid = fopen("C:\Users\chest\OneDrive\Desktop\Chesters Folder\AY22-23 Semester 1 Modules\ME5405 Machine Vision\Part 1\Assignments\chromo.txt" , 'rt');
fid = fopen("chromo.txt",'rt');
indata = textscan(fid , '%s');
fclose(fid);
I = indata{1};
A = cell2mat(I);
[m , n] = size(A);

% Mapping the alphanumeric characters to gray values 0-31.
dict = containers.Map({'0' '1' '2' '3' '4' '5' '6' '7' '8' '9' 'A' 'B' 'C' 'D' 'E' 'F' 'G' 'H' 'I' 'J' 'K' 'L' 'M' 'N' 'O' 'P' 'Q' 'R' 'S' 'T' 'U' 'V'}, ...
     {0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31});

original_image = zeros(m,n);

k = 1;
for i = 1:m % rows
    for j = 1:n % columns
        original_image(j,i) = dict(A(k));
        k = k + 1;
    end
end

%% Display original image. (Task 1)
figure(1);
subplot(1,2,1);
imshow(original_image, [0 31]);
colormap(gray(32));
title("Original Image");

%% Thresholding and converting to binary image. (Task 2)
% Computing the Histogram.
H = zeros(1, 32);
for i = 1 : size(original_image , 1)
    for j = 1 : size(original_image , 2)
        H(original_image(i,j) + 1) = H(original_image(i,j) + 1) + 1;
    end
end

% Plotting the Histogram.
figure(2);
bar(H);
title('Histogram (Original image) (Threshold = 20)');

% Thresholding and converting to binary image. (Task 2)
min_level = min(min(original_image));
max_level = max(max(original_image));
threshold_image = zeros(m,n);
threshold = 20; % By trial & error and histogram visualization, this threshold value is the most appropriate.
for i = 1:m
    for j = 1:n
        if (original_image(i,j) > threshold)
            threshold_image(i,j) = 1;
        else
            threshold_image(i,j) = 0;
        end
    end
end

% Display Binary Image.
figure(1);
subplot(1,2,2);
imshow(threshold_image, [0 1]);
title("Binary Image");

%% Determine one-pixel thin image of objects (using Zhang-Suen Thinning
% Algorithm and Stentiford Thinning Algorithm). (Task 3)

% Zhang-Suen Thinning Algorithm.
thinned_image = threshold_image;
for k = 1:1000   % Number of iterations
    for i = 2:m-1
        for j = 2:n-1
            if (thinned_image(i,j) == 0)
                if (zs_con_1(thinned_image,i,j) && zs_con_2(thinned_image,i,j) && zs_con_3(thinned_image,i,j) && zs_con_4(thinned_image,i,j))
                    thinned_image(i,j) = 1; % Delete the pixel - change from object pixel to background pixel
                elseif (zs_con_1(thinned_image,i,j) && zs_con_2(thinned_image,i,j) && zs_con_5(thinned_image,i,j) && zs_con_6(thinned_image,i,j))
                    thinned_image(i,j) = 1;
                end
            end
        end
    end
end

% Stentiford Thinning Algorithm.
% Template Type
T1 = [0 , 1 , 1]';
T2 = T1';
T3 = [1 , 1 , 0]';
T4 = T3';

[row, col, plane] = size(original_image);
imgBin = double(binary_image(original_image, 20));
ouImg = imgBin;
S = [1 3 5 7];
checkVal = 2;
template = 1;
outBinary = zeros(row,col);
con = 5;

while (con < 15)
    for i = 2:row-1
        for j = 2:col-1
            window = imgBin(i-1:i+1 , j-1:j+1);
            if (template == 1)
                andOp1 = isequal(window(:,2) , T1);
                matchTemplate = andOp1;
            end
            if (template == 2)
                andOp1 = isequal(window(2,:) , T2);
                matchTemplate = andOp1;
            end
            if (template == 3)
                andOp1 = isequal(window(:,2) , T3);
                matchTemplate = andOp1;
            end
            if (template == 4)
                andOp1 = isequal(window(2,:) , T4);
                matchTemplate = andOp1;
            end

            % Connectivity number
            [Cn, EndPoint] = connectivityFun(window);

            if imgBin(i,j) == 1
                if ((matchTemplate) == 1)
                    if Cn == 1
                        if (EndPoint ~= 0)
                            outBinary(i,j) = 1;
                        end
                    end
                end
            end
        end
    end
    checkVal = sum(sum(outBinary));
    if (checkVal == 0)
        con = con + 1;
    end

    binVal = find(outBinary == 1);
    imgBin(binVal) = 0;
    outBinary = zeros(row , col);
    template = template + 1;

    % Iteration
    if template == 5
        outBinary = zeros(row,col);
        template = 1;
    end
end

for i = 1:row
    for j = 1:col
        if imgBin(i,j) == 0
            imgBin(i,j) = 1;
        elseif imgBin(i,j) == 1
            imgBin(i,j) = 0;
        end
    end
end


% Display one-pixel thin image of objects and compare with binary image. 
figure(3);
subplot(2,2,1);
imshow(threshold_image , [0 1]);
title("Binary image");
subplot(2,2,2);
imshow(thinned_image , [0 1]);
title("Zhang-Suen Thinned image");
subplot(2,2,3);
imshow(imgBin,[0 1]);
title('Stentiford Thinned Image');

%% Determine the outlines. (Task 4)

[outlined_image] = getoutline(threshold_image);
figure(4);
subplot(1,2,1);
imshow(threshold_image);
title("Binary Image");
subplot(1,2,2);
imshow(outlined_image);
title('Outlined Image');

% For comparison with our outlined image.
BW2 = bwmorph(~threshold_image,'remove');
BW2 = ~BW2;
figure(5);
subplot(1,2,1);
imshow(outlined_image);
title('Our Outlined Image');
subplot(1,2,2);
imshow(BW2);
title('MATLAB Outlined Image');

%% Label the different objects. (Task 5)
[labelled_image, coloured_image] = label(~threshold_image, 4);
figure(6);
subplot(1,2,1);
imshow(coloured_image)
title('4-Connectivity Labelled Image');
[labelled_image, coloured_image] = label(~threshold_image, 8);
subplot(1,2,2);
imshow(coloured_image)
title('8-Connectivity Labelled Image');

%% Rotate the original image by 30 degrees, 60 degrees and 90 degrees
% respectively. (Task 6)
rot_angle = pi/6; % 30 degrees
T = [cos(rot_angle),-sin(rot_angle) 0; sin(rot_angle),cos(rot_angle) 0; 0 0 1];
im = original_image;
method = 'nearest';
step = 0.05;
rot_image_30 = imgeomt(T , im , method, step);

figure(7);
subplot(2,2,1);
imshow(original_image, [0 31])
title('Original image');
subplot(2,2,2);
imshow(rot_image_30, [0 31]);
title("Rotated by 30 degrees");

rot_angle = pi/3; % 60 degrees
T = [cos(rot_angle),-sin(rot_angle) 0; sin(rot_angle),cos(rot_angle) 0; 0 0 1];
method = 'nearest';
step = 0.05;
rot_image_60 = imgeomt(T , im , method, step);

figure(7);
subplot(2,2,3);
imshow(rot_image_60 , [0 31]);
title("Rotated by 60 degrees");

rot_angle = pi/2; % 90 degrees
T = [cos(rot_angle),-sin(rot_angle) 0; sin(rot_angle),cos(rot_angle) 0; 0 0 1];
method = 'nearest';
step = 0.05;
rot_image_90 = imgeomt(T , im , method, step);

figure(7);
subplot(2,2,4);
imshow(rot_image_90 , [0 31]);
title("Rotated by 90 degrees");

% Comparison between bilinear interpolation, nearest neighbors, and bicubic interpolation.
rot_angle = pi/3; % 60 degrees
T = [cos(rot_angle),-sin(rot_angle) 0; sin(rot_angle),cos(rot_angle) 0; 0 0 1];
method = 'nearest';
step = 0.05;
rot_image_60 = imgeomt(T , im , method, step);

figure(8);
subplot(2,2,1);
imshow(rot_image_60 , [0 31]);
title("Nearest Neighbours");

rot_angle = pi/3; % 60 degrees
T = [cos(rot_angle),-sin(rot_angle) 0; sin(rot_angle),cos(rot_angle) 0; 0 0 1];
method = 'linear';
step = 0.05;
rot_image_60 = imgeomt(T , im , method, step);

figure(8);
subplot(2,2,2);
imshow(rot_image_60 , [0 31]);
title("Bilinear interpolation");

rot_angle = pi/3; % 60 degrees
T = [cos(rot_angle),-sin(rot_angle) 0; sin(rot_angle),cos(rot_angle) 0; 0 0 1];
method = 'cubic';
step = 0.05;
rot_image_60 = imgeomt(T , im , method, step);

figure(8);
subplot(2,2,3);
imshow(rot_image_60 , [0 31]);
title("Bicubic interpolation");


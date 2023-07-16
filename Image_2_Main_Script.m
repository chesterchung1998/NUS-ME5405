% ME5405 Main Script for Image 2 (hello_world.jpg).
% Group Members: Brina Shong (A0170862A), Chester Chung (A0201459J), Zhu
% Rundong (A0263429Y).

clear;
close all;
clc;

%% Display image on screen (Task 1)
ori_image = imread('hello_world.jpg');
figure(1);
image(ori_image);
axis image;
title('Original Image');

%% Create sub-image comprising the middle line (Task 2)
[h, w] = size(ori_image);
sub_image = imcrop(ori_image, [0 h/3 w h/3]);
figure(2);
image(sub_image);
axis image;
title('Sub-image');

%% Create binary image using thresholding (Task 3)
gray_image = rgb2gray(sub_image);
figure(3);
subplot(2,1,1);
imshow(gray_image);
title('Gray Image');

% Computing the histogram
H = zeros(1, 256);
for i = 1:size(gray_image, 1)
    for j = 1:size(gray_image, 2)
        H(gray_image(i, j) + 1) = H(gray_image(i, j) + 1) + 1;
    end
end

% Plotting the histogram
figure(4);
bar(H);
title('Histogram (Gray image)');
xlim([0 256]);

% Thresholding
[r, c] = size(gray_image);
binary_image = false(r, c);
threshold = 130; % By trial & error and histogram visualization, this threshold value is the most appropriate.

for i = 1:r
    for j = 1:c
        if (gray_image(i, j) > threshold)
            binary_image(i, j) = true;
        end
    end
end

figure(3);
subplot(2,1,2);
imshow(binary_image);
title("Binary Image");

%% Determine one-pixel thin image of objects (using Zhang-Suen Thinning Algorithm) (Task 4)

% Zhang-Suen Thinning Algorithm.
thinned_image = binary_image;
[m,n] = size(thinned_image);

for k = 1:1000   % Number of iterations
    for i = 2:m-1
        for j = 2:n-1
            if (thinned_image(i,j) == 1)
                if (zs_con_1(thinned_image,i,j) && zs_con_2(thinned_image,i,j) && zs_con_3(thinned_image,i,j) && zs_con_4(thinned_image,i,j))
                    thinned_image(i,j) = 0; % Delete the pixel - change from object pixel to background pixel
                elseif (zs_con_1(thinned_image,i,j) && zs_con_2(thinned_image,i,j) && zs_con_5(thinned_image,i,j) && zs_con_6(thinned_image,i,j))
                    thinned_image(i,j) = 0;
                end
            end
        end
    end
end

% For comparison with our one-pixel thin image.
BC1=imcomplement(binary_image);
a4 = bwmorph(binary_image, 'skel', inf);
a5=bwmorph(a4,'spur',4);
BC2=imcomplement(a5);
[r, c]=find(BC2==0);
A=[r,c];
e=zeros(2560,1);
f=zeros(2560,1);
for i=1:1:2560
    d=find(c==i);
    f(i)=length(d)+0.5;
    e(i)=sum(r(d));
end
h=e./f;
s=round(h);
a=ones(1440,2560);
X = 1:1:2560;
for X = 1:1:2560
    a(X) = 0;
end

figure(5);
subplot(2,1,1);
imshow(binary_image, [0 1]);
title('Binary Image');
subplot(2,1,2);
imshow(thinned_image, [0 1]);
title('Zhang-Suen Thinned Image');

figure(6);
subplot(2,1,1);
imshow(thinned_image, [0 1]);
title('Our one-pixel thin image');
subplot(2,1,2);
imshow(a5 , [0 1]);
title("MATLAB one-pixel thin image (bwmorph)");

%% Outline of the objects (Task 5)
[outlined_image] = getoutline(binary_image);
figure(7);
subplot(2,1,1);
imshow(binary_image);
title("Binary Image");
subplot(2,1,2);
imshow(~outlined_image);
title('Outlined Image');

BW2 = bwmorph(~binary_image,'remove');
figure(8);
subplot(2,1,1);
imshow(~outlined_image);
title('Our Outlined Image');
subplot(2,1,2);
imshow(BW2);
title('MATLAB Outlined Image');

%% Segment and label objects (Task 6)
[labelled_image, coloured_image] = label(binary_image, 4);
figure(9);
subplot(2,1,1);
imshow(coloured_image)
title('4-Connectivity Labelled Image');
[labelled_image, coloured_image] = label(binary_image, 8);
subplot(2,1,2);
imshow(coloured_image)
title('8-Connectivity Labelled Image');

segmented_images = segment(labelled_image, 80);
figure(10);
num = size(segmented_images,3);
col = round(num/2);
for n = 1:num
    subplot(2,col,n);
    imshow(segmented_images(:,:,n));
end

%% Keep and display the 10 desired characters (Task 7)
keep_array = [2 3 4 5 6 7 8 9 10 11];
char_array = ['HEOORLDLLW'];
figure(11);
count = 1;
selected_images = true(size(segmented_images,1), size(segmented_images,2), 10);
for n = 1:num
    if (ismember(n, keep_array))
        subplot(2,5,count);
        selected_images(:,:,count) = segmented_images(:,:,n);
        imshow(selected_images(:,:,count));
        title(char_array(count));
        count = count + 1;
    end
end    

%% Image classification data (Task 7)
% store all images
dataset = imageDatastore(fullfile('p_dataset_26'),'IncludeSubfolders',true,'LabelSource','foldernames');

% use 75% of the dataset for training, 25% for testing
[train_set, test_set] = splitEachLabel(dataset,0.75);

%% feature extraction parameters (Task 7)
% test the effects of varying cell size on HOG 
img = readimage(dataset,311);
[hog_8x8, vis8x8] = extractHOGFeatures(img,'CellSize',[8 8]);
[hog_16x16, vis16x16] = extractHOGFeatures(img,'CellSize',[16 16]);
[hog_32x32, vis32x32] = extractHOGFeatures(img,'CellSize',[32 32]);

figure(12);
subplot(2,3,1:3); imshow(img);

subplot(2,3,4);
plot(vis8x8);
title({'CellSize = [8 8]'; ['Length = ' num2str(length(hog_8x8))]});

subplot(2,3,5);
plot(vis16x16);
title({'CellSize = [16 16]'; ['Length = ' num2str(length(hog_16x16))]});

subplot(2,3,6);
plot(vis32x32);
title({'CellSize = [32 32]'; ['Length = ' num2str(length(hog_32x32))]});

% cell size selected by visual observation
cell_size = [16 16];
hog_feature_size = length(hog_16x16);

%% feature extraction (Task 7)
% feature extraction on train set
num_images = numel(train_set.Files);
training_features = zeros(num_images,hog_feature_size,'single');

for i = 1:num_images
    img = readimage(train_set,i);
    training_features(i,:) = extractHOGFeatures(img,'CellSize',cell_size);
end

training_labels = train_set.Labels;

% feature extraction on test set
num_images = numel(test_set.Files);
test_features = zeros(num_images,hog_feature_size,'single');

for i = 1:num_images
    img = readimage(test_set,i);
    test_features(i,:) = extractHOGFeatures(img,'CellSize',cell_size);
end

test_labels = test_set.Labels;

%% train SVM classifier (Task 7)
tic
svm_classifier = trainSVM(training_features,training_labels,test_features,test_labels); % To use KNN classifier, change 'fitcecoc' to 'fitcknn' in the file labelled 'trainSVM'.
toc

%% SVM prediction (Task 7)
num = size(selected_images,3);
resized_images = true(128, 128, num);
for n = 1:num
    resized_images(:,:,n) = imresize(selected_images(:,:,n), [128 128]);
end

num = size(resized_images,3);
features = zeros(num,hog_feature_size,'single');
for i = 1:num
    img = resized_images(:,:,i);
    features(i,:) = extractHOGFeatures(img,'CellSize',cell_size);
end

predicted_labels_svm = predict(svm_classifier, features);
figure(13); 
col = round(num/2);
resized_images = true(128, 128, num);
for n = 1:num
    subplot(2,col,n);
    resized_images(:,:,n) = imresize(selected_images(:,:,n), [128 128]);
    imshow(resized_images(:,:,n));
    title(predicted_labels_svm(n));
end
sgtitle('SVM Predicted Labels');
clc; clear variables;
% https://www.mathworks.com/help/vision/ug/uncalibrated-stereo-image-rectification.html
% get the path of image
image_path_1 = GetImagePath('2000');
image_path_2 = GetImagePath('2004');

% load images
I1 = imread(image_path_1);
I2 = imread(image_path_2);

% Convert to grayscale
I1gray = rgb2gray(I1);
I2gray = rgb2gray(I2);

% feature detection
blobs1 = detectSURFFeatures(I1gray,'MetricThreshold',1000,'NumOctaves',3,'NumScaleLevels',4);
blobs2 = detectSURFFeatures(I2gray,'MetricThreshold',1000,'NumOctaves',3,'NumScaleLevels',4);

% figure
% imshow(I1); hold on;
% plot(blobs1.selectStrongest(100));
% 
% figure
% imshow(I2); hold on;
% plot(blobs2.selectStrongest(100));





%% function area
function image_path = GetImagePath(jahr)
    image_path = "/Users/yuqichengzhu/Desktop/SS21/CV/Project/Datasets/Columbia Glacier/" + jahr + "_12.jpg";
end

function ShowFeature(I1, I2, blobs1, blobs2, num)
    figure('Renderer', 'painters', 'Position', [10 10 1500 500]);
    subplot(121)
    imshow(I1);
    hold on;
    plot(selectStrongest(blobs1, num));
    title('Image 1');

    subplot(122)
    imshow(I2);
    hold on;
    plot(selectStrongest(blobs2, num));
    title('Image 2');
end
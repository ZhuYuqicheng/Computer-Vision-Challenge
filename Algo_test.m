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
blobs1 = detectORBFeatures(I1gray);
blobs2 = detectORBFeatures(I2gray);

% show strongest features (with num)
% ShowFeature(I1, I2, blobs1, blobs2, 10)

% match the correspondences
[features1, validBlobs1] = extractFeatures(I1gray, blobs1);
[features2, validBlobs2] = extractFeatures(I2gray, blobs2);
% get indeces
indexPairs = matchFeatures(features1, features2, 'Metric', 'SAD', ...
  'MatchThreshold', 5);
% Retrieve locations of matched points for each image.
matchedPoints1 = validBlobs1(indexPairs(:,1),:);
matchedPoints2 = validBlobs2(indexPairs(:,2),:);

% figure;
% showMatchedFeatures(I1, I2, matchedPoints1, matchedPoints2);
% legend('Putatively matched points in I1', 'Putatively matched points in I2');

% % remove outlier
% [fMatrix, epipolarInliers, status] = estimateFundamentalMatrix(...
%   matchedPoints1, matchedPoints2, 'Method', 'RANSAC', ...
%   'NumTrials', 10000, 'DistanceThreshold', 0.1, 'Confidence', 99.99);

[fMatrix, epipolarInliers, status] = estimateFundamentalMatrix(...
  matchedPoints1, matchedPoints2);

if status ~= 0 || isEpipoleInImage(fMatrix, size(I1)) ...
  || isEpipoleInImage(fMatrix', size(I2))
  error(['Either not enough matching points were found or '...
         'the epipoles are inside the images. You may need to '...
         'inspect and improve the quality of detected features ',...
         'and/or improve the quality of your images.']);
end

inlierPoints1 = matchedPoints1(epipolarInliers, :);
inlierPoints2 = matchedPoints2(epipolarInliers, :);

% figure;
% showMatchedFeatures(I1, I2, inlierPoints1, inlierPoints2);
% legend('Inlier points in I1', 'Inlier points in I2');

[t1, t2] = estimateUncalibratedRectification(fMatrix, ...
  inlierPoints1.Location, inlierPoints2.Location, size(I2));
tform1 = projective2d(t1);
tform2 = projective2d(t2);

[I1Rect, I2Rect] = rectifyStereoImages(I1, I2, tform1, tform2);
figure;
imshow(stereoAnaglyph(I1Rect, I2Rect));
title('Rectified Stereo Images (Red - Left Image, Cyan - Right Image)');

% cvexRectifyImages(image_path_1, image_path_2);

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







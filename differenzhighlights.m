clear;
addpath('dataset/Columbia Glacier')
filePattern = fullfile('dataset/Columbia Glacier', '*.jpg');
imagefiles = dir(filePattern);
for i=1:length(imagefiles)
    currentfilename = imagefiles(i).name;
    image{i}= imread(currentfilename);
end
%%
%%grayscal of two images, problem bei e.g 6&7
imgA=image{1};
grayA=rgb2gray(imgA);
imgB=image{2};
grayB=rgb2gray(imgB);
%%SURF
pointsA=detectSURFFeatures(grayA);
[featuresA,pointsA]=extractFeatures(grayA,pointsA);
pointsB=detectSURFFeatures(grayB);
[featuresB,pointsB]=extractFeatures(grayB,pointsB);
%%matchfeatures
indexPairs=matchFeatures(featuresA,featuresB,'Method','Approximate','Unique',true);
matchedPointsA=pointsA(indexPairs(:,1),:);
matchedPointsB=pointsB(indexPairs(:,2),:);
%figure; showMatchedFeatures(imgA,imgB,matchedPointsA,matchedPointsB);
%%rotate the image A to the same position as B
[tform,inlierIdx] = estimateGeometricTransform2D(matchedPointsA,matchedPointsB,'projective');
inlierPtsB = matchedPointsB(inlierIdx,:);
inlierPtsA = matchedPointsA(inlierIdx,:);
outputView = imref2d(size(grayB));
imgAafter=imwarp(imgA,tform,'OutputView',outputView);
%figure;imshow(imgAafter)
%%show the difference between the images, rosa-image B, green-melting glaciers, white-the same part
%RA = imref2d(size(imgAafter),0.2,0.2);
%RB = imref2d(size(imgB),0.2,0.2);
figure;imshowpair(imgAafter,imgB)
figure;imshow(imgA)
figure;imshow(imgB)
%figure;imshowpair(imgAafter,RA,imgB,RB,'Scaling','independent','Parent',axes);


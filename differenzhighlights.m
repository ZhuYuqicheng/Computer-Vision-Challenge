clear;
% load('colormap.mat')
% load('colormaplow.mat')
% load('colormapverylow.mat')
addpath('dataset/Wiesn')
filePattern = fullfile('dataset/Wiesn', '*.jpg');%%Brazilian Rainforest, Columbia Glacier, Dubai, Kuwait，Wiesn
imagefiles = dir(filePattern);

w=fir1(40,0.5);
kernel = w'*w;

%% select images
a=8;
b=6;

%% load data 
for i=1:length(imagefiles)
    currentfilename = imagefiles(i).name;
    img_ori{i}=imread(currentfilename);
end

figure;montage({img_ori{a},img_ori{b}})
%% Preprocessing
for i=1:length(img_ori)
    %%Enhance contrast using histogram equalization
    image{i}= histeq(img_ori{i});
    %%Adjust histogram of 2-D image to match histogram of reference image
    image{i}= imhistmatch(image{i},image{1});
    %%prefilter
    image{i} = prefilterlowpass2d(double(image{i}), kernel);
    image{i} = uint8(image{i});
    %%cut google
    image{i} = image{i}(1:end-50,:,:);
end

%% Registration
%%problem:6&8
imgA=image{a};
imgB=image{b};
figure;montage({imgA,imgB})
%figure;imshow(image{1})
% 
% grayA=rgb2gray(imgA);
% grayA=grayA(1:end-50,:,:);
% grayB=rgb2gray(imgB);
% figure;montage({grayA,grayB})

grayA=rgb2gray(imgA);
grayB=rgb2gray(imgB);
grayB=imhistmatch(grayB,grayA);
figure;montage({grayA,grayB})

%%SURF
inlierIdx=[];
n=0;
%MetricThreshold=3000;
%MetricThreshold=MetricThreshold-500;
pointsA=detectSURFFeatures(grayA,'MetricThreshold',500);
[featuresA,pointsA]=extractFeatures(grayA,pointsA);
pointsB=detectSURFFeatures(grayB,'MetricThreshold',500);
[featuresB,pointsB]=extractFeatures(grayB,pointsB);
%%matchfeatures
while length(find(inlierIdx))<4
    indexPairs = matchFeatures(featuresA,featuresB,'Method','Approximate','Unique',true);
    matchedPointsA=pointsA(indexPairs(:,1),:);
    matchedPointsB=pointsB(indexPairs(:,2),:);
    
    %%rotate the image A to the same position as B
    
    [tform,inlierIdx] = estimateGeometricTransform2D(matchedPointsA,matchedPointsB,'similar','Confidence',90);
    %[F,inlierIdx] = estimateFundamentalMatrix(matchedPointsA,matchedPointsB,'Method','RANSAC',...
    %'NumTrials',2000,'DistanceThreshold',3);
    % if MetricThreshold==0
    %     MetricThreshold=2000;
    % end
    n=n+1;
    disp(n)
end

inlierPtsB = matchedPointsB(inlierIdx,:);
inlierPtsA = matchedPointsA(inlierIdx,:);
figure;showMatchedFeatures(imgA,imgB,inlierPtsA,inlierPtsB,'montage')

outputView = imref2d(size(grayB));
imgAafter=imwarp(imgA,tform,'OutputView',outputView);
figure;imshowpair(imgAafter,imgB)

% figure;imshow(pca_kmeans(imgAafter,imgB,10))
    


%%show the difference between the images, rosa-image B, green-melting glaciers, white-the same part

% diff=abs(imgAafter-imgB);
% grayDiff=rgb2gray(diff);
% X = grayslice(grayDiff,255);
% m = double(max(X(:)));
% if mean(diff(:))>20
%     imdiff=ind2rgb(X,Colormap);
%     disp('große Änderung')
% elseif mean(diff(:))<=20 && mean(diff(:))>10
%     imdiff=ind2rgb(X,Colormaplow);
%     disp('kleine Änderung')
% elseif mean(diff(:))<=10
%     imdiff=ind2rgb(X,Colormapverylow);
%     disp('sehr kleine Änderung')
% end
%
% im=uint8(imdiff*255)+imgB;
% figure;imshow(im);

%% Prefilter FIR
function pic_pre = prefilterlowpass2d(picture, kernel)
kernel = kernel / sum(kernel(:));% normalize
pic_pre = convn(picture, kernel, 'same'); %%central part of the convolution, which is the same size as the image
end

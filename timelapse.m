clear;
addpath('dataset/Columbia Glacier')
filePattern = fullfile('dataset/Columbia Glacier', '*.jpg');
imagefiles = dir(filePattern);
for i=1:length(imagefiles)
    currentfilename = imagefiles(i).name;
    image{i}= imread(currentfilename);
end
%%
%%grayscal of two images, problem bei 9
imgA=image{1};
grayA=rgb2gray(imgA);
%%SURF
pointsA=detectSURFFeatures(grayA);
[featuresA,pointsA]=extractFeatures(grayA,pointsA);
for i=2:length(image)
    imgB=image{i};
    grayB=rgb2gray(imgB);
    pointsB=detectSURFFeatures(grayB);
    [featuresB,pointsB]=extractFeatures(grayB,pointsB);
    %%matchfeatures
    indexPairs=matchFeatures(featuresA,featuresB,'Method','Approximate','Unique',true);
    matchedPointsA=pointsA(indexPairs(:,1),:);
    matchedPointsB=pointsB(indexPairs(:,2),:);
    %figure; showMatchedFeatures(imgA,imgB,matchedPointsA,matchedPointsB);
    %%rotate the image A to the same position as B
    [tform,inlierIdx] = estimateGeometricTransform2D(matchedPointsB,matchedPointsA,'affine');
    outputView = imref2d(size(grayA));
    imgBafter{i}=imwarp(imgB,tform,'OutputView',outputView);
end

im{1}=imgA;
figure,imshow(imgA);

%for i=2:11
    %imshowpair(imgA,imgBafter{i},'blend');
%end
imshowpair(imgA,imgBafter{6},'blend');

%% put one on the other
for i=2:11
    imga=imgA;
    pos=find(imgBafter{i}~=0);
    imga(pos)=0;
    im{i}=(imgBafter{i}+imga);
end
%%
 %video
 % create the video writer with 1 fps
 writerObj = VideoWriter('timalapse.avi');
 writerObj.FrameRate = 1;
 % set the seconds per image
 secsPerImage = 2*ones(1,11);
 % open the video writer
 open(writerObj);
 % write the frames to the video
 for u=1:length(im)
     % convert the image to a frame
     frame = im2frame(im{u});
     for v=1:secsPerImage(u) 
         writeVideo(writerObj, frame);
     end
 end
 % close the writer object
 close(writerObj);

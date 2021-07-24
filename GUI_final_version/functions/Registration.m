function Registration(imgA, imgB, result_path)
    % match the histogram of grayscale image
    grayA=rgb2gray(imgA);
    grayB=rgb2gray(imgB);
    grayB=imhistmatch(grayB,grayA);

    % SURF
    pointsA=detectSURFFeatures(grayA,'MetricThreshold',500,'NumOctaves',4,'NumScaleLevels',6);
    [featuresA,pointsA]=extractFeatures(grayA,pointsA);
    pointsB=detectSURFFeatures(grayB,'MetricThreshold',500,'NumOctaves',4,'NumScaleLevels',6);
    [featuresB,pointsB]=extractFeatures(grayB,pointsB);
    
    % matchfeatures
    indexPairs=matchFeatures(featuresA,featuresB,'Method','Exhaustive','Unique',true,'MatchThreshold',100);
    matchedPointsA=pointsA(indexPairs(:,1),:);
    matchedPointsB=pointsB(indexPairs(:,2),:);
    n=0;
    inlierIdx=[];
    while length(find(inlierIdx))<4 && n<50
        % rotate the image A to the same position as B
        % Dubai, Kuwait
        % [tform,inlierIdx] = estimateGeometricTransform2D(matchedPointsA,matchedPointsB,'similar','Confidence',95);
        [tform,inlierIdx] = estimateGeometricTransform2D(matchedPointsA,matchedPointsB,...
            'similar','Confidence',90,'MaxNumTrials',2000,'MaxDistance',10);
        n=n+1;
    end

    outputView = imref2d(size(grayB));
    imgAafter = imwarp(imgA,tform,'OutputView',outputView);

    % make imgAafter complete using imgB
    imgAafter(imgAafter==0)=imgB(imgAafter==0);
    % save images
    mkdir(result_path)
    imwrite(imgB,fullfile(result_path, "pic_1.png"))
    imwrite(imgAafter,fullfile(result_path, "pic_2.png"))
    
end
function image = preprocessing(img_ori)
    image = cell(size(img_ori));
    for i=1:length(img_ori)
        % Enhance contrast using histogram equalization
        image{i}= histeq(img_ori{i});
        % Adjust histogram of 2-D image to match histogram of reference image
        image{i}= imhistmatch(image{i},img_ori{1});
        % prefilter
        image{i} = prefilterlowpass2d(double(image{i}));
        image{i} = uint8(image{i});
        % remove logo
        image{i} = image{i}(1:end-50,:,:);
    end

end
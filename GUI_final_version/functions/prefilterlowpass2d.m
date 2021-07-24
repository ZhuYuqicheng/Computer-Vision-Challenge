function pic_pre = prefilterlowpass2d(picture)
    w=fir1(40,0.5);
    kernel = w'*w;
    kernel = kernel / sum(kernel(:));% normalize
    pic_pre = convn(picture, kernel, 'same'); %%central part of the convolution, which is the same size as the image
end
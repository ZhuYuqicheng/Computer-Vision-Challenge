function DifferenceHighlight(app)
    % get the required image paths
    result_dir = fullfile(app.result_path, app.select_data_name);
    result_file = app.Year1DropDown.Value+"_"+app.Year2DropDown.Value;
    if exist(fullfile(result_dir, result_file), 'dir')
        img_path = fullfile(result_dir, result_file);
    else
        result_file = app.Year2DropDown.Value+"_"+app.Year1DropDown.Value;
        img_path = fullfile(result_dir, result_file);
    end
    imgA = imread(fullfile(img_path, "pic_2.png"));
    imgB = imread(fullfile(img_path, "pic_1.png"));

    % difference highlight
    [Ic, Id] = DensityHighlight(app, imgA, imgB);
    if app.heatmapmodeSwitch.Value == "On"
        HeatmapPlot(app, imgA, imgB, Ic, Id)
    end
end

%% function area
function [Ic,Id]=difference(I1,I2)
    %%calculate the difference between two images
    %input: I1,I2 are the pictures that we want to compare
    %output:
    %Ic contains the pixels which Ia has but Ib does not have
    %Id contains the pixels which Ib has but Ia does not have
    Ia=double(I1);
    Ib=double(I2);
    A=size(I1);
    Ic=ones(A(1),A(2));
    Id=ones(A(1),A(2));
    for i=1:A(1)
        for j=1:A(2)
            if Ia(i,j)-Ib(i,j)>55
                Ic(i,j)=255;
                Id(i,j)=0;
            elseif Ib(i,j)-Ia(i,j)>55
                Ic(i,j)=0;
                Id(i,j)=255;
            else
                Ic(i,j)=0;
                Id(i,j)=0;
            end
        end
    end
end

function [Ic, Id] = DensityHighlight(app, imgA, imgB)
    imgA=medfilt2(rgb2gray(imgA),[3,3]);%%2-D median filtering
    imgB_ori=imgB;
    imgB=medfilt2(rgb2gray(imgB),[3,3]);

    imgB(imgA==0)=0;
    [Ic,Id]=difference(imgA,imgB);%%find the difference between the two images
    Ic=uint8(Ic);
    Id=uint8(Id);
    Ic = bwareaopen(Ic,round(app.ThresholdKnob.Value));%%Remove small objects from binary image
    Id = bwareaopen(Id,round(app.ThresholdKnob.Value));
    
    if app.partialSwitch.Value == "On" && app.modeSwitch.Value == "decrease"
        C = imoverlay(imgB_ori,Id,'red');%tear down
    elseif app.partialSwitch.Value == "On" && app.modeSwitch.Value == "increase"
        C = imoverlay(imgB_ori,Ic,'yellow');%tear down
    elseif app.partialSwitch.Value == "Off"
        B = imoverlay(imgB_ori,Ic,'yellow');%tear down
        C = imoverlay(B,Id,'red');%new
    end

    imshow(C,'Parent',app.UIAxes)
end

function HeatmapPlot(app, imgA, imgB, Ic, Id)
    threshold = 20;

    imgA = rgb2gray(imgA);
    imgB = rgb2gray(imgB);
    
    diff_image = abs(imgA-imgB)-threshold;
    diff_image(Ic) = diff_image(Ic) + 20;
    diff_image(Id) = diff_image(Id) + 20;
    diff_image = downsample(downsample(diff_image, 2)', 2)';
    mesh(app.UIAxes, diff_image)
    colormap(app.UIAxes, turbo)
    view(app.UIAxes, 2)
end
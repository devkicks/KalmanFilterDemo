% script basic Kalman Filtering
close all
clear all
clc

SE = strel('diamond',3) ;

position = zeros(2, 45)

% segment ball region
for in = 1:45
    buffer = sprintf('ballSequence/Color_%d.png', in);
inImage = imread(buffer); inImage = imgaussfilt(inImage);
hImage = rgb2hsv(inImage);
outImage = zeros(size(inImage, 1), size(inImage, 2));
for i = 1:size(hImage, 2)
    for j = 1:size(hImage, 1)
        if(hImage(j, i, 1) > 0.4 && hImage(j, i, 1) < 0.455)
            outImage(j, i) = 255;
        end
    end
end

outImage = imopen(outImage, SE);
imshow(outImage);drawnow;

buffer = sprintf('ballSequence/Seg_%d.png', in);
imwrite(outImage, buffer);

curLoc = regionprops(logical(outImage), 'Centroid');
if(~isempty({curLoc.Centroid}))
    position(:, in) = curLoc.Centroid;
end

end

save('ballSequence/position.mat', 'position');
function [ outImage ] = displayPosition( inImage, inPos, colVec, sizeMarker )
%dispPosition Function Displays position on image
if(~exist('colVec', 'var'))
    % provide red color
    colVec = [255; 0 ; 0];
end
if(~exist('sizeMarker', 'var'))
    sizeMarker = 8;
end

% display a marker using for loop
outImage = inImage;

for i = -sizeMarker/2:sizeMarker/2
    for j = -sizeMarker/2:sizeMarker/2
        if( inPos(2) + i > 1 && inPos(1) + j > 1 )
            outImage(floor(j + inPos(2)), floor(i + inPos(1)), :) = colVec;
        end
    end
end



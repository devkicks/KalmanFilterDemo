videoReader = vision.VideoFileReader('singleball.avi');

foregroundDetector = vision.ForegroundDetector('NumTrainingFrames',10, ...
    'InitialVariance',0.05);
blobAnalyzer = vision.BlobAnalysis('AreaOutputPort',false,'MinimumBlobArea',70);
kalmanFilter = [];
isTrackInitialized = false;

ballLocation = [];
i = 1;
while ~isDone(videoReader)
    colorImage = step(videoReader);
    foregroundMask = step(foregroundDetector, rgb2gray(colorImage));
    detectedLocation = step(blobAnalyzer,foregroundMask);
    isObjectDetected = size(detectedLocation, 1) > 0;
    
   buffer = sprintf('ballSequence\\segImage_%d.png', i);
   imwrite(foregroundMask, buffer);
        % Run Kalman filter
        if isObjectDetected
            % Object detected -- predict and correct
%             predict(kalmanFilter);
%             trackedLocation = correct(kalmanFilter, detectedLocation(1,:));
%             label = 'Corrected';
               ballLocation = [ballLocation detectedLocation'];
        else
            % Object not detected -- only predict
%             trackedLocation = predict(kalmanFilter);
%             label = 'Predicted';
            ballLocation = [ballLocation zeros(2,1)];
        end
i = i +1
end
release(videoReader);
save('ballSequence\\ballLocation.mat', 'ballLocation');



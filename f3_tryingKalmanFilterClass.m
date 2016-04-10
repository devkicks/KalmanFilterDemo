% script for Kalman Filtering

close all
clear all
clc

%% loading the libraries
myMatlabLibFolder = 'E:\\MatlabWorks\\MyMatlabLibrary\\'

% load the libraries for Multi-Layered Regression
addpath(genpath([myMatlabLibFolder 'filterLibs\\']));

% load the location file
load('ballSequence/ballLocation.mat');

% run the outer loop for the sequence
KFRunning = false;
% inR = eye(2)/2;

% Kalman Filter Matrices
Kfilt = [];

for i = 1:45
    curPosition = ballLocation(:, i);
    if(sum(curPosition) ~= 0 && ~KFRunning)
        
        inR = eye(length(curPosition))*10;
        
        % Initialise KF State Vector Xk
        KFilt = MKalmanFilter(curPosition, inR, 1);
        % Start KF
        KFRunning = true;
        
        % Advance to next input
        i = i+1;
        curPosition = ballLocation(:, i);
    end
    
    % there could be two possible cases - 1- there is measurement / 2 -
    % there is no measurement
    % for 1 - we predict and correct - for - 2 we only predict and advance
    % State vector
    
    % 1 ---
    if(sum(curPosition) ~= 0 && KFRunning)
        % predict ...
        KFilt.Predict;
        
        % and correct
        KFilt.Update(curPosition);
    end
    
    % 2 ---
    if(sum(curPosition) == 0 && KFRunning)
        % Predict and advance State Vector
        KFilt.Predict;
    end
    
    
    
    
    
    buffer = sprintf('ballSequence/Color_%d.png', i);
    inImage = imread(buffer);
    
    outImage = displayPosition(inImage, curPosition, [255; 0; 0], 8);
    if(KFRunning)
        outImage = displayPosition(outImage, KFilt.measureModel, [0; 255; 0], 6);
    end
    imshow(outImage); drawnow;       
end

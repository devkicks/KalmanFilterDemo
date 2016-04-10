% script for Kalman Filtering

close all
clear all
clc

% load the location file
load('ballSequence/position.mat');

% Kalman Filter Matrices

% State Transition Model
A = [1 1 0 0 0 0; ...
     0 1 1 0 0 0; ...
     0 0 1 0 0 0; ...
     0 0 0 1 1 0; ...
     0 0 0 0 1 1; ...
     0 0 0 0 0 1];

% Measurement Model
H = [1 0 0 0 0 0; ...
     0 0 0 1 0 0];

% run the outer loop for the sequence
KFRunning = false;
Xk = [];
Xk1 = [];
Zk = [];
Pk = eye(6)*100000; % prediction covariance
Pk1 = eye(6)*100000;

Q = eye(6)/2;
R = eye(2)/2;

for i = 1:45
    curPosition = position(:, i);
    if(sum(curPosition) ~= 0 && ~KFRunning)
        % Initialise KF State Vector Xk
        Xk1 = [ curPosition(1); 0; 0; curPosition(2); 0; 0];
        
        % Start KF
        KFRunning = true;
        
        % Advance to next input
        i = i+1;
        curPosition = position(:, i);
    end
    
    % there could be two possible cases - 1- there is measurement / 2 -
    % there is no measurement
    % for 1 - we predict and correct - for - 2 we only predict and advance
    % State vector
    
    % 1 ---
    if(sum(curPosition) ~= 0 && KFRunning)
        % predict ...
        Xk = A*Xk1 + mvnrnd([0; 0; 0; 0; 0; 0], Q)';
        Pk = A*Pk1*A' + Q;
        Zk = H*Xk + mvnrnd([0; 0], R)';
        
        %Get the Kalman Gain
        K = Pk*H'*inv(H*Pk*H' + R);
        
        % and correct
        Xk = Xk + K*(curPosition - Zk);
        Pk = (eye(6) - K*H)*Pk;
    end
    
    % 2 ---
    if(sum(curPosition) == 0 && KFRunning)
        % Predict and advance State Vector
        Xk = A*Xk1  + mvnrnd([0; 0; 0; 0; 0; 0], Q)';
        Pk = A*Pk1*A' + Q;
        Zk = H*Xk + mvnrnd([0; 0], R)';
        
    end
    
    
    
    
    
    buffer = sprintf('ballSequence/Color_%d.png', i);
    inImage = imread(buffer);
    
    outImage = displayPosition(inImage, curPosition, [255; 0; 0], 8);
    if(KFRunning)
        outImage = displayPosition(outImage, Zk, [0; 255; 0], 6);
    end
    imshow(outImage); drawnow;
    Xk
    Zk
    Pk
    curPosition
    % set current state to previous and advance to next iteration
    Xk1 = Xk;
    Pk1 = Pk;
%     pause;
end

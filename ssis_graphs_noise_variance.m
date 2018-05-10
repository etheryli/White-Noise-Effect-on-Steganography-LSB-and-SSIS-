% The approach for this will be to generate Matlab functions for encoding
% and decoding for each method. The efficiency of each method will be
% tested in two ways. First, the encoded images will be corrupted by all
% white gaussian noise of several levels of variances before being passed
% into the decoder and the integrity of the encoded message will be
% recorded.


clear;
close all;
clc;

filename = 'building.tif';
message = 'helloworldilikedigitalimageprocessing';
block_size = 30;
gain = 2;
host_image = imread(filename);
% Test LSB to make sure it works
[encoded_image, noise, message_length] = ssis_encode(host_image, block_size, gain, message);

decoded_message_ = ssis_decode(encoded_image, noise, block_size, message_length);

decoded_message = extractBefore(decoded_message_, message_length/8+1);
disp(message);
disp(decoded_message);

% ascii_message = uint8(message);
% ascii_decoded_message = uint8(decoded_message);
% avg = abs(ascii_decoded_message - ascii_message)./ascii_message;
% meanie = mean(avg(:));


% Loop over a lot of sigma's and measure the corruption responses 
% andappend , then make 2 or 3 graphs: 

% 1. avg % corruption in decoded message vs sigma
% 2. avg % corruption in encoded image with noise vs sigma
% 3. avg % corruption in decoded message vs avg % corruption in noise added
% to encoding
	
range = 100;

vars = logspace(-7,7, range);

% Good range is 0.001 to 10
%for var = 1:10000
avg_percent_noise_encoded = zeros(size(vars));
avg_percent_message_decoded = zeros(size(vars));

for i = 1:range
    [avgm, avgc] = ssis_noise(host_image, message, vars(i));
    avg_percent_message_decoded(i) = 100*avgm;
    avg_percent_noise_encoded(i) = 100*avgc;
    %disp(i);
end

csvwrite("gauss_transm_ssis.csv",[vars;avg_percent_message_decoded;avg_percent_noise_encoded]);

fig1 = figure('Name', 'Gaussian Noise Transmission', 'color', [1 1 1]);
%subplot(1, 3, 1);
semilogx(vars, avg_percent_noise_encoded, 'LineWidth', 2);
title("Decoded Message Corruption vs. Gaussian Noise Variance");
xlabel('Variance Gaussian Noise in Encoded Transmission');
ylabel('% Change in Decoded Message');
xlim([vars(1) vars(range)]);
ylim([0 100]);
%subplot(1, 3, 2);


fig2 = figure('Name', 'Gaussian Noise Transmission', 'color', [1 1 1]);
semilogx(vars, avg_percent_message_decoded, 'LineWidth', 2);
title("Encoded Image Corruption vs. Gaussian Noise Variance");
xlabel('Variance Gaussian Noise in Encoded Transmission');
ylabel('% Change in Encoded Image Pixels');
xlim([vars(1) vars(range)]);
ylim([0 100]);


fig3 = figure('Name', 'Gaussian Noise Transmission', 'color', [1 1 1]);
%subplot(1, 3, 3);
plot(avg_percent_noise_encoded, avg_percent_message_decoded, 'LineWidth', 2);
title("Decoded Message Corruption vs. Encoded Image Corruption");
xlabel('% Change in Encoded Image Pixels');
ylabel('% Change in Decoded Message');
xlim([0 max(avg_percent_noise_encoded(:))]);
ylim([0 max(avg_percent_message_decoded(:))]);
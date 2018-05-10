% Example for SSIS and LSB Methods
clear;
close all;
clc;

filename = 'building.tif';
message = 'helloworldilikedigitalimageprocessing';
block_size = 30;
gain = 2;

host_image = imread(filename);

[lsb_encoded_image, lsb_message_length] = lsb_encode(host_image, message);
lsb_decoded_message = lsb_decode(lsb_encoded_image, lsb_message_length);
lsb_encoded_image = imnoise(lsb_encoded_image, 'gaussian', 0, 0.1);

[encoded_image, noise, message_length] = ssis_encode(host_image, block_size, gain, message);
encoded_image = imnoise(encoded_image, 'gaussian', 0, 0.1);

decoded_message_ = ssis_decode(encoded_image, noise, block_size, message_length);
decoded_message = extractBefore(decoded_message_, message_length/8+1);

fig1 = figure('Name', 'Encoded Images and Decoded Messages', 'color', [1 1 1]);
% 
% subplot(3, 1, 1);
% imshow(host_image);
% title("Original Image");
% xlabel({'Original Message:';'\it helloworldilikedigitalimageprocessing'},'Interpreter','tex'); 

subplot(1, 2, 1);
imshow(lsb_encoded_image);
title("LSB Encoded Image");
xlabel({'Decoded Message:';['\it', lsb_decoded_message, '']},'Interpreter','tex'); 

subplot(1, 2, 2);
imshow(encoded_image);
title("SSIS Encoded Image");
xlabel({'Decoded Message:';['\it', decoded_message, '']},'Interpreter','tex'); 

%xlabel({"Original Message:"; message});

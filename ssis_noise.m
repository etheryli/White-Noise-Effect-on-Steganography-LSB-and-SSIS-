function [avg_msg_corrupt, avg_encode_corrupt] = ssis_noise(input, message, var)
    % Encoding input

    host_image = input;

    gain = 2;
    block_size = 30;
    
    [encoded_image, noise, message_length] = ssis_encode(host_image, block_size, gain, message);

    % ADD EXTRA NOISE HERE
    noise_encoded = imnoise(encoded_image, 'gaussian', 0, var);

    %%%%%% ENCODING CORRUPTION DATA %%%%%%%%
    encode_corrupt_matrix = abs(noise_encoded - encoded_image)./encoded_image;
    avg_encode_corrupt = mean(encode_corrupt_matrix(:));

    decoded_message_ = ssis_decode(noise_encoded, noise, block_size, message_length);
    decoded_message = extractBefore(decoded_message_, message_length/8+1);

    %%%%%%% MESSAGE CORRUPTION DATA %%%%%%%
    % Convert both messages message ascii numbers here to quantize:

    ascii_message = uint8(message);
    ascii_decoded_message = uint8(decoded_message);

    message_corruption_percentages = abs(ascii_decoded_message - ascii_message)./ ascii_message;
    avg_msg_corrupt = mean(message_corruption_percentages(:));

end

    %s1 = 'ssis_encoded_sigma_';
    %s2 = num2str(sigma);
    %extension = '.tif';

    %filename = strcat(s1, s2);
    %filename = strcat(filename, extension);

    %imwrite(noise_encoded ,filename);
    %s1 = 'ssis_decoded_sigma_';
    %s2 = num2str(sigma);
    %extension = '.tif';

    %filename = strcat(s1, s2);
    %filename = strcat(filename, extension);

    %imwrite(decoded_image ,filename);
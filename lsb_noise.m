function [avg_msg_corrupt, avg_encode_corrupt] = lsb_noise(input, message, var)

    host_image = input;

    [encoded_image, message_length] = lsb_encode(host_image, message);

    noise_encoded = imnoise(encoded_image, 'gaussian', 0, var);

    %%%%%% ENCODING CORRUPTION DATA %%%%%%%%
    encode_corrupt_matrix = abs(noise_encoded - encoded_image)./encoded_image;
    avg_encode_corrupt = mean(encode_corrupt_matrix(:));

    decoded_message = lsb_decode(noise_encoded, message_length);

    %%%%%%% MESSAGE CORRUPTION DATA %%%%%%%
    % Convert both messages message ascii numbers here to quantize:

    ascii_message = uint8(message);
    ascii_decoded_message = uint8(decoded_message);
    %disp(length(ascii_message));
    %disp(length(ascii_decoded_message));

    
    message_corruption_percentages = abs(ascii_decoded_message - ascii_message)./ ascii_message;
    avg_msg_corrupt = mean(message_corruption_percentages(:));

end

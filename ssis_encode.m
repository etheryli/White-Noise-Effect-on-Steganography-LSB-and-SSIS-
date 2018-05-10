function [encoded_image, noise, message_length] = ssis_encode(host_image, block_size, gain, input_message)
    
    if length(size(host_image)) > 2
        host_image = rgb2ycbcr(host_image); %if host_image is color image, not in a greyscale
        host_image_ycbcr = double(host_image(:,:,1));
    else
        host_image_ycbcr = double(host_image);
    end

    [M,N] = size(host_image_ycbcr);
    if M ~= N
        error('Dimensions do not match');
    end

    % Message modulation and interleaving with the respect to 
    % algorithm spatial domain

    % Normalized sizes for block size
    K = block_size;
    Mb = (M/K); 
    Nb = (N/K);

    %%%%
    message = input_message;

    message = strtrim(message);
    m = length(message) * 8;

    message_length = m;

    AsciiCode = uint8(message);

    binaryString = transpose(dec2bin(AsciiCode,8));
    binaryString = binaryString(:);
    z = length(binaryString);
    if z > Mb*Nb
        error('Message is too long')
    end

    b = zeros(z,1);

    for k = 1:z
    if(binaryString(k) == '1')
        b(k) = 1;
    else
        b(k) = 0;
    end
    end
    [r, c] = size(b);
    pad_length = (Mb*Nb-r*c);
    message_array = transpose(padarray(b, pad_length, 'post'));
    ma_length = length(message_array);

    for f=1:ma_length
        if message_array(f)==0
            message_array(f) = -1;
        end
    end

    %%%

    Watermark = zeros(size(host_image_ycbcr));
    q=1;
    for i = 1:Mb
        for j = 1:Nb
            Watermark((i-1)*K+1:i*K,(j-1)*K+1:j*K) = message_array(q);
            q = q+1;
        end
    end      

    % Watermark is a message modulated with noise
    Noise = round(randn(size(host_image_ycbcr))); 
    noise = Noise;
    
    % Take into consideration that nformation about noise
    % Noise is necessary for watermark decoding

    
    WatermarkNoise = gain*Noise.*Watermark;

    % adding watermark to host image
    host_image_ycbcr=uint8(host_image_ycbcr+WatermarkNoise);

    if length(size(host_image)) > 2
        C = uint8(zeros(M,N,3));
        C(:,:,1) = host_image_ycbcr;
        C(:,:,2) = host_image(:,:,2);
        C(:,:,3) = host_image(:,:,3);
        C = ycbcr2rgb(C);
        A = ycbcr2rgb(A);
    else
        C = host_image_ycbcr;
    end

    encoded_image = C;
end

%% 
% Graphs of A and host_image_ycbcr image comparison---------------------------------------
%figure(1),subplot(1,2,1),...
%       imshow(Watermark,[]);    title('Additional Information')
%       subplot(1,2,2),imshow(WatermarkNoise,[]); 
%                                title('Watermark (after noise modulation)')
%figure(2),subplot(1,2,1),imshow((A),[]);           
%                                title('Host Image')
%       subplot(1,2,2),imshow(C,[]);              
%                                title('Watermarked image')
 
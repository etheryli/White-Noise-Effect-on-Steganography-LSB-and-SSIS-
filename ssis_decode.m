function decoded_message = ssis_decode(encoded_image, noise, block_size, message_length);
    B = double(encoded_image);
    K = block_size;
    [M,N] = size(B);
    Mb = (M/K); 
    Nb = (N/K);
    
    K = block_size;
    % High Pass filter
    L = 10;
    L2 = 2*L+1;
    w = hamming(L2);
    w = w*w';
    f0 = 0.5; 
    wc = pi*f0; 
    [m,n] = meshgrid(-L:L,-L:L);
    lp = wc*besselj(1,wc*sqrt(m.^2+n.^2))./(2*pi*sqrt(m.^2+n.^2));
    lp(L+1,L+1) = wc^2/(4*pi);
    hp = -lp; hp(L+1,L+1)=1-lp(L+1,L+1);
    h = hp.*w;
    B = imfilter(B,h,'same');


    %% 
    % Decision of each bit value of additional information (blank watermark)---
    Noise_Demod = B.*noise;
    Sign_Detection = zeros(size(B));

    for i = 1:Mb
        for j = 1:Nb
        Sign_Detection((i-1)*K+1:i*K, (j-1)*K+1:j*K) = ...
            sign(sum(sum(Noise_Demod((i-1)*K+1:i*K, (j-1)*K+1:j*K))));
        end
    end
    
    a =1;
    
    recovered_bits = zeros(1, Mb*Nb);

    for i = 1:Mb
        for j = 1:Nb
            recovered_bits(a) = round(sum(sum(Sign_Detection((i-1)*K+1:i*K, (j-1)*K+1:j*K)))/(K*K));
            if recovered_bits(a)== -1
                recovered_bits(a) = 0;
            end
            a = a+1;
        end
    end
    
    recovered_bits = transpose(recovered_bits);
    binValues = [ 128 64 32 16 8 4 2 1 ];
    binMatrix = reshape(recovered_bits,8,[]);
    textString = char(binValues*binMatrix);
    decoded_message = textString; % extractBetween(textString,1, message_length);
    
    %disp(textString);
end
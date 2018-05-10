function decoded_message = lsb_decode(encoded_image, message_length)

    height = size(encoded_image,1);
    width = size(encoded_image,2);
    
    %m =  double( encoded_image(1:1:1) ) * 8 + 8;
    m = message_length;
    k = 1;
    for i = 1 : height
        for j = 1 : width
            if (k <= m)
                b(k) = mod(double(encoded_image(i,j)),2);
                k = k + 1;
            end
        end
    end
    
    binaryVector = b;
    binValues = [ 128 64 32 16 8 4 2 1 ];
    binaryVector = binaryVector(:);
    
    if mod(length(binaryVector),8) ~= 0
        error('Length of binary vector must be a multiple of 8.');
    end
    
    binMatrix = reshape(binaryVector,8,[]);
    textString = char(binValues*binMatrix);
    
    decoded_message = textString;
    % disp(textString);
end
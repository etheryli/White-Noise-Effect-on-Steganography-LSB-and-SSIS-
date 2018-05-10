function [encoded_image, message_length] = lsb_encode(host_image, input_message)

    c = host_image;
    c(1:1:1)= length(input_message) ; %to count massage Char to easly retrive all the massage 
    c=imresize(c,[size(c,1) size(c,2)],'nearest');
    message = strtrim(input_message);
    m = length(message) * 8;

    message_length = m;

    AsciiCode = uint8(message);
    binaryString = transpose(dec2bin(AsciiCode,8));
    binaryString = binaryString(:);
    N = length(binaryString);
    b = zeros(N,1);
    for k = 1:N
      if(binaryString(k) == '1')
          b(k) = 1;
      else
          b(k) = 0;
      end
    end
    s = c;
      height = size(c,1);
      width = size(c,2);
    k = 1;
    for i = 1 : height
      for j = 1 : width
          LSB = mod(double(c(i,j)), 2);
          if (k>m || LSB == b(k))
              s(i,j) = c(i,j);
          elseif(LSB == 1)
              s(i,j) = (c(i,j) - 1);
          elseif(LSB == 0)
              s(i,j) = (c(i,j) + 1);
          end
      k = k + 1;
      end
    end
    encoded_image = s;
    %imgWTxt = 'hidden.tif';
    %imwrite(s,imgWTxt);

end
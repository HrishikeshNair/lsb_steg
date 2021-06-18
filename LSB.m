tic;
input0 = imread('cover_image0.bmp'); %input0 is used to calculate psnr later
input = imread('cover_image0.bmp');
input = imresize(input, [128 128]);
%input=rgb2gray(input);
no_of_ele = 128*128*3; 
message='ID: PEXU9882314568 Allergies: Soy Criminal Record: None'; %message to be embedded
len = length(message) * 8;
ascii = uint8(message);
binmsg = transpose(dec2bin(ascii, 8)); 
binmsg = binmsg(:);
N = length(binmsg);
binnum=str2num(binmsg);%converting the text to bits
input = reshape(input, [1, no_of_ele]);
output = input; %initializing output
counter = 1;
t = 1;
wt = 80;
for i = 1 : no_of_ele
        if(t <= len*wt) %the wt value is used to calculate the psnr at different embedding rates            
            LSB = mod(double(input(i)), 2); 
            temp = double(xor(LSB, binnum(counter)));  
            output(i) = bitxor(input(i), temp); 
            counter = counter+1;
           if(counter==441) 
              counter=1;
           end
           t = t+1;
        end       
end

%%Extracting
txt = zeros(1,441);
fid = fopen('new_lsb.txt', 'wt');
for i=1:441
    txt(i) = mod(double(output(i)), 2);   
    fprintf(fid, '%d', txt(i));
end

out = reshape(output, [128, 128,3]);
p = psnr(out, input0);
disp("psnr");
disp(p);
imwrite(out, 'E:\matlabtobe\PROGRAMS\output_baboon_lsb.bmp');
toc;

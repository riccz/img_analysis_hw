%LAB7 : DCT-based image coding

% Student Name: Riccardo Zanol

% Write here any comment for the instructor if needed: 
% ....
% ....
% ....

% filename = image file 
% Qscale = scale factor for the quantization table
% cr  = compression ratio
% mse = mean squared error between the original and coded image
function [cr, mse] = imgcode(filename, Qscale)


% Develop a simple grayscale image coding and decoding procedure exploiting DCT,
% quantization and Huffman coding (a simplified version of the JPEG standard)

% 1) CODING PROCEDURE

% Read the image (if it is a color image convert to grayscale)

I = imread(filename);  %input file
I = double(I);
%I = rgb2gray(Ic);   %Convert to grayscale if needed
[h, w] = size(I);
blocks_h = h/8; % number of 8x8 blocks 
blocks_w = w/8; % number of 8x8 blocks 

IS = I-128; % center around 0

%Place in the TI array the output of the DCT (same structure of the image
%with the corresponding coefficient in each 8x8 block)
TI = zeros(h,w);

%DCT (input IS -> output TI)
% You can use the dct2 function of Matlab

for i=1:blocks_h
   for j=1:blocks_w
       block_coords_i = (i-1)*8 +1: i*8;
       block_coords_j = (j-1)*8 +1: j*8;
       TI(block_coords_i, block_coords_j) = dct2(IS(block_coords_i, block_coords_j));
    end
end

figure('name','DCT');
imshow(TI,[0 max(TI(:))]);


%Quantize (input TI -> otuput QI)

% JPEG Quantization table
Q = [   16 11 10 16 24 40 51 61;
        12 12 14 19 26 58 60 55;
        14 13 16 24 40 57 69 56;
        14 17 22 29 51 87 80 62;
        18 22 37 56 68 109 103 77;
        24 36 55 64 81 104 113 92;
        49 64 78 87 103 121 120 101;
        72 92 95 98 112 100 103 99];

%Set the amount of compression
Q = Q * Qscale;    
 
%Place the quantized coefficients into the QI structure
QI = zeros(h,w);

% Write here the code for the quantization 
% to quantize divide each coefficient for the corresponding Q value and
% round to the nearest integer

for i=1:blocks_h
   for j=1:blocks_w
       block_coords_i = (i-1)*8 +1: i*8;
       block_coords_j = (j-1)*8 +1: j*8;
       TI_block = TI(block_coords_i, block_coords_j);
       QI(block_coords_i, block_coords_j) = round(TI_block ./ Q);
    end
end
   
% Huffman encoding (input QI -> output comp)
range = max(abs(QI(:)));
counts = histc(QI(:),-range:range);   % Count the frequencies of the symbols
P = counts / (w*h);    %probabilities
[dict,avglen] = huffmandict(-range:range,P); % Create the Huffman tree
comp = huffmanenco(QI(:),dict);   %Huffman encoding

% Size of the coded data (in bits)
bits = length(comp);
cr = h*w*8/bits;
fprintf('compressed size %d bits \n', bits);
fprintf('compression ratio %d  \n', cr);

% 2) Decode

QID = huffmandeco(comp,dict); % Decode the Huffman code.
QID = reshape(QID,h,w);

% Place here the coefficients after inverse quantization (input QID -> output IQ)
IQ = zeros(h,w);

% Write here the code for the quantization 
% you need to multiply each decoded coefficient (QID) for the corresponding Q value and
% place the result in IQ

for i=1:blocks_h
   for j=1:blocks_w
       block_coords_i = (i-1)*8 +1: i*8;
       block_coords_j = (j-1)*8 +1: j*8;
       QID_block = QID(block_coords_i, block_coords_j);
       IQ(block_coords_i, block_coords_j) = round(QID_block .* Q);
    end
end

% Place here the output of the inverse transform (input IQ -> output OUT) 
OUT = zeros(h,w);

%Inverse transform (IDCT) - use idct2

for i=1:blocks_h
   for j=1:blocks_w
       block_coords_i = (i-1)*8 +1: i*8;
       block_coords_j = (j-1)*8 +1: j*8;
       IQ_block = IQ(block_coords_i, block_coords_j);
       OUT(block_coords_i, block_coords_j) = idct2(IQ_block);
    end
end

OUT = OUT+128; % invert the shift

figure('name','output image');
imshow(OUT,[0 255]);

figure('name','mean square error');
E = (I-OUT).^2;
imshow(E,[0 255]);

%mean squared error 
mse = mean(E(:));
fprintf('Mean Squared Error %d \n', mse);


%Compile this table 
% Qscale   compr.ratio    MSE
%  0.5                 
%  1                   
%  2                   

function ghosty = improc(currentfilename, k, m, c)

I = imread(currentfilename);

% Delete white background using bwconvhull (the complex hull of the image)
BW = imbinarize(rgb2gray(I));
BWConv = bwconvhull(~BW);
Bw = BW & BWConv;
Bw = uint8(Bw);

Input_Im = Bw.*I;

% Converting the background to NotaNumber

BWConv = double(BWConv);
BWConv(BWConv==0) = NaN;

% Creating the LBP image

R = 1;
L = 2*R + 1;
C = round(L/2);
Input_Im = uint8(Input_Im);
row_max = size(Input_Im,1)-L+1;
col_max = size(Input_Im,2)-L+1;
LBP_Im = zeros(row_max, col_max);
for i = 1:row_max
    for j = 1:col_max
        A = Input_Im(i:i+L-1, j:j+L-1);
        A = A+1-A(C,C);
        A(A>0) = 1;
        LBP_Im(i,j) = A(C,L) + A(L,L)*2 + A(L,C)*4 + A(L,1)*8 + A(C,1)*16 + A(1,1)*32 + A(1,C)*64 + A(1,L)*128;
    end;
end;

[w,h] = size(LBP_Im);

BWConv2 = BWConv(2:w+1, 2:h+1);
LBP_Im2 = double(LBP_Im).*BWConv2;

% Dividing the image into blocks and calucating the number of dark / white pixels within each block

darkpixels=[];
whitepixels=[];
i = 0;
index = 1;

while k+k*i <= w
    j = 0;
    while k+k*j <= h
        darkpixels(index) = blackpix(LBP_Im2((1+k*i):(k+k*i), (1+k*j):(k+k*j)));
        whitepixels(index) = whitepix(LBP_Im2((1+k*i):(k+k*i), (1+k*j):(k+k*j)));

        j = j+1;
        index = index+1;

        %the pixels which can not fit into a block in the last columns:
        if k+k*j > h
            darkpixels(index) = blackpix(LBP_Im2((1+k*i):(k+k*i), (1+k*j):h));
            whitepixels(index) = whitepix(LBP_Im2((1+k*i):(k+k*i), (1+k*j):h));
            j = j+1;
            index = index+1;
        end     
    end

    i = i+1;
    %for the pixels who can not fit into a block in the last rows:
    if k+k*i > w
            j = 0;
        while k+k*j <= h
            darkpixels(index) = blackpix(LBP_Im2((1+k*i):w, (1+k*j):(k+k*j)));
            whitepixels(index) = whitepix(LBP_Im2((1+k*i):w, (1+k*j):(k+k*j)));
            j = j+1;
            index = index+1;

            if k+k*j > h
                darkpixels(index)=blackpix(LBP_Im2((1+k*i):w, (1+k*j):h));
                whitepixels(index)=whitepix(LBP_Im2((1+k*i):w, (1+k*j):h));
                j=j+1;
                index=index+1;

            end
        end
    end
end


no_of_blocks = length(darkpixels);
ratio = [no_of_blocks];

% Calculating the ratio, eliminating divison by zero

for i = 1:no_of_blocks
    if darkpixels(i) == 0
        ratio(i) = whitepixels(i);
    else
        ratio(i) = whitepixels(i) / darkpixels(i);
    end
end

% Calculating the number of blocks with a ratio below the threshold

average = nanmean(ratio);
average_to_compare = average / m;
count = 0;

for i = 1:no_of_blocks
    if ratio(i) < average_to_compare
        count = count + 1;
    end
    if ratio(i) == inf
        ratio(i) = average;
    end
end

% Classifying the image

no_of_blocks = no_of_blocks - sum(isnan(ratio));
ghosty = 0;

no_of_blocks_to_compare = no_of_blocks / c;

if count > no_of_blocks_to_compare
 %   fprintf('%s is a ghosty picture!\n', currentfilename)
    ghosty = 1;
%else fprintf('%s is not a ghosty picture!\n', currentfilename)
end

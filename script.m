clear all;
close all;

I = imread('s2.png');
BW = imbinarize(rgb2gray(I));
% Delete white background using bwconvfull
BWConv = bwconvhull(~BW);
BW2 = BW & BWConv;
BW2=uint8(BW2);

Input_Im=BW2.*I;
figure(8); imshow(Input_Im);

R=1;
L = 2*R + 1; %% The size of the LBP label
C = round(L/2);
Input_Im = uint8(Input_Im);
row_max = size(Input_Im,1)-L+1;
col_max = size(Input_Im,2)-L+1;
LBP_Im = zeros(row_max, col_max); %minden oldalon 1gyel kisebb, össz 2
for i = 1:row_max
    for j = 1:col_max
        A = Input_Im(i:i+L-1, j:j+L-1);
        A = A+1-A(C,C);
        A(A>0) = 1;
        LBP_Im(i,j) = A(C,L) + A(L,L)*2 + A(L,C)*4 + A(L,1)*8 + A(C,1)*16 + A(1,1)*32 + A(1,C)*64 + A(1,L)*128;
    end;
end;

figure(3);
imshow(LBP_Im);


% [w3,h3]=size(M);
% N=M(2:w3-1,2:h3-1); %first/last rows/columns are removed

[w2,h2]=size(LBP_Im);

for i=1:w2
    for j=1:h2
    end
end
        

aver=[];
blackcells=[];
nonblackcells=[];
i=0;
k=20; %blokksize
index=1;

while k+k*i<=w2
    j=0;
    while k+k*j<=h2
        aver(index)=mean2(LBP_Im((1+k*i):(k+k*i), (1+k*j):(k+k*j))); %whatever comes instead of this line, is a command executed on each block, also needs to be copied to all aver(...) lines
        blackcells(index)=nnz(~LBP_Im((1+k*i):(k+k*i), (1+k*j):(k+k*j)));
        nonblackcells(index)=nnz(LBP_Im((1+k*i):(k+k*i), (1+k*j):(k+k*j)));
        
        j=j+1;
        index=index+1;
        
        %for the pixels who can not fit into a block in the last columns:
%         if k+k*j>h2
%             aver(index)=mean2(LBP_Im((1+k*i):(k+k*i), (1+k*j):h2));
%             blackcells(index)=nnz(~LBP_Im((1+k*i):(k+k*i), (1+k*j):h2));
%             j=j+1;
%             index=index+1;
%         end     
    end
    
    i=i+1;
    %for the pixels who can not fit into a block in the last rows:
    if k+k*i>w2
            j=0;
        while k+k*j<=h2
            aver(index)=mean2(LBP_Im((1+k*i):w2, (1+k*j):(k+k*j)));
            blackcells(index)=nnz(~LBP_Im((1+k*i):w2, (1+k*j):(k+k*j)));
            nonblackcells(index)=nnz(LBP_Im((1+k*i):w2, (1+k*j):(k+k*j)));
            j=j+1;
            index=index+1;


%             if k+k*j>h2
%                 aver(index)=mean2(LBP_Im((1+k*i):w2, (1+k*j):h2));
%                 blackcells(index)=nnz(~LBP_Im((1+k*i):w2, (1+k*j):h2));
%                 j=j+1;
%                 index=index+1;
% 
%             end

        end
    end
end

blackcells(blackcells==0) = [];
average=mean(blackcells);
count=0;
ossz=length(blackcells);
for i=1:ossz
    if blackcells(i)<average
        count = count + 1;
    end
end

if ossz>(count*2)
    disp('ghosty')
end

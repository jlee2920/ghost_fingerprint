function[ghost] = improc(currentfilename)

I = imread(currentfilename);

% Delete white background using bwconvhull (the complex hull of the image)
BW = imbinarize(rgb2gray(I));
BWConv = bwconvhull(~BW);
BW2 = BW & BWConv;
BW2=uint8(BW2);

Input_Im=BW2.*I;

%Making the boarder NotaNumber
BWConv=double(BWConv);
BWConv(BWConv==0)=NaN;

%Creating the LBP image

R=1;
L = 2*R + 1; %% The size of the LBP label
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

[w2,h2]=size(LBP_Im);

BWConv2=BWConv(2:w2+1, 2:h2+1);
LBP_Im2=double(LBP_Im).*BWConv2;

aver=[];
blackcells=[];
whitecells=[];
i=0;
k=20; %blokksize -> can be changed!
index=1;

while k+k*i<=w2
    j=0;
    while k+k*j<=h2
        M=LBP_Im2((1+k*i):(k+k*i), (1+k*j):(k+k*j));
        aver(index)=nanmean(M(:));
        blackcells(index)=blackpix(LBP_Im2((1+k*i):(k+k*i), (1+k*j):(k+k*j)));
        whitecells(index)=whitepix(LBP_Im2((1+k*i):(k+k*i), (1+k*j):(k+k*j)));

        j=j+1;
        index=index+1;

        %for the pixels who can not fit into a block in the last columns:
        if k+k*j>h2
            M=LBP_Im2((1+k*i):(k+k*i), (1+k*j):h2);
            aver(index)=nanmean(M(:));
            blackcells(index)=blackpix(LBP_Im2((1+k*i):(k+k*i), (1+k*j):h2));
            whitecells(index)=whitepix(LBP_Im2((1+k*i):(k+k*i), (1+k*j):h2));
            j=j+1;
            index=index+1;
        end     
    end

    i=i+1;
    %for the pixels who can not fit into a block in the last rows:
    if k+k*i>w2
            j=0;
        while k+k*j<=h2
            M=LBP_Im2((1+k*i):w2, (1+k*j):(k+k*j));
            aver(index)=nanmean(M(:));
            blackcells(index)=blackpix(LBP_Im2((1+k*i):w2, (1+k*j):(k+k*j)));
            whitecells(index)=whitepix(LBP_Im2((1+k*i):w2, (1+k*j):(k+k*j)));
            j=j+1;
            index=index+1;


            if k+k*j>h2
                M=LBP_Im2((1+k*i):w2, (1+k*j):h2);
                aver(index)=nanmean(M(:));
                blackcells(index)=blackpix(LBP_Im2((1+k*i):w2, (1+k*j):h2));
                whitecells(index)=whitepix(LBP_Im2((1+k*i):w2, (1+k*j):h2));
                j=j+1;
                index=index+1;

            end

        end
    end
end


all2=length(blackcells);
ratio=[all2];
count=0;

for i=1:all2
    if blackcells(i)==0
        ratio(i)=whitecells(i);
    else
        ratio(i)=whitecells(i)/blackcells(i);
    end
end

average=nanmean(ratio);

for i=1:all2
    if ratio(i)<average/3 %few white pixels, average/x -> x can be changed!
        count = count + 1;
    end
    if ratio(i)==inf
        ratio(i)=average;
    end
end

all3=all2-sum(isnan(ratio));

ghost=0;

if count > all3/6 %all3/x ->x can be changed!
    fprintf('%s is a ghosty picture!\n', currentfilename)
    ghost=1;
end

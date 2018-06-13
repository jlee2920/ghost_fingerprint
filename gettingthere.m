clear all;
close all;
I = imread('s10.png');
I=rgb2gray(I);
[w , h]=size(I);
figure(1);
imshow(I)
hold on

%Creating the boundary
mask = false(size(I));
mask(1:w,1:h) = true;
visboundaries(mask,'Color','b');

bw = activecontour(I, mask, 1000, 'edge'); %increasing the number, gives us a more punctual contour - above 1500 no difference noticed anymore
visboundaries(bw,'Color','r');
set(gca,'units','pixels') % set the axes units to pixels
x = get(gca,'position'); % get the position of the axes
set(gcf,'units','pixels') % set the figure units to pixels
y = get(gcf,'position'); % get the figure position
set(gcf,'position',[y(1) y(2) x(3) x(4)])% set the position of the figure to the length and width of the axes
set(gca,'units','normalized','position',[0 0 1 1]) % set the axes units to pixels
f=getframe(figure(1)); imwrite(f.cdata,'Figure.png');
title('Initial contour (blue) and final contour (red)');

%Taking the red boundary pixels

rgb=imread('Figure.png');
redfig=zeros(w,h);
[r,g,l]=size(rgb);
rgb2=rgb(1:w,1:h);


for i=1:w
    for j=1:h
        if rgb(i,j,1)==255 & rgb(i,j,2)==0 & rgb(i,j,3)==0
            redfig(i,j)=1;
        end
    end
end

%Showing the boundary and filling the inside
figure(2);
imshow(redfig)
f=getframe; imwrite(f.cdata,'Figure.png');
M = imfill(redfig,'holes');
imshow(M)


% 
% mask = zeros(size(I));
% mask(25:end-25,25:end-25) = 1;
% % figure
% % imshow(mask)
% % title('Initial Contour Location')
% 
% bw = activecontour(I,mask,300);
% 
% figure
% imshow(bw)
% title('Segmented Image')

% multiply M with the original image (pixel by pixel) ->we get the inner
% pixels
Input_Im=I;
R=1;
M = uint8(M);

Input_Im = Input_Im.*M;


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

%Applying the 'fun' function on each block and saving it to I2
%std2: standard deviation

%fun = @(block_struct) std2(block_struct.data) * ones(size(block_struct.data));

%I2 = blockproc(LBP_Im,[4 4],fun);

meanFilterFunction = @(theBlockStructure) mean2(theBlockStructure.data(:)) * ones(2,2, class(theBlockStructure.data));
blockSize = [8 8];
blockyImage = blockproc(LBP_Im, blockSize, meanFilterFunction);

figure(4);
imshow(blockyImage,[]);

% terv: feher padding pixels, felosztani blokkokra, megnézni a fekete
% pixelek átlagát, és a blokkokat összevetni

% m=ceil(w/10);
% n=ceil(h/10);
% 
% blocks=im2col(LBP_Im,[m n],'distinct');
% imshow(blocks)

[w3,h3]=size(M);
N=M(2:w3-1,2:h3-1); %first/last rows/columns are removed

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

% i=0;
% j=0;
% for v=1+k*i:k+k*i
%     for q=1+k*j:k+k*j
%         if N(v,q) == 1




%terv: M mátrixban vannak a "jó" belső pixelek, ha az 1 akkor nézni a fehér
%pixeleket

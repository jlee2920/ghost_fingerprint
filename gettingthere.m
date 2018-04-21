I = imread('s8.png');
I=rgb2gray(I);
[w , h]=size(I);
figure
imshow(I)
hold on

%Creating the boundary
mask = false(size(I));
mask(1:w,1:h) = true;
visboundaries(mask,'Color','b');

bw = activecontour(I, mask, 500, 'edge');
visboundaries(bw,'Color','r');
f=getframe; imwrite(f.cdata,'Figure.png');
title('Initial contour (blue) and final contour (red)');

%Taking the boundary pixels
redfig=zeros(w,h);
rgb=imread('Figure.png');

for i=1:w
    for j=1:h
        if rgb(i,j,1)==255 & rgb(i,j,2)==0 & rgb(i,j,3)==0
            redfig(i,j)=1;
        end
    end
end

%Showing the boundary and filling the inside
figure
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
% 
Input_Im=I
R=1;
M = uint8(M);

Input_Im = Input_Im.*M;


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

figure
imshow(LBP_Im);
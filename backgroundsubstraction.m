%https://www.pantechsolutions.net/blog/matlab-code-for-background-subtraction/
%It takes some time to obtain the result, you can also change the number of
%iterations in line 26 to get better results but can take up to 1 min on my
%computer.

I = imread('s1.png');
I=rgb2gray(I);
imshow(I)
hold on
title('Original Image')

mask = false(size(I));
mask(1:506,1:401) = true;
visboundaries(mask,'Color','b');

bw = activecontour(I, mask, 500, 'edge');
visboundaries(bw,'Color','r'); 
title('Initial contour (blue) and final contour (red)');

mask = zeros(size(I));
mask(25:end-25,25:end-25) = 1;
figure
imshow(mask)
title('Initial Contour Location')

bw = activecontour(I,mask,300);

figure
imshow(bw)
title('Segmented Image')
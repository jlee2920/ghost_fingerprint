%Canny - edge detection
%It finds the edges on the picture quite well, in case we need to 'fill'
%the areas, we need to improve the given function.

I = imread('s1.png');
I=rgb2gray(I);
imshow(I)
hold on
title('Original Image')

BW1 = edge(I,'Canny');
figure(2);
imshow(imcomplement(BW1))

BW2 = imcomplement(imfill(BW1,'holes'));
figure(3)
imshow(BW2)
title('Filled Image')




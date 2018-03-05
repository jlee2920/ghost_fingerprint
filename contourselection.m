%You need to select the initial contour location, afterwards it tries to
%find the contour itself.

I = imread('s1.png');
I=rgb2gray(I);
imshow(I)
hold on
title('Original Image')

str = 'Click to select initial contour location. Double-click to confirm and proceed.';
title(str,'Color','b','FontSize',12);
disp(sprintf('\nNote: Click close to object boundaries for more accurate result.'))

mask = roipoly;
  
figure, imshow(mask)
title('Initial MASK');

maxIterations = 200; 
bw = activecontour(I, mask, maxIterations, 'Chan-Vese');
  
% Display segmented image
figure, imshow(bw)
title('Segmented Image');
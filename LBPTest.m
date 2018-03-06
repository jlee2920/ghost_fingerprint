fingerprint = imread('s1.png');
greyFingerprint = rgb2gray(fingerprint);

figure
imshow(greyFingerprint)
title('Original Fingerprint')

lbp = extractLBPFeatures(greyFingerprint,'Normalization','None');

figure
histogram(lbp);
title ('Histogram of s1');
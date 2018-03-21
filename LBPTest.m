fingerprint = imread('s1.png');
greyFingerprint = rgb2gray(fingerprint);
test = size(greyFingerprint);
test2 = prod(floor(size(greyFingerprint)./[3 3]));

figure
imshow(greyFingerprint)
title('Original Fingerprint')

lbpFeatures = extractLBPFeatures(greyFingerprint);

figure
bar(lbpFeatures);
title ('Histogram of s1');
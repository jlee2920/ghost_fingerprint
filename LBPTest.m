fingerprint = imread('s1.png');
greyFingerprint = rgb2gray(fingerprint);
test = size(greyFingerprint);
test2 = prod(floor(size(greyFingerprint)./[3 3]));

figure
imshow(greyFingerprint)
title('Original Fingerprint')

lbpFeatures = extractLBPFeatures(greyFingerprint,'Normalization','None');
all = sum(lbpFeatures);
diagram = lbpFeatures/all;

figure
bar(diagram);
title ('Histogram of s1');
fingerprint = imread('ghost2.png');
greyFingerprint = rgb2gray(fingerprint);

figure
imshow(greyFingerprint)
title('Original Fingerprint')

lbpFeatures = extractLBPFeatures(greyFingerprint,'Normalization','None','Radius', 10, 'NumNeighbors', 24);
h=0
[numRows, numCols] = size(greyFingerprint);
cellNum = 1%floor(numRows)*floor(numCols)
for j=1:cellNum   
    h=(j-1)*59+1
    all = sum(lbpFeatures(h:h+58));
    if h == 1
        relativeValues = lbpFeatures(h:h+58)/all
    else
        relativeValues = [relativeValues lbpFeatures(h:h+58)/all];
    end
end
%diagram = lbpFeatures/all;

figure
bar(relativeValues);
title ('Histogram of normal2');
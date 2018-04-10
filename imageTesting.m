I = imread('s3.png');
B = blockproc(I,[100 100],@(x) lbpGhost(x.data)) 

function distance = lbpGhost(testImage)
    fingerprint = imread('s7normal75.png');
    greyFingerprint = rgb2gray(fingerprint);
    %testfingerprint = imread('s8ghost100.png');
    ghostGreyFingerprint = rgb2gray(testImage);

    %figure
    %imshow(greyFingerprint)
    %title('Original Fingerprint')

    Im=im2double(greyFingerprint);
    filteredImageBase = conv2(Im, ones(3,3));
    figure; subplot(1,4,1); imshow(filteredImageBase, []);title('filtered');
    subplot(1,4,2); imshow(Im); title('original');
    Im2=im2double(ghostGreyFingerprint);
    filteredImageTest = conv2(Im2, ones(3,3));
    subplot(1,4,3); imshow(filteredImageTest, []);title('filtered Test');
    subplot(1,4,4);imshow(ghostGreyFingerprint);title('Test Fingerprint');

    lbpFeatures = extractLBPFeatures(filteredImageBase,'Normalization','None','Radius', 10, 'NumNeighbors', 24);
    h=0
    [numRows, numCols] = size(filteredImageBase);
    cellNum = 1%floor(numRows)*floor(numCols)
    for j=1:cellNum   
        h=(j-1)*59+1
        all = sum(lbpFeatures(h:h+554));
       % if h == 1
            relativeValues = lbpFeatures(h:h+554)/all
       % else
       %     relativeValues = [relativeValues lbpFeatures(h:h+58)/all];
       % end
    end
    %diagram = lbpFeatures/all;


    figure
    subplot(1,2,1);bar(relativeValues);
    title ('Histogram of training');

    testlbpFeatures = extractLBPFeatures(filteredImageTest,'Normalization','None','Radius', 10, 'NumNeighbors', 24);
    ;
    g=0
    [numRows, numCols] = size(filteredImageTest);
    cellNum = 1%floor(numRows)*floor(numCols)
    for g=1:cellNum   
        g=(j-1)*59+1
        all = sum(testlbpFeatures(g:g+554));
       % if h == 1
            testRelativeValues = testlbpFeatures(g:g+554)/all
       % else
       %     relativeValues = [relativeValues lbpFeatures(h:h+58)/all];
       % end
    end

    subplot(1,2,2);bar(testRelativeValues);
    title ('Histogram of test')

    %chi square of absolute values
    m = size(lbpFeatures,1);  n = size(testlbpFeatures,1);
    mOnes = ones(1,m); D = zeros(m,n);
    for i=1:n
      yi = testlbpFeatures(i,:);  yiRep = yi( mOnes, : );
      s = yiRep + lbpFeatures;    d = yiRep - lbpFeatures;
      D(:,i) = sum( d.^2 ./ (s+eps), 2 );
    end
    D = D/2;

    distance = D;
end 
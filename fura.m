Out=imread('s1.png');
[Out]=round(rgb2hsv(Out));
Out=rgb2gray(Out);
[rows columns]=size(Out);

for i=1:rows
for j=1:columns

if Out(i,j) >0

BinaryImage(i,j)=1;

else

BinaryImage(i,j)=0;

end

end
end

FilteredImage=medfilt2(BinaryImage,[5 5]);

[L num]=bwlabel(FilteredImage);

STATS=regionprops(L,'all');
cc=[];
removed=0;

for i=1:num
dd=STATS(i).Area;

if (dd < 500)

L(L==i)=0;
removed = removed + 1;
num=num-1;

else

end

end

[L2 num2]=bwlabel(L);

[B,L,N,A] = bwboundaries(L2);

subplot(2,2,3),  imshow(L2);title('BackGround Detected');
subplot(2,2,4),  imshow(L2);title('Blob Detected');

hold on;

for k=1:length(B),

if(~sum(A(k,:)))
boundary = B{k};
plot(boundary(:,2), boundary(:,1), 'r','LineWidth',2);

for l=find(A(:,k))'
boundary = B{l};
plot(boundary(:,2), boundary(:,1), 'g','LineWidth',2);
end

end

end
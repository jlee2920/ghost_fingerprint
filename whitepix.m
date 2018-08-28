function whitepix = whitepix(M)
%counting the number of white pixels, the result is NaN only if all values
%are NaN within the block

numbel = numel(M);

idx=M==255;
idy=isnan(M);
if sum(idy(:))==numbel
    whitepix=NaN;
else
    whitepix=sum(idx(:));
end
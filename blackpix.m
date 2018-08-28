function blackpix = blackpix(M)
%counting the dark enough pixels (>150 colour code), the result is NaN only if all values
%are NaN within the block

numbel = numel(M);

idx=M<150;
idy=isnan(M);
if sum(idy(:))==numbel
    blackpix=NaN;
else
    blackpix=sum(idx(:));
end

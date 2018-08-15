%choose a folder with only ghost / no ghost pictures
myFolder = 'D:\20180518\Downloads\png.001\png\all\noghost\';
filePattern = fullfile(myFolder, '*.png');
bmpFiles = dir(filePattern);

countghost=0;

for k = length(bmpFiles):-1:1
    baseFileName = bmpFiles(k).name;
    baseFileName = [myFolder baseFileName];
    gh = improc(baseFileName);
    countghost = countghost + gh;
end

fprintf('%u ghost pictures counted out of %u pictures \n', countghost, length(bmpFiles));
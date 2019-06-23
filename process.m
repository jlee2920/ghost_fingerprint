function countghost = process(file, bmpFiles, myFolder, l, m, c)

countghost = 0;

for k = length(bmpFiles):-1:1
    baseFileName = bmpFiles(k).name;
    baseFileName = [myFolder baseFileName];
    gh = improc(baseFileName, l, m, c);
    countghost = countghost + gh;
    if gh == 1
        fprintf(file, '%s is a ghosty image.\n', baseFileName);
    else
        fprintf(file, '%s is not ghosty image.\n', baseFileName);
    end
end

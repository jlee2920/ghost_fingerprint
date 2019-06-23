% Recognition of 'ghosty' fingerprints
% Run this script only

prompt = 'Enter the the path with the png images!\n e.g. D:\\myfolder\\pictures\\ \n';
myFolder = input(prompt, 's');
while isempty(myFolder)
    fprintf('Undefined path!\n')
    prompt = 'Enter the the path with the png images!\n e.g. D:\\myfolder\\pictures\\ \n';
    myFolder = input(prompt, 's');
end

prompt = 'Enter the number of the required mode:\n 1) Best on average 2) Lowest false positive rate 3) Lowest false negative rate\n';
mode = input(prompt);
if ~ismember(mode, [1, 2, 3])
    fprintf('Wrong mode selected!\n')
    prompt = 'Enter the number of the required mode:\n 1) Best on average 2) Lowest false positive rate 3) Lowest false negative rate\n';
    mode = input(prompt);
end

filePattern = fullfile(myFolder, '*.png');
bmpFiles = dir(filePattern);

fprintf('Please wait until the process finishes.\n')

file = fopen('results.txt','w');
tic
switch mode
    case 1
        l = 15;
        m = 2.5;
        c = 5;
        countghost = process(file, bmpFiles, myFolder, l, m, c);
    case 2
        l = 15;
        m = 3;
        c = 5;
        countghost = process(file, bmpFiles, myFolder, l, m, c);
    case 3       
        l = 10;
        m = 2.5;
        c = 5;
        countghost = process(file, bmpFiles, myFolder, l, m, c);
end
toc

fprintf('%u ghosty images counted out of %u images.\n', countghost, length(bmpFiles))
fprintf('Please check the results.txt created in your current path for more detailed results!\n')

function showImages(path, ext)

files = dir([path filesep '*.' ext]);
nameFiles = {files.name};
for idx_files = 1:length(nameFiles)
    name = nameFiles{idx_files}
    image = imread([path filesep name]);
    imshow(image~=0)
    min(image(:))
    max(image(:))
    pause(0.01)
    
end
function expt = createFileLists(config,expt)
% ----------------------------------------------------------
% Create training and testing file list
% For aesthetics / memorability evaluation the classes are the top and
% bottom x% of the data.
% dataDir = '/cluster/gupta/DataBase/' ;
% imageDir = images ;
% imageFmt = '.jpg' ;
% INPUT:
% config : structure
% expt: experiment information
% OUTPUT:
% [] : there is no output since the input experiment structure is modified
% ----------------------------------------------------------------------

% read the imagelist and create the filelist into training and testing
try
    dataSetList = load(expt.dataSetFile);
catch err
    fprintf('%s', err.identifier());
end

% ---------------------------------------------------------------------
% TODO
% ---------------------------------------------------------------------
% nClass = str2double(config.numClass);
% create the filelist with flexibility based on arbitrary number of classes
% 
% ------------------------------------------------------------------------

% remove those images which have a zero rating
dataSetList = dataSetList(dataSetList(:,2) > 0, :);

% Split the dataSetList into top and bottom half in terms of labels
% Split each half into training and testing
% combine the halfs into binary class training and testing lists

nImages = size(dataSetList,1);
% split the dataset into the two classes
% since the images are sorted in ascending order of rating, the bottom half
% will be low quality images and top half will be high quality imags
imgLow = dataSetList(1:nImages/2);
imgHigh = dataSetList(nImages/2:nImages);
% the number of low and high quality images
nLow = max(size(imgLow));
nHigh = max(size(imgHigh));
% randomize the two sets of high and low quality images which will
% subsequently be utilized in training and testing lists
imgLowPerm = imgLow(randperm(nLow));
imgHighPerm = imgHigh(randperm(nHigh));
% append class labels to images
imgLow = zeros(nLow,2);
imgHigh = ones(nHigh,2);
imgLow(:,1) = imgLowPerm;
imgHigh(:,1) = imgHighPerm;
% take half of each class images to training and testing sets
trainList = vertcat(imgLow(1 : nLow/2, :), imgHigh(1 : nHigh/2, :));
testList = vertcat(imgLow(nLow/2 : nLow, :), imgHigh(nHigh/2 : nHigh, :));
% record the train and test list to the experiment structure
expt.trainList = trainList;
expt.testList = testList;
% save the train and test list to file
trainListFileName = fullfile(expt.currDir, 'trainList.mat');
testListFileName = fullfile(expt.currDir, 'testList.mat');
save(trainListFileName, 'trainList');
save(testListFileName, 'testList');
% -----------------------------------------------------------------------
% create maps containing paths to images, image features, image coded
% feature

expt.trainImagePathMap = containers.Map();
nTrainImage = max(size(expt.trainList));
for count = 1 : nTrainImage
    % the map key is the image id number
    key = num2str(expt.trainList(count)); 
    % the map value is the image path
    value = fullfile(expt.imagePath, [key expt.imageFmt]);
    % add the key,value pair to the map container
    expt.trainImagePathMap(key) = value;
end
%
expt.testImagePathMap = containers.Map();
nTestImage = max(size(expt.testList));
for count = 1 : nTestImage
   % the map key is the image id number
    key = num2str(expt.testList(count)); 
    % the map value is the image path
    value = fullfile(expt.imagePath, [key expt.imageFmt]);
    % add the key,value pair to the map container
    expt.testImagePathMap(key) = value; 
end
% ------------------------------------------------------------------------
% create container for paths to training and test image feature descriptors

expt.trainImageFeatureMap = containers.Map();
nTrainImage = max(size(expt.trainList));
for count = 1 : nTrainImage
    % the map keys is the image id number
    key = num2str(expt.trainList(count));
    % the map values is the image feature descritor path
    value = fullfile(expt.trainFeatureDir, [key '.' config.feature]);
    expt.trainImageFeatureMap(key) = value;
end
%
expt.testImageFeatureMap = containers.Map();
nTestImage = max(size(expt.testList));
for count = 1 : nTestImage
    % the map key is the image id number
    key = num2str(expt.testList(count));
    % the map value is the image feature descriptor path
    value = fullfile(expt.testFeatureDir, [key '.' config.feature]);
    % add key,value pair to the map
    expt.testImageFeatureMap(key) = value;
end
% ------------------------------------------------------------------------
% create container for paths to training and testing image encoded features

expt.trainImageEncodedMap = containers.Map();
nTrainImage = max(size(expt.trainList));
for count = 1 : nTrainImage
    % the map keys is the image id nubmer
    key = num2str(expt.trainList(count));
    % the map value is the image feature encoded representation path
    value = fullfile(expt.trainCodeVectorDir, [key  expt.codeVectorFmt]);
    expt.trainImageEncodedMap(key) = value;
end
%
expt.testImageEncodedMap = containers.Map();
nTestImage = max(size(expt.testList));
for count = 1 : nTestImage
    % the map keys is the iamge id
    key = num2str(expt.testList(count));
    % the map value is the image feature encoded representation path
    value = fullfile(expt.testCodeVectorDir, [key expt.codeVectorFmt]);
    % add the key,value pair to the map
    expt.testImageEncodedMap(key) = value;
end



end
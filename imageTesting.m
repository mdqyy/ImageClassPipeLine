function imageTesting(config, expt)

phase = 'testing';

% --------------------------------------------------------------------
% Extract Features
% --------------------------------------------------------------------


if(strcmp(config.extractFeatures,'true'))
       
    % iterate over the testing list
    nTestImages = max(size(expt.testList));
    for count = 1 : nTestImages
        extractFeature(expt, config, expt.testList(count));
    end
end


% --------------------------------------------------------------------
% Test Codebook
% --------------------------------------------------------------------

% The test codebook is the same as train codebook!

% --------------------------------------------------------------------
% Encode Testing Images
% --------------------------------------------------------------------

encodeImages(expt,config,phase);

% --------------------------------------------------------------------
% Compute the entropy of each image at multiple scales
% -------------------------------------------------------------------- 

computeEntropy(expt, phase);
% --------------------------------------------------------------------
% Compute the correlation score between the aesthetic rank and entropies
%
expt = computeEntropyCorrScore(expt, phase);

% --------------------------------------------------------------------
% Test classification
% --------------------------------------------------------------------





end
function expt = encodeImages(expt,config,phase)
% phase is either 'training' or 'testing'

% for each image in the training set use kmeans and the learnt codebook to
% assing the dictionary elements to each patch

if strcmp(phase, 'training')
    numImageTraining = str2double(config.numImageTraining); % number of training images
    count = 0;
    for i = 1 : numel(expt.trainList)
        featurePath = expt.trainImageFeatureMap(num2str(expt.trainList(i)));
        if ~exist(expt.trainImageEncodedMap(num2str(expt.trainList(i))), 'file')
            try           
                load(featurePath, 'image');
                % image structure has the descriptors

                descrs = image.descrs;
                % transpose the descriptor matrix
                descrs = double(descrs');
                if isfield(expt, 'codeBook')
                    dictionary = expt.codeBook;                    
                else
                    load(fullfile(expt.trainCodeBookDir, [ config.feature 'trainCodeBook.mat']), 'dictionary');                   
                end

                try
                    % ------------------------------------------------------
                    % assing the descriptors to dictionary elements... manually

                   % idx = zeros(max(size(descrs)),1);
                   %
                   % for j = 1 : max(size(descrs))
                   %    dstncs = pdist2( double(descrs(j,:)), dictionary);
                   %    minidx = find(dstncs == min(dstncs));
                   %    idx(j) = minidx(1);
                   % end

                   % Using the inbuilt kmeans clustering algorithm for
                   % encoding gave a predominant association of image
                   % descriptors to one dictionary element. 
                   % ---------------------------------------------------
                   % TODO : Change the encoding mechanism to incorporate
                   % the use of faster means of encoding the descriptors in
                   % the image using the codebook.
                   % opts = statset('MaxIter', 1);
                   % [idx, ~] = kmeans(descrs, expt.dictionarySize, 'start', expt.codeBook, 'emptyaction', 'drop', 'Options', opts);

                    [~, codeids] = min(vl_alldist(dictionary', descrs'), [], 1);
                    idx = vl_binsum(zeros(size(dictionary', 2), 1), 1, double(codeids));
                    idx = double(idx);

                    fprintf('%d: %d\n', expt.trainList(i), entropy(hist(idx,expt.dictionarySize))) 
                    % save the encoded descriptor patches to file                    
                    save(expt.trainImageEncodedMap(num2str(expt.trainList(i))), 'idx');                  
                    count = count + 1;

                catch errKmeans
                    disp(errKmeans.identifier());
                end         

            catch err
                disp(err.identifier());
            end
        end

        % when required number of images have been acquired stop the process
        if count >= numImageTraining
            break;
        end

    end
elseif strcmp(phase, 'testing')
    % -------------------------------------------------------------------
    % Testing images encoding
    % -------------------------------------------------------------------
    
end

end
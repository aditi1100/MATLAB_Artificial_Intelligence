clc;
clear;
tic;

numTestImages=3000;
maxTrainingImages=5;
totalTrainingImages=60000;
collectErrors=0;
progressReport=1;

% load the training data
train_label_filename = 'train-labels-idx1-ubyte';
train_image_filename = 'train-images-idx3-ubyte';

% set up the classes that we are using in our classification problem
possibleClassLabels=0:9;
%classLabels=[0,1,2];
classLabels=[0,1,2,3,4,5,6,7,8,9];
labelToClassMap=-1*ones(length(possibleClassLabels),1);
for i=1:length(classLabels),
    classIndex = find(classLabels(i)==possibleClassLabels);
    if (length(classIndex) > 0)
        labelToClassMap(classIndex) = i;
    end
end

% determine size of an image and allocate space for mean vectors and
% scatter matrices
[train_label, train_imagedata, irows, icols] = readUByteImageAndLabel(1,train_image_filename,train_label_filename);

% compute the feature vectors for training
numFeatures=irows*icols;
fprintf(1,'Loading the %d training images to compute PCA vectors with %d-dimensions.\n',maxTrainingImages,numFeatures);
numClasses=length(classLabels);

numTrainingImages=zeros(numClasses,1);
numDimensions=irows*icols;


[train_label, train_imagedata, irows, icols] = readNUByteImagesAndLabels(totalTrainingImages,train_image_filename,train_label_filename);
gammaMatrix = [];
labelVec = [];
%Imean = zeros(numDimensions,1);
for imageIndex=1:totalTrainingImages,
    labelIndex = train_label(imageIndex)+1;
    classIndex = labelToClassMap(labelIndex);
    if (classIndex ~= -1 && numTrainingImages(classIndex) < maxTrainingImages)
        I = getImage(imageIndex, train_imagedata, irows, icols);
        Ivec = reshape(I, numel(I), 1);
        rowPos = numTrainingImages(classIndex)+1;
        gammaMatrix = [gammaMatrix, Ivec];
        labelVec = [labelVec; train_label(imageIndex)];
        %Imean = Imean + double(Ivec);
        numTrainingImages(classIndex) = numTrainingImages(classIndex)+1;
    end
    if (length(find(numTrainingImages==maxTrainingImages)) == length(numTrainingImages))
        fprintf(1,'Done computing the scatter of %d training vectors for each class.\n',maxTrainingImages);
        break;
    end
end
% start computation of the principal components for the image values for each digit
[Ufull,lambda,psi] = computeFullEigenSpace(gammaMatrix);
% end computation of the principal components for the image values for each digit

[numDimensions , Nt] = size(gammaMatrix);

M = min(numDimensions,Nt);
phiMatrix = double(gammaMatrix) - psi*ones(1,M);

[omegaMatrix,Ureduced] = reduceEigenSpace(Ufull,lambda,phiMatrix);

test_label_filename = 't10k-labels-idx1-ubyte';
test_image_filename = 't10k-images-idx3-ubyte';
classifications=[];
errorVecs=[];
errorLabels=[];
pct=0.1;
for imageIndex=1:numTestImages,
    %[test_label, test_imagedata, irows, icols] = readUByteImageAndLabel(imageIndex, train_image_filename,train_label_filename);
    [test_label, test_imagedata, irows, icols] = readUByteImageAndLabel(imageIndex, test_image_filename, test_label_filename);
    if (length(find(classLabels==test_label))>0)
        correctLabel=test_label;
        I_test = getImage(1, test_imagedata, irows, icols);
        
        % classify vector
        classifiedLabel = eigenspaceClassify(I_test, omegaMatrix, labelVec, Ureduced, psi);
        
        classifications=[ classifications; correctLabel, classifiedLabel];
        if (correctLabel ~= classifiedLabel && collectErrors==1)
            errorVecs = [errorVecs, Ivec];
            errorLabels = [errorLabels; correctLabel, classifiedLabel];
        end
    end
    if (imageIndex==round(numTestImages*pct) && progressReport==1)
      fprintf(1,'Processing test image index %4d out of %4d test images, %3.1f percent done.\n',...
      imageIndex,numTestImages,100*imageIndex/numTestImages);
      pct = pct+0.1;
      if (exist('OCTAVE_VERSION'))
        fflush(1);
      end
    end
end

% compute error rate
for classIndex=1:length(classLabels),
    digitIndices = find(classifications(:,1) == classLabels(classIndex));
    numClassifications = length(digitIndices);
    numCorrect = length(find(classifications(digitIndices,1)==classifications(digitIndices,2)));
    if (numClassifications==0)
        numClassifications=0;
        numCorrect=1;
    end
    fprintf(1,'Results for digit %d achieved %4d correct classifications out of %4d total instances, %3.2f percent error.\n',...
        classLabels(classIndex), numCorrect, numClassifications,100*(1-(numCorrect/numClassifications)));
end
numCorrect = length(find(classifications(:,1)==classifications(:,2)));
[numClassifications, blah] = size(classifications);
fprintf(1,'Got %5d correct classifications out of %5d total classifications.\n',numCorrect, numClassifications);
fprintf(1,'Classifier has %4.2f percent error.\n',100*(1-(numCorrect/numClassifications)));
endtime=toc;
totalruntime=endtime;
fprintf(1,'Time spent for PCA classifier classifications is %4.2f seconds\n',totalruntime);


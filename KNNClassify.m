function estimatedLabel = KNNClassify(I_test,k,featureValues,featureLabels)
    %The I_test parameter passed into this function is omega vector of this
    %the test sample.It calls findKNN function and gets a list of sorted
    %nearest neighbours from which it uses the parameter k to find how many
    %neighbours it should consider and find the class which the highest
    %number of neighbours belong to.It returns an estimated label for the
    %test data.
    [xNN,xlabels] = findKNN(I_test,k,featureValues,featureLabels);
    closestClasses = zeros(1,10);
    for i = 1:k
        closestClasses(xlabels(i)+1)= closestClasses(xlabels(i)+1)+ 1; 
    end
    [xlab idx] = sort(closestClasses,'descend');
    estimatedLabel = idx(1)-1;
    
end
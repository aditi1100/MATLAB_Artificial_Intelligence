function[xNN,xlabels] = findKNN(x_test,k,featureValues,featureLabels)

    %This function computes the distance of test data from the training 
    %points projected onto the subspace after taking in omega vector of test
    %data, k, omega matrix of training data and training labels. It does 
    %sorting based on distance, uses those indexes to return the values and
    %the class labels nearest neighbours.
    
    s= size(featureValues);
    omegaHat = [];
    for i=1:s(1)
        omegaHat = [omegaHat ; norm(featureValues(i,:) - x_test)];
    end
    [sorted_vector,idx] = sort(omegaHat);
    xNN = [];
    xlabels = [];
    for i = 1 : k
        xNN = [xNN; featureValues(idx(i))];
        xlabels = [xlabels ; featureLabels(idx(i))] ;
    end
    
end
function classifiedLabel = eigenspaceClassify(I_test, omegaMatrix, labelVec, Ureduced, psi)
    %The function takes in test data, omega matrix, feature labels, reduced
    %eigenspace and the eigenvalues to return a class .It does mean
    %normalization and projection of zero mean vector onto the reduced
    %subspace.Then it calls KNNClassify function to invoke the classifer.
    I_test = reshape(I_test,length(I_test)^2,1);
    omegaTest = I_test - psi;
    I_test = omegaTest'*Ureduced;
    k=1;
    featureValues = omegaMatrix;
    featureLabels = labelVec;
    classifiedLabel = KNNClassify(I_test,k,featureValues,featureLabels);
end
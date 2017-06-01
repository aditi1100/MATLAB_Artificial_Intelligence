function [u,L,P] = computeFullEigenSpace(gammaMatrix)
    % Given the gamma matrix of a dataset 
    % it does mean normalization, computes scatter matrix,
    % phi and the eigenvalues lambda to return the full 
    % eigenvector space U, lambda and phi
    
    s = size(gammaMatrix);
    const = s(2);
    psi = sum(gammaMatrix,2)./const;
    phi = gammaMatrix - repmat(psi,1,const);
    C = (1/const).*(phi'*phi);
    [eigenvec eigenval] = eig(C);
    u=zeros(length(psi),const);
    for i=1:const
        if (eigenval(i,i)<= 0)
            u(:,i)=zeros(length(psi),1);
        else
            u(:,i) = sqrt(1/(const*eigenval(i,i))).*(phi*eigenvec(:,i));
        end
    end
    L = eigenval; 
    P = psi;
end
    

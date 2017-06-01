const = maxTrainingImages*numClasses;
psi = sum(gammaMatrix,2)./const;
phi = gammaMatrix - repmat(psi,1,const);
C = (1/const).*(phi'*phi);
[eigenvec eigenval] = eig(C);
%u1 = sqrt(1/(const*eigenval(1,1))).*(phi*eigenvec(:,1))
u=zeros(length(psi),const);

for i=1:const
    if (eigenval(i,i)<= 0)
        u(:,i)=zeros(length(psi),1);
    else
        u(:,i) = sqrt(1/(const*eigenval(i,i))).*(phi*eigenvec(:,i));
    end
    
    
end

meanEig = sum(sum(eigenval))./const;
U =[]; 
for i=1:const
    if (eigenval(i,i)> meanEig(1))
        U = [U u(:,i)];
    end
end
omega = phi'*U;
reconstruct1 = omega*U' + repmat(psi',const,1);
%display a reconstructed image for the digit 4
image(reshape(reconstruct1(27,:),sqrt(length(psi)),sqrt(length(psi))));
%calculate the energy loss after compression 
lossInfo = norm(gammaMatrix-reconstruct1')


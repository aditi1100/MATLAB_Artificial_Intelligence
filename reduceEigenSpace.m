function [omegaMatrix,Ureduced] = reduceEigenSpace(u,eigenval,phi)
    %Takes the full eigenspace with phi and lambda values to compute the
    %reduced eigenspace and the weights of the projection. It returns the
    %reduced eigenspace and the omega matrix.
    s = size(u);
    const = s(2);
    meanEig = sum(sum(eigenval))./const;
    U =[]; 
    for i=1:const
        if (eigenval(i,i)> meanEig(1))
            U = [U u(:,i)];
        end
    end
    omegaMatrix = phi'*U;
    Ureduced=U;
    size(Ureduced)

end
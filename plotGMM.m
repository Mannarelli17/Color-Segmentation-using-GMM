function plotGMM(scaling_factors, gaussian_means, covariances)
    mus = gaussian_means;
    covars = covariances;
    display(covars)
    save covars
    n = size(mus);
    n = n(3);
    for i = 1:n
        %display(mus(i));
        %display(mus(i,2));
        %display(mus(i,3));
        display(covars(i));
        [x,y,z] = ellipsoid(mus(1,i),mus(2,i),mus(3,i),sqrt(covars(1,1,i)),sqrt(covars(2,2,i)),sqrt(covars(3,3,i)));
        surf(x, y, z);
        hold on
    end
    xlabel('R')
    ylabel('G')
    zlabel('B')
    hold off
end

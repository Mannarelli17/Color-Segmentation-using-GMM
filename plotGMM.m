function plotGMM(scaling_factors, gaussian_means, covariances)
    mus = gaussian_means;
    covars = covariances;
    for i = 1:size(mus)
        %display(mus(i));
        %display(mus(i,2));
        %display(mus(i,3));
        display(covars(i));
        [x,y,z] = ellipsoid(mus(i, 1),mus(i, 2),mus(i, 3),sqrt(covars(i,1)),sqrt(covars(i,4)),sqrt(covars(i,6)));
        surf(x, y, z);
        hold on
    end
    xlabel('R')
    ylabel('G')
    zlabel('B')
    hold off
end
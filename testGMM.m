% model = scaling_factors, gaussian_means, covariances
function cluster = testGMM(scaling_factors, gaussian_means, covariances, pixels, tau)
    k = size(gaussian_means);
    k = k(1);
    n = size(pixels);
    n = n(1);
    cluster = zeros(1,n);
    %P(Cl) = 0.5
    prior = 0.5;
    %apologies if i and j don't match exact as it does in the description
    %(swapped)
    for i = 1:n
        x = pixels(i);
        p_x_cl = 0;
        for j = 1:k
           mu = gaussian_means(j);
           S = covariances(j);
           p_x_cl = p_x_cl + scaling_factors(j)*exp(-0.5*transpose(x - mu)*(S\(x-mu)))/sqrt(det(S)*(2*pi)^3);
        end
        posterior = p_x_cl*prior;
        if(posterior >= tau)
            cluster(i) = 1;
        end
    end
end
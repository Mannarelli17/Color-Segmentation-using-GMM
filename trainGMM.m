function [pi_, mean_, cov_] = gmm_train(x, k)
	% x is nx3 data set where each coloumn are RGB or lab or hsv
	% k is the number of clusters
    op = double(transpose(x)); % do this because i like the convention more
	m = size(op,1); % 3 because RGB
    n = size(op,2); % this is the number of pixels
    % after i tranpose, op becomes a 3x(number of pixels) matrix
    % or essentially a list of 3x1 rgb vectors, n length

    threshold = 0.001;

	%initializing parameters
	pi_ = transpose(randn(k,1));

	mean_ = 200*(rand(m,k)); % list of 3x1 vectors
	prev_mean = mean_;

	%initializing covariance(m x m x k matrix)
	cov_ = 100*(reshape(repmat(diag(ones(m,1)),1,k),[m, m, k]));

	%posteriors(n x k matrix)
	posteriors = zeros(n,k); % n pixels per k clusters
	%maximum training iterations
	max_iters = 10;
	iters = 0;

	while iters<max_iters
		%E-step
        % loop through each cluster
		for i = 1:k
            % calculates each posterior, each pixel gets one per cluster
            % grabbing the variables per cluster
			mu = mean_(:, i); % grabbing the ith 3x1 vector
            sigma = cov_(:, :, i);
            scale = pi_(i);
            numerator = 0;
            denominator = 0;
            % loop through each pixel
            for j = 1:n
                x = op(:, j); % current pixel
                % calculate the numerator
                numerator = scale * exp(-0.5*transpose(x-mu)*(sigma\(x-mu)))/sqrt(det(sigma)*(2*pi)^3);
                % calculate the denominator, loop through every cluster
                % again, but this time we have the current pixel
                for g = 1:k
                mu_d = mean_(:, g);
                sigma_d = cov_(:, :, i);
                scale_d = pi_(i);
                denominator = denominator + scale_d*exp(-0.5*transpose(x - mu_d)*(sigma_d\(x-mu_d)))/sqrt(det(sigma_d)*(2*pi)^3);    
                end
                % display(numerator./denominator);
                posteriors(:, i) = numerator./denominator;
            end

        end

		%M-step
 		for i = 1:k

            % new mean for cluster
            numerator = 0;
            denominator = 0;
            for j = 1:n
                    x = op(:, j); % current pixel
                    p = posteriors(j,i); % current posterior
                    numerator = numerator + p*x;
                    denominator = denominator + p;
            end
            mean_(:, i) = numerator/denominator;

            % new covariance for cluster
            mu = mean_(:, i);
            numerator = 0;
            denominator = 0;
            for j = 1:k
                    x = op(:, j);
                    numerator = numerator + posteriors(j, i)*(x-mu)*transpose(x-mu);
                    denominator = denominator + posteriors(j, i);
            end
            cov_(:, :, i) = numerator/denominator;

            % new scaling factors
            pi_(i) = sum(posteriors(:, i))/n;    
        end

        norm(prev_mean - mean_)
	    if norm(prev_mean - mean_) < threshold
		    return
	    end
	    prev_mean = mean_;
		iters = iters+1;
    end

end 		%function end







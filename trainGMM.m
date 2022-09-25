function [mu sigma] = gmm_train(op, k)
	% x is nx3 data set where each coloumn are RGB or lab or hsv
	% k is the number of clusters
	n = size(op,1);
	m = size(op,2);
	%initializing parameters
	pi_ = randn(k,1);
	% initializing mean(k x m matrix)
	mean_ = 200*(rand(k,m));
	prev_mean = mean_;
	%initializing covariance(m x m x k matrix)
	cov_ = 100*(reshape(repmat(diag(ones(m,1)),1,k),[m, m, k]));
	%posteriors(n x k matrix)
	posteriors = zeros(n,k);
	%maximum training iterations
	max_iters = 10;
	iters = 0;

	while iters<max_iters
		%E-step
        % loop through each cluster
		for i = 1:k
            % calculates each posterior, each pixel gets one per cluster
            % grabbing the variables per cluster
			mu = mean_(:, i);
            sigma = cov_(:, :, i);
            scale = pi_(:, i);
            numerator = 0;
            denominator = 0;
            % loop through each pixel
            for j = 1:size(op, 2)
                x = op(:, j); % current pixel
                % calculate the numerator
                numerator = scale * exp(-0.5*transpose(x - mu)*(sigma\(x-mu)))/sqrt(det(sigma)*(2*pi)^3);
                % calculate the denominator, loop through every cluster
                % again, but this time we have the current pixel
                for g = 1:k
                mu = mean_(:, g);
                sigma = cov_(:, :, i);
                scale = pi_(:, i);
                denominator = denominator + scale*exp(-0.5*transpose(x - mu)*(sigma\(x-mu)))/sqrt(det(sigma)*(2*pi)^3);    
                end
                posteriors(j, k) = numerator / denominator;
            end

		end
		%summing the posteriors of all clusters : nx1
		sum_posteriors = sum(sum(posteriors(:,i),2),1);
		%normalizing the posterior vector(again n x 1 matrix)
		posteriors = posteriors/sum_posteriors;

		%M-step
		for i = 1:k
			mean_(i,:) = sum((posteriors(:,i).*x))/sum(posteriors(:,i));
			cov_posterior_prod = zeros(3,3);
			posteriors_sum = 0;

			for j = 1:size(x,1)
				cov_posterior_prod =cov_posterior_prod + posteriors(j,i)*(((x(j,:)-mean_(i,:))')*(x(j,:)-mean_(i,:)));
				posteriors_sum = posteriors_sum + posteriors(j,i);
            end

			covariance(:,:,i) = cov_posterior_prod/posteriors_sum;
			pi_(i) = sum(posteriors(:,i))/size(x,1);
        end

		iters = iters+1;
	end

% 	norm(prev_mean - mean_)
% 	if norm(prev_mean - mean_) < threshold
% 		return
% 	end
% 	prev_mean = mean_;

end 		%function end


function [posteriors] = f(mean_, cov_, op, pi_)
    posteriors = 0;
end
function corr_map= correlation_map (ano, index);


[I,J,N] = size(ano);

y = index;
sy2 = (y'*y)/N;    % variance of y
sy  = sqrt(sy2);   % standard devitation of y

for i= 1 : I
    for j = 1 : J
        x = squeeze(ano(i,j,:));
        sx2 = (x'*x)/N;    % variance of x
        sx  = sqrt(sx2);   % standard devitation of x
        r = (y'*x)/N /(sy*sx);
        corr_map(i,j) = r;

        % MATLAB naitive function
        % rcoeffs = corrcoef(nino34, x);
        % nino34_corr_map(i,j) = rcoeffs(2,1);
    end
end


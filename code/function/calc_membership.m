function [u] = calc_membership(x,v,b)

n_examples = size(x,1);
x_e = [x,ones(n_examples,1)];
[k,d] = size(v); 

for i=1:k
    v1 = repmat(v(i,:),n_examples,1);
    bb = repmat(b(i,:),n_examples,1);
    wt(:,i) = exp(-sum((x-v1).^2./bb,2));   
end

wt2 = sum(wt,2);


ss = wt2==0;
wt2(ss,:) = eps;
wt = wt./repmat(wt2,1,k);
u = wt;
end


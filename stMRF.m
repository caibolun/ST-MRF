function [ refine_D, w, b ] = stMRF( V, D_t, uD_t, lambda_t, r, eps)

uV = convBox(V, r);
uVV = convBox(V.*V, r);
uVD_t=convBox(bsxfun(@times,V,D_t), r);

numerator = sum(bsxfun(@times, uVD_t-bsxfun(@times,uV,uD_t),lambda_t),3);
denominator = uVV - uV.^2;

w = numerator ./ (denominator + eps);
b = sum(bsxfun(@times,uD_t,lambda_t),3)-w .* uV;

refine_D = w .* V + b;

end


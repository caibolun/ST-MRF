function [ refine_D, w, b ] = fast_stMRF( I, D_t, uD_t, lambda_t, r, s, eps)

V = imResample(I, 1/s, 'nearest');
uV = convBox(V, r);
uVV = convBox(V.*V, r);
uVD_t = convBox(bsxfun(@times,V,D_t), r);

numerator = sum(bsxfun(@times, uVD_t-bsxfun(@times,uV,uD_t),lambda_t),3);
denominator = uVV - uV.^2;

w = numerator ./ (denominator + eps);
b = sum(bsxfun(@times,uD_t,lambda_t),3)-w .* uV;

w = imResample(w, [size(I, 1), size(I, 2)], 'bilinear');
b = imResample(b, [size(I, 1), size(I, 2)], 'bilinear');

refine_D = w .* I + b;

end


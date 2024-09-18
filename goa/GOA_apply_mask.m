function field = apply_mask(field, mask)

[I,J,T] = size(field);
mask = repmat(mask, [1 1 T]);
field = field.*mask;
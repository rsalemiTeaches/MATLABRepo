function binout = binenc(in, wi1, bi1, w12, b12, w2o, b2o);
    L1 = myrelu(wi1 * in + bi1);
    L2 = myrelu(w12 * L1 + b12);
    binout = myrelu(w2o * L2 + b2o);
end

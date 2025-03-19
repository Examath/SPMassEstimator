function o = span(x1, x2)
    L = abs(x2 - x1);
    x = (x1 + x2)/2;
    o = [L, x];
end
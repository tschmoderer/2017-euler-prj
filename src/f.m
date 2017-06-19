function y = f(U,gamma)
v = U(2,:)./U(1,:);
P = (gamma-1)*(U(3,:)-0.5*U(1,:).*v.*v);
y = U.*v+[zeros(size(P));P;P.*v];
end
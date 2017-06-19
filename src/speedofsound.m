function c = speedofsound(U,gamma)
rho = U(1,:);
v2 = (U(2,:)./rho).^2;
P = (gamma-1)*(U(3,:)-0.5*rho.*v2);
c = sqrt(gamma*P./rho);
end
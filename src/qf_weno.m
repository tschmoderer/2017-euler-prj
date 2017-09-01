function [q dt] = qf_weno(U,g,dx,cfl)

fU = f(U,g);
c = speedofsound(U,g);
a = abs(U(2,:)./U(1,:)) + c;

fp = 0.5*(fU + a.*U);
fm = 0.5*(fU - a.*U);

C0 = 0.1;
C1 = 0.6;
C2 = 0.3;
eps = 1e-6;

% compute fj+1/2+ and fj+1/2-
IS0p = 13*(fp(:,2:end-5)-2*fp(:,3:end-4)+fp(:,4:end-3)).^2/12 + 0.25*(fp(:,2:end-5)-4*fp(:,3:end-4)+3*fp(:,4:end-3)).^2;
IS1p = 13*(fp(:,3:end-4)-2*fp(:,4:end-3)+fp(:,5:end-2)).^2/12 + 0.25*(fp(:,3:end-4)-fp(:,5:end-2)).^2;
IS2p = 13*(fp(:,4:end-3)-2*fp(:,5:end-2)+fp(:,6:end-1)).^2/12 + 0.25*(3*fp(:,4:end-3)-4*fp(:,5:end-2)+fp(:,6:end-1)).^2;

IS0m = 13*(fm(:,5:end-2)-2*fm(:,6:end-1)+fm(:,7:end)).^2/12 + 0.25*(3*fm(:,5:end-2)-4*fm(:,6:end-1)+fm(:,7:end)).^2;
IS1m = 13*(fm(:,4:end-3)-2*fm(:,5:end-2)+fm(:,6:end-1)).^2/12 + 0.25*(fm(:,4:end-3)-fm(:,6:end-1)).^2;
IS2m = 13*(fm(:,3:end-4)-2*fm(:,4:end-3)+fm(:,5:end-2)).^2/12 + 0.25*(fm(:,3:end-4)-4*fm(:,4:end-3)+3*fm(:,5:end-2)).^2;

alpha0p = C0./(eps + IS0p).^2;
alpha1p = C1./(eps + IS1p).^2;
alpha2p = C2./(eps + IS2p).^2;

alpha0m = C0./(eps + IS0m).^2;
alpha1m = C1./(eps + IS1m).^2;
alpha2m = C2./(eps + IS2m).^2;

alphapS = alpha0p + alpha1p + alpha2p;
alphamS = alpha0m + alpha1m + alpha2m;

w0p = alpha0p./alphapS;
w1p = alpha1p./alphapS;
w2p = alpha2p./alphapS;

w0m = alpha0m./alphamS;
w1m = alpha1m./alphamS;
w2m = alpha2m./alphamS;

% Compute fj+1/2+ and fj+1/2-

fphalfp = w0p.*(2*fp(:,2:end-5)-7*fp(:,3:end-4)+11*fp(:,4:end-3))/6 + w1p.*(-fp(:,3:end-4)+5*fp(:,4:end-3)+2*fp(:,5:end-2))/6 + w2p.*(2*fp(:,4:end-3)+5*fp(:,5:end-2)-fp(:,6:end-1))/6;
fmhalfp = w2m.*(-fm(:,3:end-4)+5*fm(:,4:end-3)+2*fm(:,5:end-2))/6 + w1m.*(2*fm(:,4:end-3)+5*fm(:,5:end-2)-fm(:,6:end-1))/6 + w0m.*(11*fm(:,5:end-2)-7*fm(:,6:end-1)+2*fm(:,7:end))/6;

% The same for fj-1/2+ and fj-1/2-

IS0p = 13*(fp(:,1:end-6)-2*fp(:,2:end-5)+fp(:,3:end-4)).^2/12 + 0.25*(fp(:,1:end-6)-4*fp(:,2:end-5)+3*fp(:,3:end-4)).^2;
IS1p = 13*(fp(:,2:end-5)-2*fp(:,3:end-4)+fp(:,4:end-3)).^2/12 + 0.25*(fp(:,2:end-5)-fp(:,4:end-3)).^2;
IS2p = 13*(fp(:,3:end-4)-2*fp(:,4:end-3)+fp(:,5:end-2)).^2/12 + 0.25*(3*fp(:,3:end-4)-4*fp(:,4:end-3)+fp(:,5:end-2)).^2;

IS0m = 13*(fm(:,4:end-3)-2*fm(:,5:end-2)+fm(:,6:end-1)).^2/12 + 0.25*(3*fm(:,4:end-3)-4*fm(:,5:end-2)+fm(:,6:end-1)).^2;
IS1m = 13*(fm(:,3:end-4)-2*fm(:,4:end-3)+fm(:,5:end-2)).^2/12 + 0.25*(fm(:,3:end-4)-fm(:,5:end-2)).^2;
IS2m = 13*(fm(:,2:end-5)-2*fm(:,3:end-4)+fm(:,4:end-3)).^2/12 + 0.25*(fm(:,2:end-5)-4*fm(:,3:end-4)+3*fm(:,4:end-3)).^2;


alpha0p = C0./(eps + IS0p).^2;
alpha1p = C1./(eps + IS1p).^2;
alpha2p = C2./(eps + IS2p).^2;

alpha0m = C0./(eps + IS0m).^2;
alpha1m = C1./(eps + IS1m).^2;
alpha2m = C2./(eps + IS2m).^2;

alphapS = alpha0p + alpha1p + alpha2p;
alphamS = alpha0m + alpha1m + alpha2m;

w0p = alpha0p./alphapS;
w1p = alpha1p./alphapS;
w2p = alpha2p./alphapS;

w0m = alpha0m./alphamS;
w1m = alpha1m./alphamS;
w2m = alpha2m./alphamS;

fphalfm = w0p.*(2*fp(:,1:end-6)-7*fp(:,2:end-5)+11*fp(:,3:end-4))/6 + w1p.*(-fp(:,2:end-5)+5*fp(:,3:end-4)+2*fp(:,4:end-3))/6 + w2p.*(2*fp(:,3:end-4)+5*fp(:,4:end-3)-fp(:,5:end-2))/6;
fmhalfm = w2m.*(-fm(:,2:end-5)+5*fm(:,3:end-4)+2*fm(:,4:end-3))/6 + w1m.*(2*fm(:,3:end-4)+5*fm(:,4:end-3)-fm(:,5:end-2))/6 + w0m.*(11*fm(:,4:end-3)-7*fm(:,5:end-2)+2*fm(:,6:end-1))/6;


q = (fphalfp - fphalfm)/dx + (fmhalfp - fmhalfm)/dx;
dt = cfl*dx/max(a);

end
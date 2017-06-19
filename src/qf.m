function q = qf(U,gamma,theta,dx)
fU = f(U,gamma);
c = speedofsound(U,gamma);
a = abs(U(2,:)./U(1,:)) + c;

fp = 0.5 * (fU + a.*U);
fm = 0.5 * (fU - a.*U);

% Compute df+
dfp0 = theta*(fp(:,2:end-1) - fp(:,1:end-2))/dx; % Option 1
dfp1 = (fp(:,3:end) - fp(:,1:end-2))/(2*dx); % Option 2
dfp2 = theta*(fp(:,3:end) - fp(:,2:end-1))/dx; % Option 3

dfp = minmod(dfp0,dfp1,dfp2);

% Compute df-
dfm0 = theta*(fm(:,2:end-1) - fm(:,1:end-2))/dx; % Option 1
dfm1 = (fm(:,3:end) - fm(:,1:end-2))/(2*dx); % Option 2
dfm2 = theta*(fm(:,3:end) - fm(:,2:end-1))/dx; % Option 3

dfm = minmod(dfm0,dfm1,dfm2);

fE = fp(:,2:end-1) + 0.5*dx*dfp;
fW = fm(:,2:end-1) - 0.5*dx*dfm;

% Compute f+0.5 and f-0.5
fphalf = fE(:,2:end-1) + fW(:,3:end);
fmhalf = fE(:,1:end-2) + fW(:,2:end-1);

% Compute second member 
q = (fphalf - fmhalf)/dx;
end
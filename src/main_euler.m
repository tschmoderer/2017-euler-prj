clc
clear all 
close all 

% Constantes
a = 0;
b = 1;
theta = 1.5;
gamma = 1.4;
T = 0.05;
N = 300; 
dx = (b-a)/N;
x = [a-dx/2:dx:b+dx/2];
x = [x(1)-dx,x,x(end)+dx];
cfl = 2;
dt = cfl*dx^2;
dlmwrite('Results/dt.dat',dt);
s = size(x);

% Initialisation in Omega at t=0 and boundary conditions 
tmprho = ones(1,s(2)-4);
rho = [tmprho(2),tmprho(1),tmprho,tmprho(end), tmprho(end-1)];
tmpv = zeros(1,s(2)-4); 
%tmpv = 0.5*exp(-200*(x(3:end-2)-0.5).^2);
v = [-tmpv(2),-tmpv(1),tmpv,-tmpv(end),-tmpv(end-1)];
tmpP = P0(x(3:end-2));
%tmpP = ones(1,s(2)-4);
P = [tmpP(2),tmpP(1),tmpP,tmpP(end),tmpP(end-1)];

clear tmpP tmprho tmpv

E = P/(gamma-1) + 0.5*rho.*v.*v;

U = [rho;rho.*v;E];

figure;
subplot(5,1,1),
plot(x,zeros(s),'*')
line([a a],[0 1],'Color','blue')
line([b b],[0 1],'Color','blue')
line([a b],[0 0],'Color','red')
ylim([0 0.5])
title('Discretization of Omega')

subplot(5,1,2), 
plot(x,P)
title('Presure at t=0')

subplot(5,1,3), 
plot(x,v)
title('velocity at t=0')

subplot(5,1,4), 
plot(x,rho)
title('Density at t=0')

subplot(5,1,5), 
plot(x,E)
title('Energy at t=0')

pause; 
close all;

%%% Let's Go %%%
U1 = zeros(size(U)); % Reserve mem space
U1_1 = zeros(size(U));
U1_2 = zeros(size(U));

for t = 1:ceil(T/dt)

%% Euler scheme
%q = qf(U,gamma,theta,dx);
%U1(:,3:end-2) = U(:,3:end-2) - dt*q;
%U1(:,[1 2 end-1 end]) = [1;-1;1].*U1(:,[4 3 end-2 end-3]);

% SSP RK order 3
q = qf(U,gamma,theta,dx);
U1_1(:,3:end-2) = U(:,3:end-2) - dt*q;
U1_1(:,[1 2 end-1 end]) = [1;-1;1].*U1_1(:,[4 3 end-2 end-3]);

q1 = qf(U1_1,gamma,theta,dx);
U1_2(:,3:end-2) = U1_1(:,3:end-2) - dt*q1;
U1_2(:,[1 2 end-1 end]) = [1;-1;1].*U1_2(:,[4 3 end-2 end-3]);

q2 = qf(U1_2,gamma,theta,dx);
U1(:,3:end-2) = (1/3)*U(:,3:end-2) + 0.5*U1_1(:,3:end-2) + (1/6)*(U1_2(:,3:end-2) - dt*q2);
U1(:,[1 2 end-1 end]) = [1;-1;1].*U1(:,[4 3 end-2 end-3]);

rho = U(1,3:end-2);
v = U(2,3:end-2)./rho;
P = (gamma-1)*(U(3,3:end-2) - 0.5*rho.*v.*v);
c = speedofsound(U,gamma);

% Loop
U = U1;
if sum(imag(P) > 0) >0 
break;
end
dlmwrite(['Results/sound/c',num2str(t),'.dat'],[x(3:end-2)' c(3:end-2)'],' ')
dlmwrite(['Results/pressure/P',num2str(t),'.dat'],[x(3:end-2)' P'],' ')
dlmwrite(['Results/velocity/v',num2str(t),'.dat'],[x(3:end-2)' v'],' ')
dlmwrite(['Results/density/rho',num2str(t),'.dat'],[x(3:end-2)' rho'],' ')
dlmwrite(['Results/energy/E',num2str(t),'.dat'],[x(3:end-2)' U(3,3:end-2)'],' ')
end

warning('off','all')
clc
clear all 
close all 

%%% Constantes
%%a = 0;
%%b = 1;
%%theta = 1.5;
%%gamma = 1.4;
%%T = 0.1;
%%n = [100 200 400 800 1600 3200];
%%
%%for N=n
%%dx = (b-a)/N;
%%x = [a-dx/2:dx:b+dx/2];
%%x = [x(1)-dx,x,x(end)+dx];
%%cfl = 0.437/23;
%%dt = cfl*dx;
%%
%%s = size(x);
%%niter = ceil(T/dt);
%%
%%% Initialisation in Omega at t=0 and boundary conditions 
%%tmprho = ones(1,s(2)-4);
%%rho = [tmprho(2),tmprho(1),tmprho,tmprho(end), tmprho(end-1)];
%%tmpv = zeros(1,s(2)-4); 
%%%tmpv = 0.5*exp(-200*(x(3:end-2)-0.5).^2);
%%v = [-tmpv(2),-tmpv(1),tmpv,-tmpv(end),-tmpv(end-1)];
%%tmpP = P0(x(3:end-2));
%%%tmpP = ones(1,s(2)-4);
%%P = [tmpP(2),tmpP(1),tmpP,tmpP(end),tmpP(end-1)];
%%
%%clear tmpP tmprho tmpv
%%
%%E = P/(gamma-1) + 0.5*rho.*v.*v;
%%
%%U = [rho;rho.*v;E];
%%
%%
%%%%% Let's Go %%%
%%U1 = zeros(size(U)); % Reserve mem space
%%U1_1 = zeros(size(U));
%%U1_2 = zeros(size(U));
%%t = 1;
%%
%%while t*dt<=0.038
%%
%%% SSP RK order 3
%%q = qf_uniform(U,gamma,theta,dx);
%%U1_1(:,3:end-2) = U(:,3:end-2) - dt*q;
%%U1_1(:,[1 2 end-1 end]) = [1;-1;1].*U1_1(:,[4 3 end-2 end-3]);
%%
%%q1 = qf_uniform(U1_1,gamma,theta,dx);
%%U1_2(:,3:end-2) = 0.75*U(:,3:end-2) + 0.25*U1_1(:,3:end-2) - 0.25*dt*q1;
%%U1_2(:,[1 2 end-1 end]) = [1;-1;1].*U1_2(:,[4 3 end-2 end-3]);
%%
%%q2 = qf_uniform(U1_2,gamma,theta,dx);
%%U1(:,3:end-2) = (1/3)*U(:,3:end-2) + (2/3)*U1_2(:,3:end-2) - (2/3)*dt*q2;
%%U1(:,[1 2 end-1 end]) = [1;-1;1].*U1(:,[4 3 end-2 end-3]);
%%
%%
%%
%%% Loop
%%U = U1;
%%t++;
%%end
%%
%%% Save chock case 
%%
%%rho = U(1,3:end-2);
%%dlmwrite(['../Results/Uniform/',num2str(N),' Nodes/chock_rho.dat'],[rho'],' ')
%%end


%%% Error Analysis
d100 = dlmread(['../Results/Uniform/100 Nodes/chock_rho.dat'],' ');
d200 = dlmread(['../Results/Uniform/200 Nodes/chock_rho.dat'],' ');
d400 = dlmread(['../Results/Uniform/400 Nodes/chock_rho.dat'],' ');
d800 = dlmread(['../Results/Uniform/800 Nodes/chock_rho.dat'],' ');
d1600 = dlmread(['../Results/Uniform/1600 Nodes/chock_rho.dat'],' ');
d3200 = dlmread(['../Results/Uniform/3200 Nodes/chock_rho.dat'],' ');

% A garder
%figure; 
%plot(d100(:,1)',d100(:,2)',d200(:,1)',d200(:,2)',d400(:,1)',d400(:,2)',d800(:,1)',d800(:,2)',d1600(:,1)',d1600(:,2)',d3200(:,1)',d3200(:,2)');
%legend("100","200","400","800","1600","3200");

% Error calcul

% Case N=100
r100 = d100(:,2)';
r200 = d200(:,2)';
r400 = d400(:,2)';

% r100 - r200
tmp = (r200(2:end)+r200(1:end-1))/2;
n1 = tmp(1:2:end) - r100;
%r200 - r400
tmp = (r400(2:end) + r400(1:end-1))/2;
n2 = tmp(1:2:end) - r200;

error100_1 = log2(norm(n1,1)/norm(n2,1));
error100_inf = log2(norm(n1,inf)/norm(n2,inf));

% Case N=200
r800 = d800(:,2)';

%r400 - r800
tmp = (r800(2:end)+r800(1:end-1))/2;
n3 = tmp(1:2:end) - r400;

error200_1 = log2(norm(n2,1)/norm(n3,1));
error200_inf = log2(norm(n2,inf)/norm(n3,inf));
%plot(d400(:,1)',r400,d400(:,1)',tmp(1:2:end),d400(:,1)',abs(n3));legend("original 400","interpolate 800","erreurs")

% Case N=400
r1600 = d1600(:,2)';

%r800 - r1600
tmp = (r1600(2:end) + r1600(1:end-1))/2;
n4 = tmp(1:2:end) - r800;

error400_1 = log2(norm(n3,1)/norm(n4,1));
error400_inf = log2(norm(n3,inf)/norm(n4,inf));


% r1600 - r3200
r3200 = d3200(:,2)';
tmp = (r3200(2:end) + r3200(1:end-1))/2;
n5 = tmp(1:2:end) - r1600;









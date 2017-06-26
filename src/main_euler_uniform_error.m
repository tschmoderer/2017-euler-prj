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


%%% Error Analysis %%%
r100 = dlmread(['../Results/Uniform/100 Nodes/chock_rho.dat'],' ',0,1);
r200 = dlmread(['../Results/Uniform/200 Nodes/chock_rho.dat'],' ',0,1);
r400 = dlmread(['../Results/Uniform/400 Nodes/chock_rho.dat'],' ',0,1);
r800 = dlmread(['../Results/Uniform/800 Nodes/chock_rho.dat'],' ',0,1);
r1600 = dlmread(['../Results/Uniform/1600 Nodes/chock_rho.dat'],' ',0,1);
r3200 = dlmread(['../Results/Uniform/3200 Nodes/chock_rho.dat'],' ',0,1);




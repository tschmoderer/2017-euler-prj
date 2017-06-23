%----------------------------------------------------------%
%-- FUNCTION MAIN_EULER_NON_UNIFORM --%
% 
%	Main routine of this project. 
% The Nodes Distribution will not be uniform
%	In : 
%			- N : interger specify the number of nodes
% Out : 
%			- If you correctly create the directories (see README), the function will create 
%				many data files : 
%					+ data/dt.dat : specify the timestep used
%					+ data/[velocity,pressure,sound,energy,density]/[Number].dat : give one on this propreties on each nodes at the [Number] timestep
%	
%	Author : 
% 	- Timothée Schmoderer
%
% TODO : 
%   - A bit of optimisation 
% 	- Find cfl number that fit better
%   
%		INSA de Rouen Normandie 2017	
% 		Universität zu Köln 2017
%		
%----------------------------------------------------------%

function main_euler_non_uniform(N)
warning('off','all')

% Constantes
a = 0;
b = 1;
theta = 1.5;
gamma = 1.4;
T = 0.1;
[x dx] = construct_nodes(a,b,N);
cfl = 0.437/23;
dt = cfl*min(dx);
dlmwrite('../data/dt.dat',dt);
s = size(x);
niter = ceil(T/dt);

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

print(['../img/initial_condition_',num2str(N),'_Nodes.png'],"-dpng");
close all;

%%% Let's Go %%%
U1 = zeros(size(U)); % Reserve mem space
U1_1 = zeros(size(U));
U1_2 = zeros(size(U));

for t = 1:niter 

% SSP RK order 3
q = qf_non_uniform(U,gamma,theta,dx);
U1_1(:,3:end-2) = U(:,3:end-2) - dt*q;
U1_1(:,[1 2 end-1 end]) = [1;-1;1].*U1_1(:,[4 3 end-2 end-3]);

q1 = qf_non_uniform(U1_1,gamma,theta,dx);
U1_2(:,3:end-2) = 0.75*U(:,3:end-2) + 0.25*U1_1(:,3:end-2) - 0.25*dt*q1;
U1_2(:,[1 2 end-1 end]) = [1;-1;1].*U1_2(:,[4 3 end-2 end-3]);

q2 = qf_non_uniform(U1_2,gamma,theta,dx);
U1(:,3:end-2) = (1/3)*U(:,3:end-2) + (2/3)*U1_2(:,3:end-2) - (2/3)*dt*q2;
U1(:,[1 2 end-1 end]) = [1;-1;1].*U1(:,[4 3 end-2 end-3]);

rho = U(1,3:end-2);
v = U(2,3:end-2)./rho;
P = (gamma-1)*(U(3,3:end-2) - 0.5*rho.*v.*v);
c = speedofsound(U,gamma);

% Loop
U = U1;
if sum(imag(c) > 0) >0 % in case of instability of the method, this criterion will stopes the loop
break;
end

% Save chock case 
if (t*dt <= 0.038 dt*(t+1) >0.038)
plot(x(3:end-2),rho,'r');
title(['rho,  t = ',num2str(t*dt)]);
print(['../img/chock_',num2str(N),'_Nodes.png'],"-dpng");
end
if (t*dt > 0.045)
close all;
end

dlmwrite(['../data/sound/',num2str(t),'.dat'],[x(3:end-2)' c(3:end-2)'],' ')
dlmwrite(['../data/pressure/',num2str(t),'.dat'],[x(3:end-2)' P'],' ')
dlmwrite(['../data/velocity/',num2str(t),'.dat'],[x(3:end-2)' v'],' ')
dlmwrite(['../data/density/',num2str(t),'.dat'],[x(3:end-2)' rho'],' ')
dlmwrite(['../data/energy/',num2str(t),'.dat'],[x(3:end-2)' U(3,3:end-2)'],' ')
end
end % end function

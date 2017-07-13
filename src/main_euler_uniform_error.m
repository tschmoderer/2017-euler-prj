warning('off','all')
clc
clear all 
close all 

% Initialsation
N = [100:200:22000];
N = 100:200:1000;
T = 0.1;
niter = 1000;
tmp = zeros(1,length(N));
error = 'error_2';
i = 1;
for n=N
tic;
data = initial(n,T,error);
dx = data.dx;
theta = data.theta;
gamma = data.gamma;
U = data.U;
cfl = data.cfl;
x = data.x;
bound = data.bound;

% U at the next time step
U1 = zeros(size(U));
% Reserve memory space for the RK method
U1_1 = zeros(size(U));
U1_2 = zeros(size(U));

t = 0;
dt = dx/55;

while t/dt < niter
	% SSP RK order 3
	q = qf_uniform(U,gamma,theta,dx,cfl) - source(U,gamma,error);
	U1_1(:,3:end-2) = U(:,3:end-2) - dt*q;
	U1_1 = boundary(U1_1,bound);

	q1 = qf_uniform(U1_1,gamma,theta,dx,cfl) - source(U,gamma,error);
	U1_2(:,3:end-2) = 0.75*U(:,3:end-2) + 0.25*U1_1(:,3:end-2) - 0.25*dt*q1;
	U1_2 = boundary(U1_2,bound);

	q2 = qf_uniform(U1_2,gamma,theta,dx,cfl) - source(U,gamma,error);
	U1(:,3:end-2) = (1/3)*U(:,3:end-2) + (2/3)*U1_2(:,3:end-2) - (2/3)*dt*q2;
	U1 = boundary(U1,bound);

	rho = U(1,3:end-2);

	% Loop
	U = U1;
	
	t = t + dt;
end
genvarname(['rho',num2str(n)]);
genvarname(['rhoEx',num2str(n)]);
genvarname(['e',num2str(n)]);
eval(['rho' num2str(n) '= rho;']);
eval(['rhoEx' num2str(n) '= rhoEx(x,t-dt,error);']);
eval(['e1_', num2str(n), '= norm(rho',num2str(n),' - rhoEx',num2str(n),',1);']);
eval(['taberr1(i) = e1_' num2str(n) ';']);
eval(['e2_', num2str(n), '= norm(rho',num2str(n),' - rhoEx',num2str(n),',2);']);
eval(['taberr2(i) = e2_' num2str(n) ';']);
eval(['eInf_', num2str(n), '= norm(rho',num2str(n),' - rhoEx',num2str(n),',inf);']);
eval(['taberrInf(i) = eInf_' num2str(n) ';']);
eval('time(i) = toc;');
i = i+1;
end

figure;
plot(log(N),log(taberr),'*');
p=polyfit(log(N),log(taberr),1);
x = linspace(4,10,1000);
y = polyval(p,x);
hold on 
plot(x,y,'r');
plot(x,-2*x,'g');
legend('Error',['log(err) = ',num2str(p(1)),' * log(N) + ',num2str(p(2))],'Theoric : log(err) = -2*log(N)');
title('Error analysis for case 2');

time

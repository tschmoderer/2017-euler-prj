warning('off','all')
clc
clear all
close all

% Initialsation
N = 400;
T = 0.1;
data = initial(N,T,"riemann","wall");

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
dt = 0;
while t*dt < T

	% SSP RK order 3
	[q dt] = qf_uniform(U,gamma,theta,dx,cfl);
	U1_1(:,3:end-2) = U(:,3:end-2) - dt*q;
	U1_1 = boundary(U1_1,bound);

	[q1 dt] = qf_uniform(U1_1,gamma,theta,dx,cfl);
	U1_2(:,3:end-2) = 0.75*U(:,3:end-2) + 0.25*U1_1(:,3:end-2) - 0.25*dt*q1;
	U1_2 = boundary(U1_2,bound);

	[q2 dt] = qf_uniform(U1_2,gamma,theta,dx,cfl);
	U1(:,3:end-2) = (1/3)*U(:,3:end-2) + (2/3)*U1_2(:,3:end-2) - (2/3)*dt*q2;
	U1 = boundary(U1,bound);

	rho = U(1,3:end-2);
	v = U(2,3:end-2)./rho;
	P = (gamma-1)*(U(3,3:end-2) - 0.5*rho.*v.*v);
	c = speedofsound(U(:,3:end-2),gamma);
	M = v./c;

	% Loop
	U = U1;

	if sum(imag(c) > 0) > 0 % in case of instability of the method, this criterion will stop the loop
		break;
	end
	
	plot(x,rho,'r');
	title(['rho,  t = ',num2str(t*dt)]);
	drawnow
	
	t++;
end

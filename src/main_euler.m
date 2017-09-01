warning('off','all')

clc
clear all
close all

% Initialsation
N = 6400;
a = 0;
b = 1;
trial = 'blast';
nodes = 'uniform';

data = initial(N,a,b,trial,nodes);

T = data.tshock * 1;
dx = data.dx;
theta = data.theta;
gamma = data.gamma;
U = data.U;
cfl = data.cfl;
x = data.x;
bound = data.bound;

rho = U(1,3:end-2);
v = U(2,3:end-2)./rho;
P = (gamma-1)*(U(3,3:end-2) - 0.5*rho.*v.*v);
c = speedofsound(U(:,3:end-2),gamma);
E = U(3,3:end-2);
M = abs(v)./c;

fO = figure;
plot(x,zeros(size(x)),'*')
line([a a],[0 1],'Color','blue')
line([b b],[0 1],'Color','blue')
line([a b],[0 0],'Color','red')
ylim([0 0.5])
title('Discretization of Omega')

fP = figure;
plot(x,P)
xlabel('x')
ylabel('P')
title('Presure at t = 0')

fv = figure;
plot(x,v)
xlabel('x')
ylabel('u')
title('Velocity at t = 0')

fr = figure;
plot(x,rho)
xlabel('x')
ylabel('rho')
title('Density at t = 0')

fE = figure;
plot(x,E)
xlabel('x')
ylabel('E')
title('Energy at t = 0')

fc = figure;
plot(x,c)
xlabel('x')
ylabel('c')
title('Speed of sound at t = 0')

fM = figure;
plot(x,M)
xlabel('x')
ylabel('M')
title('Mach number at t = 0')

pause;
close all;


% U at the next time step
U1 = zeros(size(U));
% Reserve memory space for the RK method
U1_1 = zeros(size(U));
U1_2 = zeros(size(U));

dt = 0;
time = 0;


while time < T
	% SSP RK order 3
	[q, dt] = qf(U,gamma,theta,dx,cfl);
	U1_1(:,3:end-2) = U(:,3:end-2) - dt*q;
	U1_1 = boundary(U1_1,bound);

	q1 = qf(U1_1,gamma,theta,dx,cfl);
	U1_2(:,3:end-2) = 0.75*U(:,3:end-2) + 0.25*U1_1(:,3:end-2) - 0.25*dt*q1;
	U1_2 = boundary(U1_2,bound);

	q2 = qf(U1_2,gamma,theta,dx,cfl);
	U1(:,3:end-2) = (1/3)*U(:,3:end-2) + (2/3)*U1_2(:,3:end-2) - (2/3)*dt*q2;
	U1 = boundary(U1,bound);

	% All the quantities we are interested in
	rho = U(1,3:end-2);
	v = U(2,3:end-2)./rho;
	P = (gamma-1)*(U(3,3:end-2) - 0.5*rho.*v.*v);
	c = speedofsound(U(:,3:end-2),gamma);
	E = U(3,3:end-2);
	M = abs(v)./c;

	% Loop
	U = U1;

	if sum(imag(c) > 0) > 0 % in case of instability of the method, this criterion will stop the loop
		error('La simulation est instable');
  end
  
	plot(x,rho,'b');
	axis([a b 0 inf]);
	xlabel('x')
	ylabel('rho')
	title(['Density',data.title,num2str(time)]);
	drawnow
	
	time = time + dt;
end
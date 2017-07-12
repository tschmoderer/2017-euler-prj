warning('off','all')
clc
clear all
close all

% Initialsation
N = 400;
T = 10;
data = initial(N,T,'sedov');

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
E = U(3,3:end-2);


% U at the next time step
U1 = zeros(size(U));
% Reserve memory space for the RK method
U1_1 = zeros(size(U));
U1_2 = zeros(size(U));

t = 0;

idx = find(0.5-200*dx < x & x < 0.5+200*dx);
range = unique([1:10:idx(1) idx idx(end):10:length(x)]);
range = 1:length(x);
r = x(find(0.5 <= x(range)))- 0.5;
angle = [0:0.01:2*pi]';
z = P(find(0.5 <= x(range) ));

rr = r.*ones(size(angle,1),size(r,2));
angleangle = angle.*ones(size(angle,1),size(r,2));
zz = z.*ones(size(angle,1),size(r,2));
[xx, yy] = pol2cart(angleangle,rr);

while t < T
	% SSP RK order 3
	[q, dt] = qf_uniform(U,gamma,theta,dx,cfl);
	U1_1(:,3:end-2) = U(:,3:end-2) - dt*q;
	U1_1 = boundary(U1_1,bound);

	[q1] = qf_uniform(U1_1,gamma,theta,dx,cfl);
	U1_2(:,3:end-2) = 0.75*U(:,3:end-2) + 0.25*U1_1(:,3:end-2) - 0.25*dt*q1;
	U1_2 = boundary(U1_2,bound);

	[q2] = qf_uniform(U1_2,gamma,theta,dx,cfl);
	U1(:,3:end-2) = (1/3)*U(:,3:end-2) + (2/3)*U1_2(:,3:end-2) - (2/3)*dt*q2;
	U1 = boundary(U1,bound);

	% All the quantiies we are interested in
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
	
	z = rho(find(0.5 <= x(range) ));
	zz = z.*ones(size(angle,1),size(r,2));
	h = mesh(xx,yy,zz);
	xlabel('x')
	ylabel('y')
	zlabel('Pressure')
	title(['Explosion at t = ',num2str(t)]);
	drawnow
	if t <= data.tshock && t+dt > data.tshock
		print(['../Report/img/instance_of_sedov_3D.png'],'-dpng')
	end
	t=t+dt;
end
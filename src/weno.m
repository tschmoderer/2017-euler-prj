%----------------------------------------------------------%
%-- PRG WENO --%
%
% Implementation of a WENO 5 method to get reference solutions
%
%	Author : 
% 	- Timothée Schmoderer
%
%		INSA de Rouen Normandie 2017	
% 		Universität zu Köln 2017
%		
%----------------------------------------------------------% 

clc
clear
close all

%Initialisation
a = 0;
b = 1;
l = b-a;
g = 1.4;
T = 0.178;
cfl = 1;
N = 16000;
dx = 1/N;
x = [a+dx/2:dx:b-dx/2];
xG = [x(1)-3*dx x(1)-2*dx x(1)-dx x x(end)+dx x(end)+2*dx x(end)+3*dx];

%% SHU
%P0 = zeros(size(x));
%rho0 = zeros(size(x));
%u0 = zeros(size(x));
%rho0(find(a < x & x < 0.125*l)) = 3.857143;
%rho0(find(0.125*l <= x & x < b)) = 1+0.2*sin(20*pi*x(find(0.125 <= x & x < 1)));
%P0(find(a < x & x < 0.125*l)) = 31/3;
%P0(find(0.125*l <= x & x < b)) = 1.0;
%u0(find(a < x & x < 0.125*l)) = 2.629369;
%u0(find(0.125*l <= x & x < b)) = 0.0;		


% Blast
P0 = zeros(size(x));
P0(find(a < x & x < 0.1*l)) = 1000;
P0(find(0.1*l < x & x < 0.9*l)) = 0.01;
P0(find(0.9*l < x & x < b)) = 100;
rho0 = ones(1,length(x));
u0 = zeros(1,length(x)); 

%% Sedov
%r = 3.5*dx;
%m = (a+b)/2;
%P0 = 10^(-5)*ones(size(x));
%%test 
%P0 = 10^(0)*ones(size(x));
%idx = find(m-r < x & x < m+r);
%P0(idx) = 0.4*ones(size(idx));
%%test 
%P0(idx) = 4000*ones(size(idx));
%rho0 = ones(size(x));
%u0 = zeros(size(x));
%tshock = 0.50;

E0 = P0/(g-1)+0.5*rho0.*u0.*u0;

U = zeros(3,length(xG));
U(:,4:end-3) = [rho0;rho0.*u0;E0];

% Conditions aux bords de type mur
U(:,[1 2 3 end-2 end-1 end]) = [1;-1;1].*U(:,[6 5 4 end-3 end-4 end-5]);

% In out Shu
%U(:,[1 2 3]) = [3.857143;10.142;39.167].*ones(3,3);
%U(:,[end-2 end-1 end]) = U(:,[end-3 end-4 end-5]);

U1_1 = zeros(size(U));
U1_2 = zeros(size(U));
U1 = zeros(size(U));

time = 0;
dt = dx/100;
k = 0;
niter = ceil(T/dt);
dt = T/niter;

while k < niter
time = time + dt;
k++;

% SSP RK order 3 
[q] = qf_weno(U,g,dx,cfl); 
U1_1(:,4:end-3) = U(:,4:end-3) - dt*q; 
U1_1(:,[1 2 3 end-2 end-1 end]) = [1;-1;1].*U1_1(:,[6 5 4 end-3 end-4 end-5]); 
%U1_1(:,[1 2 3]) = [3.857143;10.142;39.167].*ones(3,3);
%U1_1(:,[end-2 end-1 end]) = U1_1(:,[end-3 end-4 end-5]);

[q1] = qf_weno(U1_1,g,dx,cfl); 
U1_2(:,4:end-3) = 0.75*U(:,4:end-3) + 0.25*U1_1(:,4:end-3) - 0.25*dt*q1; 
U1_2(:,[1 2 3 end-2 end-1 end]) = [1;-1;1].*U1_2(:,[6 5 4 end-3 end-4 end-5]);
%U1_2(:,[1 2 3]) = [3.857143;10.142;39.167].*ones(3,3);
%U1_2(:,[end-2 end-1 end]) = U1_2(:,[end-3 end-4 end-5]);

[q2] = qf_weno(U1_2,g,dx,cfl); 
U1(:,4:end-3) = (1/3)*U(:,4:end-3) + (2/3)*U1_2(:,4:end-3) - (2/3)*dt*q2; 
U1(:,[1 2 3 end-2 end-1 end]) = [1;-1;1].*U1(:,[6 5 4 end-3 end-4 end-5]);
%U1(:,[1 2 3]) = [3.857143;10.142;39.167].*ones(3,3);
%U1(:,[end-2 end-1 end]) = U1(:,[end-3 end-4 end-5]);

U = U1;

%% All the quantities we are interested in
rho = U(1,4:end-3);
v = U(2,4:end-3)./rho;
c = speedofsound(U(:,4:end-3),g);

if sum(imag(c) > 0) > 0 % in case of instability of the method, this criterion will stop the loop
	error('La simulation est instable');
end

if time > 0.175
plot(x,rho);
title(num2str(time))
drawnow
end
end

xref = x;
rref = U(1,4:end-3);
uref = U(2,4:end-3)./rref;
%plot(xref,rref,'ro');
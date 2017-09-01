warning('off','all')
clc
clear all 
close all

%----------------------------------------------------------%
%-- PRG WENO_ERROR --%
%
% Compute the convergence rate of the method
%
%	Author : 
% 	- Timothée Schmoderer
%
%		INSA de Rouen Normandie 2017	
% 		Universität zu Köln 2017
%		
%----------------------------------------------------------% 

% Initialsation
N = [20:20:400];
a = 0;
b = 1;

niter = 100;
a = 0;
b = 1;
l = b-a;
g = 1.4;
T = 0.2;
cfl = 1;

tmp = zeros(1,length(N));
svg = 0; % 1 : to save result

error = 'error_1';

i = 1;
for n=N
	tic;
	dx = 1/n;
	x = [a+dx/2:dx:b-dx/2];
	xG = [x(1)-3*dx x(1)-2*dx x(1)-dx x x(end)+dx x(end)+2*dx x(end)+3*dx];
	
% ERROR 1
	rho0 = 1 + 0.2*sin(2*pi*x);
	P0 = ones(size(x));
	u0 = ones(size(x));
	
	E0 = P0/(g-1)+0.5*rho0.*u0.*u0;
	U = zeros(3,length(xG));
	U(:,4:end-3) = [rho0;rho0.*u0;E0];

	% Conditions aux bords de type periodic
	U(:,[1 2 3 end-2 end-1 end]) = U(:,[end-5 end-4 end-3 4 5 6]);

	U1_1 = zeros(size(U));
	U1_2 = zeros(size(U));
	U1 = zeros(size(U));

	t = 0;
	dt = min(dx)/1000;
	m=0;
	while t/dt < niter
		% SSP RK order 3 
		[q] = qf_weno(U,g,dx,cfl); 
		U1_1(:,4:end-3) = U(:,4:end-3) - dt*q;
		U1_1(:,[1 2 3 end-2 end-1 end]) = U1_1(:,[end-5 end-4 end-3 4 5 6]); 
		 
		[q1] = qf_weno(U1_1,g,dx,cfl); 
		U1_2(:,4:end-3) = 0.75*U(:,4:end-3) + 0.25*U1_1(:,4:end-3) - 0.25*dt*q1; 
		U1_2(:,[1 2 3 end-2 end-1 end]) = U1_2(:,[end-5 end-4 end-3 4 5 6]);
		 
		[q2] = qf_weno(U1_2,g,dx,cfl); 
		U1(:,4:end-3) = (1/3)*U(:,4:end-3) + (2/3)*U1_2(:,4:end-3) - (2/3)*dt*q2; 
		U1(:,[1 2 3 end-2 end-1 end]) = U1(:,[end-5 end-4 end-3 4 5 6]);

		% Loop
		U = U1;
		t = t + dt;
		
		rho = U(1,4:end-3);
	end
	eval('time(i) = toc;');
	rho = U(1,4:end-3);
	genvarname(['rho',num2str(n)]);
	genvarname(['rhoEx',num2str(n)]);
	genvarname(['e',num2str(n)]);
	eval(['rho' num2str(n) '= rho;']);
	eval(['rhoEx' num2str(n) '= rhoEx(x,t,error);']);
	eval(['e1_', num2str(n), '= norm(rho',num2str(n),' - rhoEx',num2str(n),',1);']);
	eval(['taberr1(i) = e1_' num2str(n) ';']);
	eval(['e2_', num2str(n), '= norm(rho',num2str(n),' - rhoEx',num2str(n),',2);']);
	eval(['taberr2(i) = e2_' num2str(n) ';']);
	eval(['eInf_', num2str(n), '= norm(rho',num2str(n),' - rhoEx',num2str(n),',inf);']);
	eval(['taberrInf(i) = eInf_' num2str(n) ';']);
	i = i+1;
end

f1 = figure;
plot(log(N),log(taberr1),'*');
p=polyfit(log(N),log(taberr1),1);
x = linspace(3,6.5,1000);
y = polyval(p,x);
axis([2 7])
hold on 
plot(x,y,'r');
plot(x,-5*x,'g');
hold off
legend('Error',['log(err) = ',num2str(p(1)),' * log(N) + ',num2str(p(2))],'Theoric : log(err) = -5*log(N)');
title(['Error analysis of case 1 for the L1 norm on a uniform mesh']);

f2 = figure;
plot(log(N),log(taberr2),'*');
p=polyfit(log(N),log(taberr2),1);
x = linspace(4,11,1000);
y = polyval(p,x);
hold on 
plot(x,y,'r');
plot(x,-5*x,'g');
hold off
legend('Error',['log(err) = ',num2str(p(1)),' * log(N) + ',num2str(p(2))],'Theoric : log(err) = -5*log(N)');
title('Error analysis of case 1 for the L2 norm on a uniform mesh');

fInf = figure;
plot(log(N),log(taberrInf),'*');
p=polyfit(log(N),log(taberrInf),1);
x = linspace(4,11,1000);
y = polyval(p,x);
hold on 
plot(x,y,'r');
plot(x,-5*x,'g');
hold off
legend('Error',['log(err) = ',num2str(p(1)),' * log(N) + ',num2str(p(2))],'Theoric : log(err) = -5*log(N)');
title('Error analysis of case 1 for the LInf norm on a uniform mesh');

fT = figure;
plot(N,time,'o');
xlabel('# of nodes');
ylabel('Time in s.');
title(['Execution time for ',num2str(niter),' iterations on a uniform mesh']);

if svg
	output = ['../Results/Error/WENO/'];
	print(f1,[output,'error_L1.png'],'-dpng');
	print(f2,[output,'error_L2.png'],'-dpng');
	print(fInf,[output,'error_LInf.png'],'-dpng');
	print(fT,[output,'time.png'],'-dpng');
end
%----------------------------------------------------------%
%-- FUNCTION MAIN_EULER_UNIFORM --%
% 
%	Main routine of this project. 
%
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

function main_euler_uniform(N,trial)
	warning('off','all')
	clc
	close all

	% Initialsation
	T = 0;
	data = initial(N,T,trial);

	dx = data.dx;
	theta = data.theta;
	gamma = data.gamma;
	U = data.U;
	cfl = 0.5*data.cfl;
	x = data.x;
	T = data.tshock * 2;
	bound = data.bound;

	rho = U(1,3:end-2);
	v = U(2,3:end-2)./rho;
	P = (gamma-1)*(U(3,3:end-2) - 0.5*rho.*v.*v);
	c = speedofsound(U(:,3:end-2),gamma);
	E = U(3,3:end-2);
	M = abs(v)./c;

	fO = figure('visible','off');
	 plot(x,zeros(size(x)),'*')
	 line([data.a data.a],[0 1],'Color','blue')
	 line([data.b data.b],[0 1],'Color','blue')
	 line([data.a data.b],[0 0],'Color','red')
	 ylim([0 0.5])
	 title('Discretization of Omega')

	fP = figure('visible','off');
		plot(x,P)
		xlabel('x')
		ylabel('P')
		title('Presure at t = 0')

	fv = figure('visible','off');
		plot(x,v)
		xlabel('x')
		ylabel('u')
		title('Velocity at t = 0')

	fr = figure('visible','off');
		plot(x,rho)
		xlabel('x')
		ylabel('rho')
		title('Density at t = 0')

	fE = figure('visible','off');
		plot(x,E)
		xlabel('x')
		ylabel('E')
		title('Energy at t = 0')

	fc = figure('visible','off');
		plot(x,c)
		xlabel('x')
		ylabel('c')
		title('Speed of sound at t = 0')
		
	fM = figure('visible','off');
		plot(x,M)
		xlabel('x')
		ylabel('M')
		title('Mach number at t = 0')
		
	output = ['../Results/Uniform/',data.dirRes,'/',num2str(N),' Nodes/initial/initial_',trial];
	print(fO,[output,'_omega.png'],'-dpng');
	print(fP,[output,'_pressure.png'],'-dpng');
	print(fv,[output,'_velocity.png'],'-dpng');
	print(fr,[output,'_density.png'],'-dpng');
	print(fE,[output,'_energy.png'],'-dpng');
	print(fc,[output,'_sound.png'],'-dpng');
	print(fM,[output,'_mach.png'],'-dpng');
	dlmwrite(['../Results/Uniform/',data.dirRes,'/',num2str(N),' Nodes/data/mesh.dat'],x');

	close all;

	% U at the next time step
	U1 = zeros(size(U));
	% Reserve memory space for the RK method
	U1_1 = zeros(size(U));
	U1_2 = zeros(size(U));

	dt = 0;
	time = 0;
	k = 0;

	while time < T
	% 	% Euler 
	% 	[q, dt] = qf_uniform(U,gamma,theta,dx,cfl);
	% 	U1(:,3:end-2) = U(:,3:end-2) - dt*q;
	% 	U1 = boundary(U1,bound);

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
			break;
		end
		
		dlmwrite (['../Results/Uniform/',data.dirRes,'/',num2str(N),' Nodes/data/time.dat'],time,' ',"-append");
		dlmwrite (['../Results/Uniform/',data.dirRes,'/',num2str(N),' Nodes/data/density/',num2str(k),'.dat'],rho',' ');
		dlmwrite (['../Results/Uniform/',data.dirRes,'/',num2str(N),' Nodes/data/velocity/',num2str(k),'.dat'],v',' ');
		dlmwrite (['../Results/Uniform/',data.dirRes,'/',num2str(N),' Nodes/data/pressure/',num2str(k),'.dat'],P',' ');
		dlmwrite (['../Results/Uniform/',data.dirRes,'/',num2str(N),' Nodes/data/energy/',num2str(k),'.dat'],E',' ');
		dlmwrite (['../Results/Uniform/',data.dirRes,'/',num2str(N),' Nodes/data/mach/',num2str(k),'.dat'],M',' ');
		dlmwrite (['../Results/Uniform/',data.dirRes,'/',num2str(N),' Nodes/data/sound/',num2str(k),'.dat'],c',' ');
%		plot(x,rho,'b');
%		axis([data.a data.b 0 inf]);
%		xlabel('x')
%		ylabel('rho')
%		title(['Density',data.title,num2str(time)]);
%		drawnow
		 
			
		if time < data.tshock & time + dt > data.tshock
			fr = figure('visible','off');
			plot(x,rho,'b');
			axis([data.a data.b 0 inf]);
			xlabel('x')
			ylabel('rho')
			title(['Density',data.title,num2str(time)]);
			
			fu = figure('visible','off');
			plot(x,v,'b');
			axis([data.a data.b 0 inf]);
			xlabel('x')
			ylabel('u')
			title(['Velocity',data.title,num2str(time)]);
		
			fP = figure('visible','off');
			plot(x,P,'b');
			axis([data.a data.b 0 inf]);
			xlabel('x')
			ylabel('P')
			title(['Pressure',data.title,num2str(time)]);

			fE = figure('visible','off');
			plot(x,E,'b');
			axis([data.a data.b 0 inf]);
			xlabel('x')
			ylabel('E')
			title(['Energy',data.title,num2str(time)]);	

			fM = figure('visible','off');
			plot(x,M,'b');
			axis([data.a data.b 0 inf]);
			xlabel('x')
			ylabel('M')
			title(['Mach number',data.title,num2str(time)]);		

			fc = figure('visible','off');
			plot(x,c,'b');
			axis([data.a data.b 0 inf]);
			xlabel('x')
			ylabel('c')
			title(['Speed of sound',data.title,num2str(time)]);	
			drawnow
		
			output = ['../Results/Uniform/',data.dirRes,'/',num2str(N),' Nodes/shock/shock_'];
			print(fP,[output,'_pressure.png'],'-dpng');
			print(fu,[output,'_velocity.png'],'-dpng');
			print(fr,[output,'_density.png'],'-dpng');
			print(fE,[output,'_energy.png'],'-dpng');
			print(fc,[output,'_sound.png'],'-dpng');
			print(fM,[output,'_mach.png'],'-dpng');
			close all
		end

		time = time + dt;
		k++;
	end
end

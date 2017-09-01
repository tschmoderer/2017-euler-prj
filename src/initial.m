%----------------------------------------------------------%
%-- FUNCTION INITIAL --%
%
% Get all initial value in function of the domain, the case the user want ...
%
%	In : 
%	  	- N : the number of cells
%			- a : the left boundary 
% 		- b : the right boundary
%			- initial : the example to be compute
%			- nodes : type of mesh
%
% Out : 
%			- data : a structure containing all the initial data :
%					- cfl : the Courant number 
%					- theta : the parameter in minmod function
%					- gamma : the adiabatic index 
%					- dx : the cell's width
%					- dirRes : the default output directory
%					- xG : All cell's centers
%					- x : cell's centers without ghost cells 
%					- U : the initial vector of state
%					- bound : the tye of boundary conditions
%					- title : the title of the plots 
%					- tshock : a time taht is interesting to look at
%
%	Author : 
% 	- Timothée Schmoderer
%
%   
%		INSA de Rouen Normandie 2017	
% 		Universität zu Köln 2017
%		
%----------------------------------------------------------%

function [data] = initial(N,Nb,a,b,initial,nodes);
	data.cfl = 1;
	data.theta = 1.5;
	data.gamma = 1.4;
	m = 0.5*(a+b);
	l = b-a;

	switch nodes 
		case 'uniform'
			data.dx = l/N;
			data.xG = [a-3*data.dx/2:data.dx:b+3*data.dx/2];
			data.dirRes = 'Uniform/';
		case 'nuniform'
			data.x = lglnodes(N,a,a+l/Nb); 
			for k = 1:Nb-1
			data.x = [data.x lglnodes(N,a+k*l/Nb,a+(k+1)*l/Nb)];
			end
			data.x = unique(data.x);
			
			% Get cells centers
			data.x = 0.5*(data.x(1:end-1)+data.x(2:end));
			
			% Add ghost
			data.xG = [2*a-data.x(2) 2*a-data.x(1) data.x 2*b-data.x(end) 2*b-data.x(end-1)];
			% Get cell's width
			data.dxG = 0.5*data.xG(3:end)-0.5*data.xG(1:end-2);
			data.dxG = [data.xG(2)-data.xG(1) data.dxG data.xG(end)-data.xG(end-1)];
			data.dx = data.dxG(3:end-2);
			data.dirRes = 'Non Uniform/';
		otherwise
			error('This mesh option is not available. Please use one of the following value : ''uniform'' or ''nuniform''.');
	end

	data.x = data.xG(3:end-2);
	data.U = zeros(3,length(data.xG));
	m = 0.5*(a+b);
	l = b-a;

	switch initial 
		case 'sod'
			P0 = zeros(size(data.x));
			P0(find(a < data.x & data.x <= m)) = 1;
			P0(find(m < data.x & data.x <= b)) = 0.1;
			rho0 = zeros(size(data.x));
			rho0(find(a < data.x & data.x <= m)) = 1;
			rho0(find(m < data.x & data.x <= b)) = 0.125;
			v0 = zeros(1,length(data.x));
			data.bound = 'wall';
			data.title = ' for the Sod''s shock tube at t = ';
			data.dirRes = strcat(data.dirRes,'Sod');
			data.tshock = 0.20;
			
		case 'blast'
			P0 = zeros(size(data.x));
			P0(find(a < data.x & data.x < 0.1*l)) = 1000;
			P0(find(0.1*l < data.x & data.x < 0.9*l)) = 0.01;
			P0(find(0.9*l < data.x & data.x < b)) = 100;
			rho0 = ones(1,length(data.x));
			v0 = zeros(1,length(data.x)); 
			data.bound = 'wall';
			data.title = ' for the blast wave at t = ';
			data.dirRes = strcat(data.dirRes,'Blast');
			data.tshock = 0.038;
			
		case 'lax'
			P0 = zeros(size(data.x));
			rho0 = zeros(size(data.x));
			v0 = zeros(size(data.x));
			rho0(find(a < data.x & data.x < m)) = 0.445;
			rho0(find(m <= data.x & data.x < b)) = 0.5;
			P0(find(a < data.x & data.x < m)) = 3.528;
			P0(find(m <= data.x & data.x < b)) = 0.571;
			v0(find(a < data.x & data.x < m)) = 0.698;
			v0(find(m <= data.x & data.x < b)) = 0.0;	
			data.bound = 'in-lax';
			data.title = ' for the Lax shock at t = ';
			data.dirRes = strcat(data.dirRes,'Lax');
			data.tshock = 0.16;
			
		case 'toro'
			P0 = zeros(size(data.x));
			rho0 = zeros(size(data.x));
			v0 = zeros(size(data.x));
			rho0(find(a <= data.x & data.x < 0.1*l)) = 3.8557143;
			rho0(find(0.1*l <= data.x & data.x <= b)) = 1+0.2*sin(5*data.x(find(-4 <= data.x & data.x <= 5)))-0.2*sin(10*data.x(find(-4 <= data.x & data.x <= 5)));
			P0(find(a <= data.x & data.x < 0.1*l)) = 31/3;
			P0(find(0.1*l <= data.x & data.x <= b)) = 1.0;
			v0(find(a <= data.x & data.x < 0.1*l)) = 2.629369;
			v0(find(0.1*l<= data.x & data.x <= b)) = 0.0;		
			data.bound = 'in-out-toro';
			data.title = ' for the variation of the Shu-Osher problem at t = ';
			data.dirRes = strcat(data.dirRes,'Toro');
			data.tshock = 1.8;
		
		case 'shu'
			P0 = zeros(size(data.x));
			rho0 = zeros(size(data.x));
			v0 = zeros(size(data.x));
			rho0(find(a < data.x & data.x < 0.125*l)) = 3.857143;
			rho0(find(0.125*l <= data.x & data.x < b)) = 1+0.2*sin(20*pi*data.x(find(0.125 <= data.x & data.x < 1)));
			P0(find(a < data.x & data.x < 0.125*l)) = 31/3;
			P0(find(0.125*l <= data.x & data.x < b)) = 1.0;
			v0(find(a < data.x & data.x < 0.125*l)) = 2.629369;
			v0(find(0.125*l <= data.x & data.x < b)) = 0.0;		
			data.bound = 'in-out-shu';	
			data.title = ' for the Shu-Osher problem at t = ';
			data.dirRes = strcat(data.dirRes,'Shu-Osher');
			data.tshock = 0.178;
		
		case 'sedov'
			r = 3.5*data.dx;
			idx = find(m-r < data.x & data.x < m+r);
			P0 = 10^(0)*ones(size(data.x));
			P0(idx) = 4000*ones(size(idx));
			rho0 = ones(size(data.x));
			v0 = zeros(size(data.x));
			data.bound = 'wall';
			data.title = ' for the Sedov explosion at t = ';
			data.dirRes = strcat(data.dirRes,'Sedov');
			data.tshock = 0.002;
			
		case 'error_1'
			rho0 = 1 + 0.2*sin(2*pi*data.x);
			P0 = ones(size(data.x));
			v0 = ones(size(data.x));
			data.bound = 'periodic';
			data.dirRes = 'Error/Case 1';
			
		case 'error_2'
			alpha = 2*pi*data.x; 
			rho0 = 2 + 0.1*sin(alpha);
			v0 = ones(size(data.x));
			P0 = (data.gamma - 1)*0.05*(20 + 2*cos(alpha)-sin(alpha));
			data.bound = 'periodic';
			data.dirRes = 'Error/Case 2';
		otherwise 
			error('Your case is not available, please use one of the following value : ''blast, lax, sod, shu, toro, sedov, error_1, error_2'' or implement it yourself');
	end

	E0 = P0/(data.gamma-1) + 0.5*rho0.*v0.*v0;
	data.U(:,3:end-2) = [rho0;rho0.*v0;E0];
	data.U = boundary(data.U,data.bound);
end
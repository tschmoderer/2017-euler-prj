function [data] = initial(N,T,initial);
data.a = 0;
data.b = 1;
data.N = N;
data.T = T;
data.cfl = 1;
data.theta = 1.5;
data.gamma = 1.4;
data.dx = (data.b-data.a)/data.N;
data.xG = [data.a-3*data.dx/2:data.dx:data.b+3*data.dx/2];
data.x = data.xG(3:end-2);
data.U = zeros(3,length(data.xG));

switch initial 
	case 'sod'
		P0 = zeros(size(data.x));
		rho0 = zeros(size(data.x));
		P0(find(0.0 < data.x & data.x <= 0.5)) = 1;
		rho0(find(0.0 < data.x & data.x <= 0.5)) = 1;
		P0(find(0.5 < data.x & data.x <= 1.0)) = 0.1;
		rho0(find(0.5 < data.x & data.x <= 1.0)) = 0.125;
		v0 = zeros(1,length(data.x));
		data.bound = 'wall';
		data.tshock = 0.20;
		
	case 'blast'
		P0 = zeros(size(data.x));
		P0(find(0.0 < data.x & data.x < 0.1)) = 1000;
		P0(find(0.1 < data.x & data.x < 0.9)) = 0.01;
		P0(find(0.9 < data.x & data.x < 1.0)) = 100;
		rho0 = ones(1,length(data.x));
		v0 = zeros(1,length(data.x)); 
		data.bound = 'wall';
		data.tshock = 0.038

	case 'plain'
		P0 = ones(size(data.x));
		rho0 = 1 + 0.2*sin(data.x);
		v0 = ones(size(data.x));
		data.bound = 'periodic';
		data.tshock = 2.0;
		
	case 'lax'
		P0 = zeros(size(data.x));
		rho0 = zeros(size(data.x));
		v0 = zeros(size(data.x));
		rho0(find(0.0 < data.x & data.x < 0.5)) = 0.445;
		rho0(find(0.5 <= data.x & data.x < 1)) = 0.5;
		P0(find(0.0 < data.x & data.x < 0.5)) = 3.528;
		P0(find(0.5 <= data.x & data.x < 1)) = 0.571;
		v0(find(0.0 < data.x & data.x < 0.5)) = 0.698;
		v0(find(0.5 <= data.x & data.x < 1)) = 0.0;	
		data.bound = 'wall';
		data.tshock = 0.16;
		
	case 'toro'
		data.a = -5;
		data.b = 5;
		data.dx = (data.b-data.a)/data.N;
		data.xG = [data.a-3*data.dx/2:data.dx:data.b+3*data.dx/2];
		data.x = data.xG(3:end-2);
		data.U = zeros(3,length(data.xG));
		P0 = zeros(size(data.x));
		rho0 = zeros(size(data.x));
		v0 = zeros(size(data.x));
		rho0(find(-5 <= data.x & data.x < -4)) = 3.8557143;
		rho0(find(-4 <= data.x & data.x <= 5)) = 1+0.2*sin(5*data.x(find(-4 <= data.x & data.x <= 5)));
		P0(find(-5 <= data.x & data.x < -4)) = 31/3;
		P0(find(-4 <= data.x & data.x <= 5)) = 1.0;
		v0(find(-5 <= data.x & data.x < -4)) = 2.629369;
		v0(find(-4 <= data.x & data.x <= 5)) = 0.0;		
		data.bound = 'in-out-toro';
		data.tshock = 1.8;
	
	case 'shu'
		P0 = zeros(size(data.x));
		rho0 = zeros(size(data.x));
		v0 = zeros(size(data.x));
		rho0(find(0 < data.x & data.x < 0.125)) = 3.857143;
		rho0(find(0.125 <= data.x & data.x < 1)) = 1+0.2*sin(20*pi*data.x(find(0.125 <= data.x & data.x < 1)));
		P0(find(0 < data.x & data.x < 0.125)) = 31/3;
		P0(find(0.125 <= data.x & data.x < 1)) = 1.0;
		v0(find(0 < data.x & data.x < 0.125)) = 2.629369;
		v0(find(0.125 <= data.x & data.x < 1)) = 0.0;		
		data.bound = 'in-out-shu';	
		data.tshock = 0.178;
	
	case 'sedov'
		r = 3.5*data.dx;
		c = (data.a + data.b)/2;
		P0 = 10^(-5)*ones(size(data.x));
		idx = find(c-r < data.x & data.x < c+r);
		P0(idx) = (data.gamma)*ones(size(idx));
		rho0 = ones(size(data.x));
		v0 = zeros(size(data.x));
		data.bound = 'wall';
		data.tshock = 0.050;
		
	case 'error_1'
		rho0 = 1 + 0.2*sin(2*pi*data.x);
		P0 = ones(size(data.x));
		v0 = ones(size(data.x));
		data.bound = 'periodic';
		
	case 'error_2'
		alpha = 2*pi*data.x; 
		rho0 = 2 + 0.1*sin(alpha);
		v0 = ones(size(data.x));
		P0 = (data.gamma - 1)*0.05*(20 + 2*cos(alpha)-sin(alpha));
		data.bound = 'periodic';

end

E0 = P0/(data.gamma-1) + 0.5*rho0.*v0.*v0;
data.U(:,3:end-2) = [rho0;rho0.*v0;E0];
data.U = boundary(data.U,data.bound);
end
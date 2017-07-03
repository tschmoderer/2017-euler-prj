function [data] = initial(N,T,initial,bound);
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
data.bound = bound;

switch initial 
	case "sod" 
		P0 = zeros(size(data.x));
		rho0 = zeros(size(data.x));
		P0(find(0.0 < data.x & data.x <= 0.5)) = 1;
		rho0(find(0.0 < data.x & data.x <= 0.5)) = 1;
		P0(find(0.5 < data.x & data.x <= 1.0)) = 0.1;
		rho0(find(0.5 < data.x & data.x <= 1.0)) = 0.125;
		v0 = zeros(1,length(data.x));
		
	case "riemann"
		P0 = zeros(size(data.x));
		P0(find(0.0 < data.x & data.x < 0.1)) = 1000;
		P0(find(0.1 < data.x & data.x < 0.9)) = 0.01;
		P0(find(0.9 < data.x & data.x < 1.0)) = 100;
		rho0 = ones(1,length(data.x));
		v0 = zeros(1,length(data.x)); 

		case "smooth"
	c
	otherwise
		c
end

E0 = P0/(data.gamma-1) + 0.5*rho0.*v0.*v0;
data.U(:,3:end-2) = [rho0;rho0.*v0;E0];
data.U = boundary(data.U,data.bound);
end
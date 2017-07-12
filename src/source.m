function L = source(U,gamma,type)
switch type 
	case 'error_1'
		L1 = zeros(size(U(1,3:end-2)));
		L2 = zeros(size(U(1,3:end-2)));
		L3 = zeros(size(U(1,3:end-2)));
	case 'error_2'
		rho = U(1,3:end-2);
		u = U(2,3:end-2)./rho;
		E = U(3,3:end-2);
		L1 = zeros(size(rho));
		L2 = -(gamma-1)*pi*(2*rho+E-6);
		L3 = L2;
end	
L = [L1;L2;L3];
end
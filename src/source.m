%----------------------------------------------------------%
%-- FUNCTION SOURCE --%
%
% Compute the source term for the convergence analysis
%
%	In : 
%	  	- U : vector of state
%			- gamma : the constant of the gas 
% 		- type : switch the type of source 
%
% Out : 
%			- L : the source term
%
%	Author : 
% 	- Timothée Schmoderer
%
%   
%		INSA de Rouen Normandie 2017	
% 		Universität zu Köln 2017
%		
%----------------------------------------------------------%

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
		otherwise
			L1 = zeros(size(U(1,3:end-2)));
			L2 = zeros(size(U(1,3:end-2)));
			L3 = zeros(size(U(1,3:end-2)));
	end	
	L = [L1;L2;L3];
end
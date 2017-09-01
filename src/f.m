%----------------------------------------------------------%
%-- FUNCTION f --%
%
% Compute the values of the flux vector on each nodes
%
%	In : 
%			- U : the vector of caracteristics
%			- gamma : the constant of gas
% Out : 
%			- y : the fluc function on each nodes
%
%	Author : 
% 	- Timothée Schmoderer
%
%   
%		INSA de Rouen Normandie 2017	
% 		Universität zu Köln 2017
%		
%----------------------------------------------------------%

function y = f(U,gamma)
	% Density
	rho = U(1,:);
	% Velocity
	v = U(2,:)./rho;
	% Energy
	E = U(3,:);
	% Pressure
	P = (gamma-1)*(E-0.5*rho.*v.*v);
	% Flux
	y = U.*v+[zeros(size(P));P;P.*v];
end

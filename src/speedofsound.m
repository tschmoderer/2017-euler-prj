%----------------------------------------------------------%
%-- FUNCTION SPEEDOFSOUND --%
%
% Compute the speed of the sound on each nodes 
%
%	In : 
%			- U : the vector of caracteristics
%			- gamma : the constant of gas
% Out : 
%			- c : the speed of sound on each nodes
%
%	Author : 
% 	- Timothée Schmoderer
%
%   
%		INSA de Rouen Normandie 2017	
% 		Universität zu Köln 2017
%		
%----------------------------------------------------------%

function c = speedofsound(U,gamma)
	% Density
	rho = U(1,:);
	% Velocity
	v = U(2,:)./rho;
	% Energy
	E = U(3,:);
	% Pressure
	P = (gamma-1)*(E-0.5*rho.*v.*v);
	% Speed of sound
	c = sqrt(gamma*P./rho);
end

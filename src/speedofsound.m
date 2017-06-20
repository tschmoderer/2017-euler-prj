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
% density
rho = U(1,:);
v2 = (U(2,:)./rho).^2;
% pressure
P = (gamma-1)*(U(3,:)-0.5*(U(2,:).^2)./rho);
% speed of sound
c = sqrt(gamma*P./rho);
end
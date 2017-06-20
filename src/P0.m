%----------------------------------------------------------%
%-- FUNCTION P0 --%
%
%	Compute the initial pressur on each nodes
% The pressure is discontinuous in x=0.1 and 0.9
% This is why we will get shock waves
%
%	In : 
%			- x : the vector of nodes
%
% Out : 
%			- y : the initial pressure on each nodes
%
%	TODO : 
%			- A bit of optimization
%
%	Author : 
% 	- Timothée Schmoderer
%
%   
%		INSA de Rouen Normandie 2017	
% 		Universität zu Köln 2017
%		
%----------------------------------------------------------%

function y = P0(x)
l = length(x); 
for i = 1:l
z = x(i);
if 0 < z && z < 0.1
y(i) = 10^3;
elseif 0.1 < z && z < 0.9
y(i) = 10^-2;
elseif 0.9 < z && z < 1
y(i) = 10^2;
else 
y(i) = 0;
end
end
end
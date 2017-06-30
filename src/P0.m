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
%			- It is short but we can do better with a loop
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
	y = zeros(size(x));
	y(find(0.0 < x & x < 0.1)) = 1000;
	y(find(0.1 < x & x < 0.9)) = 0.01;
	y(find(0.9 < x & x < 1.0)) = 100;
end

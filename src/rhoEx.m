%----------------------------------------------------------%
%%-- FUNCTION RHOEX --%
%
% Compute the exact solution in the case of manufactured solutions
%
%	In : 
%	  	- x : the mesh
%			- t : the time
% 		- type : switch the solution you want
%
% Out : 
%			- rho : the exact solution at the cell's centers
%
%	Author : 
% 	- Timothée Schmoderer
%
%   
%		INSA de Rouen Normandie 2017	
% 		Universität zu Köln 2017
%		
%----------------------------------------------------------%

function rho = rhoEx(x,t,type)
	switch type
		case 'error_1'
			alpha = 2*pi*(x-t);
			rho = 1 + 0.2*sin(alpha);
		case 'error_2'
			alpha = 2*pi*(x-t);
			rho = 2 + 0.1*sin(alpha);
	end
end
%----------------------------------------------------------%
%-- FUNCTION CONSTRUCT_NODES --%
%
% Compute the mesh when the user want a non uniform nodes distribution 
%
%	In : 
%	  	- a : the left boundary
%			- b : the right boundary
%			- N : Number of nodes in each parts
%
% Out : 
%			- x : cell centers
% 		- dx cells width
%
% 		In the case of the 1D euler gas equation in [0,1], 
%			When initial condition are those for the uniform case
% 		the nodes are compute like this : 
%				Between 0:0.6 : N nodes
%								0.6:0.8 N nodes
%								0.8:1 N nodes
%
% TODO : 
% 		- Do it with a fill
%
%	Author : 
% 	- Timothée Schmoderer
%
%   
%		INSA de Rouen Normandie 2017	
% 		Universität zu Köln 2017
%		
%----------------------------------------------------------%

function [x , dx] = construct_nodes(a,b,N)
% For fun 
%x = sort(rand(1,N));
h1 = 0.6/N; 
h2 = (0.8-0.6)/N;
h3 = (1-0.8)/N;

x = unique([0+h1:h1:0.6 0.6:h2:0.8 0.8:h3:1-h3]);

x = [-x(2) -x(1) x 2-x(end) 2-x(end-1)];
dx = 0.5*x(3:end)-0.5*x(1:end-2);
dx = [x(2)-x(1) dx x(end)-x(end-1)];
end

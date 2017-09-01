%----------------------------------------------------------%
%-- FUNCTION LGLNODES --%
%
% Compute the Legendre - Gauss - Lobato nodes in [a,b]
% Compute the cells centers from this nodes distribution
%
%	In : 
%	  	- N : the number of cells we want 
%			- [a,b] : the domain
%
% Out : 
%			- x : the cell's centers
%
%	Author : 
% 	- Timothée Schmoderer
%
%   
%		INSA de Rouen Normandie 2017	
% 		Universität zu Köln 2017
%		
%----------------------------------------------------------%

function x = lglnodes(N,a,b)
	
	N = N-1;
	P = zeros(N+1,3);
	x = 2;
	
	% First guess
	x0 = [-1 (1-3*(N-1)/(8*(N)^3))*cos(pi*(4*[1:N-1]+1)/(4*(N)+1)) 1]'; 
	
	while max(abs(x-x0)) > eps
		x = x0;

		% Construct the P_n(x)
		P(:,1) = 1;
		P(:,2) = x0;

		for n=2:N-1
		P(:,3) = ((2*n-1)*x0.*P(:,2)-(n-1)*P(:,1))/n;
		P(:,1) = P(:,2);
		P(:,2) = P(:,3);
		end
		P(:,3) = ((2*N-1)*x0.*P(:,2)-(N-1)*P(:,1))/N;

		% Get Pn'
		dP = N*(P(:,end-1)-x0.*P(:,end));%./(1-x0.^2);
		% Get Pn''
		ddP = (2*x0.*dP-N*(N+1)*P(:,end));%./(1-x0.^2);
		% Get Pn'''
		dddP = (2*x0.*ddP-(N*(N+1)-2)*dP);%./(1-x0.^ 2);

		% Apply Hayleys method 
		x0 = x - 2*dP.*ddP./(2*ddP.^2-dP.*dddP);
	end
	
	% Nodes in [a:b]
	x = 0.5*((b-a)*x0' + (a+b)); 
end
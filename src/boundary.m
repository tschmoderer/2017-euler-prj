%----------------------------------------------------------%
%-- FUNCTION BOUNDARY --%
%
% Apply the boundary conditions 
%
%	In : 
%	  	- U : vector of state
%			- bound : the type of boundary we want, can take one of the following value : 'periodic, 'in-out-toro', 'in-out-shu'
%			Default is wall conditions
%
% Out : 
%			- U : the modified vector of state
%
%	Author : 
% 	- Timothée Schmoderer
%
%   
%		INSA de Rouen Normandie 2017	
% 		Universität zu Köln 2017
%		
%----------------------------------------------------------%

function U = boundary(U,bound)
	switch bound 
		case 'periodic' 
			U(:,[1 2 end-1 end]) = U(:,[end-3 end-2 3 4]);	
		case 'in-out-toro'
			U(:,[1 2]) = [3.857143;10.142;39.167].*ones(3,2);
			U(:,[end-1 end]) = U(:,[end-2 end-3]);
		case 'in-out-shu'
			U(:,[1 2]) = [3.857143;10.142;39.167].*ones(3,2);
			U(:,[end-1 end]) = U(:,[end-2 end-3]);
		case 'in-lax'
			U(:,[1 2]) = [0.445;0.31061;8.9284].*ones(3,2);
			U(:,[end-1 end]) = [1;-1;1].*U(:,[end-2 end-3]);
		otherwise % Wall
			U(:,[1 2 end-1 end]) = [1;-1;1].*U(:,[4 3 end-2 end-3]);	
	end 
end
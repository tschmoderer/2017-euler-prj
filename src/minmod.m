%----------------------------------------------------------%
%-- FUNCTION MINMOD --%
%
% Compute the min mod value of three number
%
%	In : 
%	  	- a,b,c : three array of the same size of number
%
% Out : 
%			- y : an array of teh same size as a where each cell is the minmod value  of the same cell in a,b and c
%
%	Author : 
% 	- Timothée Schmoderer
%
%   
%		INSA de Rouen Normandie 2017	
% 		Universität zu Köln 2017
%		
%----------------------------------------------------------%

function y = minmod(a,b,c) 
	y = zeros(size(a));
	% Index where the three numbers are positive
	iM = find(a > 0 & b > 0 & c > 0);
	y(iM) = min(min(a(iM),b(iM)),c(iM));
	% Index where the three numbers are negative
	im = find(a < 0 & b < 0 & c < 0);
	y(im) = max(max(a(im),b(im)),c(im));
end

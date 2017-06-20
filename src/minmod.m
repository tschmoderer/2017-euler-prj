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
s = size(a);
y = zeros(s);
for i=1:s(1)
for j = 1:s(2)
% limit data access
tmpa = a(i,j);
tmpb = b(i,j);
tmpc = c(i,j);
if tmpa > 0 && tmpb > 0 && tmpc > 0
y(i,j) = min([tmpa,tmpb,tmpc]);
elseif tmpa < 0 && tmpb < 0 && tmpc < 0
y(i,j) = max([tmpa,tmpb,tmpc]);
else
y(i,j) = 0;
end
end
end
end
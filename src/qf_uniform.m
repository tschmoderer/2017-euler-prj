%----------------------------------------------------------%
%-- FUNCTION QF_UNIFORM --%
%
% Compute the second memeber of the scheme, namely the approximation of the space derivative
% When the distribution of nodes is uniform.
%
%	In : 
%	  	- U : vector of state
%			- gamma : the constant of the gas 
% 		- theta : the parameters for the minmod methods
%			- dx : size of each computing cell
%
% Out : 
%			- q : the approximation of the spatial derivation in each celle
%
%	Author : 
% 	- Timothée Schmoderer
%
%   
%		INSA de Rouen Normandie 2017	
% 		Universität zu Köln 2017
%		
%----------------------------------------------------------%

function [q dt] = qf_uniform(U,gamma,theta,dx,cfl)
	fU = f(U,gamma);
	c = speedofsound(U,gamma);
	a = abs(U(2,:)./U(1,:)) + c;

	% Compute f+ & f-
	fp = 0.5 * (fU + a.*U);
	fm = 0.5 * (fU - a.*U);

	% Compute df+
	dfp0 = theta*(fp(:,2:end-1) - fp(:,1:end-2)); % Option 1
	dfp1 = (fp(:,3:end) - fp(:,1:end-2))/2; % Option 2
	dfp2 = theta*(fp(:,3:end) - fp(:,2:end-1)); % Option 3

	dfp = minmod(dfp0,dfp1,dfp2);

	% Compute df-
	dfm0 = theta*(fm(:,2:end-1) - fm(:,1:end-2)); % Option 1
	dfm1 = (fm(:,3:end) - fm(:,1:end-2))/2; % Option 2
	dfm2 = theta*(fm(:,3:end) - fm(:,2:end-1)); % Option 3

	dfm = minmod(dfm0,dfm1,dfm2);

	fE = fp(:,2:end-1) + 0.5*dfp;
	fW = fm(:,2:end-1) - 0.5*dfm;

	% Compute f+0.5 and f-0.5
	fphalf = fE(:,2:end-1) + fW(:,3:end);
	fmhalf = fE(:,1:end-2) + fW(:,2:end-1);

	% Compute second member 
	q = (fphalf - fmhalf)/dx;
	dt = cfl*dx/max(a);
end

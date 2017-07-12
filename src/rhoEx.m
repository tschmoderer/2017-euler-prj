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
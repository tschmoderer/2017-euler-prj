% In the full U matrix with ghost point

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
	otherwise % Wall
		U(:,[1 2 end-1 end]) = [1;-1;1].*U(:,[4 3 end-2 end-3]);	
end 
end
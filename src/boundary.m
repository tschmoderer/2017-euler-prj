% In the full U matrix with ghost point

function U = boundary(U,bound)
switch bound 
	case "periodic" 
		U(:,[1 2 end-1 end]) = U(:,[end-2 end-2 3 4]);	
	otherwise % Wall
		U(:,[1 2 end-1 end]) = [1;-1;1].*U(:,[4 3 end-2 end-3]);	
end 
end
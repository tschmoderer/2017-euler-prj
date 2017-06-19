function y = P0(x)
% smooth 
%y = 1000*sin(2*pi*x).^2;

%% P discontinuous
l = length(x); 
for i = 1:l
z = x(i);
if 0 < z && z < 0.1
y(i) = 10^3;
elseif 0.1 < z && z < 0.9
y(i) = 10^-2;
elseif 0.9 < z && z < 1
y(i) = 10^2;
else 
y(i) = 0;
end
end
end
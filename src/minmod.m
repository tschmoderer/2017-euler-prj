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
function F = getData()
C=[0, 4:8:76, 90];
gamma = [-76:8:-4, 0, 4:8:76];
value = csvread('intensitydata.txt');
value = value(:, 2:22);
value = reshape(value.',[],1);
value = value';
h=7;

[a,b]= meshgrid(C, gamma);
xC = a(:);
xC = xC';

yGamma = b(:);
yGamma = yGamma';

r = h*tand(yGamma);

xReal = r.*sind(xC);
yReal = r.*cosd(xC);

% interpolation
F=scatteredInterpolant(xReal',yReal',value', 'natural');

% get any value
% v = F(x, y)
% v=F(-0.453,-0.183)
end
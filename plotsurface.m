x=linspace(-1,1,20)
y=linspace(-1,1,20)
[xx, yy] = meshgrid(x,y);
zz = (sin(sqrt(yy.^2+xx.^2)) + cos(xx)+ 2*sin(yy)).^2;
figure;
surf(xx,yy,zz);
function h = filledCircle(center,r,N,color)
%---------------------------------------------------------------------------------------------
% FILLEDCIRCLE Filled circle drawing
% 
% filledCircle(CENTER,R,N,COLOR) draws a circle filled with COLOR that 
% has CENTER as its center and R as its radius, by using N points on the 
% periphery.
%
% Usage Examples,
%
% filledCircle([1,3],3,1000,'b'); 
% filledCircle([2,4],2,1000,'r');
%
% Sadik Hava <sadik.hava@gmail.com>
% May, 2010
%
% Inspired by: circle.m [Author: Zhenhai Wang]
%---------------------------------------------------------------------------------------------
for i=1:size(center,1)
    THETA=linspace(0,2*pi,N(i));
    RHO=ones(1,N(i))*r(i);
    [X,Y] = pol2cart(THETA,RHO);
    X=X+center(i,1);
    Y=Y+center(i,2);
    h=fill(X,Y,color);
    hold on;
    axis square;
end
end
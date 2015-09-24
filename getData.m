function F = getData(sourceName)
global xx yy zz 
switch sourceName
    case 'singleLuna'
        h = 15;
        I = 5; % luminous intensity of isotropic source
        SS = h*I;
        x = [-50:.1:50];
        y = x;
        [xx,yy] = meshgrid(x,y);
        zz = SS./(sqrt((xx-20).^2+(yy+20).^2+h^2)).^3; % flux
        F = 0; % don't need interpolant
    case 'RealLuna1'
        C = 0:2.5:357.5; % C angle
        gamma = 0:2.5:80; % gamma angle
        h = 12.5;
        load('data.mat');
        v1 = b(1:33,:);
        v2 = flipdim(v1,2);
        v3 = [v1,v2(:,2:72)];
        v = v3;
        [a,b]= meshgrid(C,gamma);
        
        xC = a(:);
        xC = xC';
        
        yGamma = b(:);
        yGamma = yGamma';
        
        r = h*tand(yGamma);
        
        yReal = r.*sind(xC);
        xReal = r.*cosd(xC);
        
        value = v(:);
        value = (value').*cosd(yGamma);
        
        d = -50:0.1:50;
        [xq,yq] = meshgrid(d,d);
        vq = griddata(xReal,yReal,value,xq,yq,'natural');
        xx = xq; yy = yq; zz = vq;
        F=scatteredInterpolant(xReal',yReal',value', 'natural');
%       save('Real_Luna_Data.mat', 'F');
        % get any value
        % v = F(x, y)
        % v=F(-0.453,-0.183)
    case 'RealLuna2'
        load 875_17M_56_FG.mat
        [gGamma,cC] = meshgrid(gamma,C);
        arrayC = cC(:)';
        arrayGamma = gGamma(:)';
        intensity = intensity';
        arrayIntensity = intensity(:)';

        numPoint = size(arrayIntensity,2);
        xReal = zeros(size(arrayIntensity));
        yReal = xReal;
        cosine = xReal;

        r = 50;

        for i = 1: numPoint
            [xReal(i),yReal(i)] = map(r,arrayGamma(i),arrayC(i));
            cosine(i) = typeBCosine(r,arrayGamma(i),arrayC(i));
        end

        value = arrayIntensity.*cosine;

        d = -50:0.1:50;
        [xx,yy] = meshgrid(d,d);

        zz = griddata(xReal,yReal,value,xx,yy,'natural');
     
        F = scatteredInterpolant(xReal',yReal', value');
     otherwise
end
end
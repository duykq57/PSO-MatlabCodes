function veloOutput = APF(swarm, staticObs, index, iteration)
radius = PSOConstants.RADIUS;
rSeparation =6*radius;
r2 = 11*radius;
r3 = 16*radius;
G = 30;
vSeparation = [0 0];
vAttraction = [0 0];
% update vSeperation
% avoid collisions

   for i = 1:PSOConstants.SWARM_SIZE
       if i ~= index
            % r12 = distance between 2 particle
            r12 = distance(swarm(index).Location, swarm(i).Location);
            if r12<rSeparation
                magnitude = 10*G/r12^2;
                connect = swarm(index).Location - swarm(i).Location;
                vX = magnitude/r12*connect(1);
                vY = magnitude/r12*connect(2);
                vSeparation = vSeparation + [vX, vY];
%                 if r12<2*PSOConstants.RADIUS + 2*ProblemSet.VEL_HIGH
%                     vSeparation = vSeparation * 10;
%                 end
                
            end
       end
   end
% avoid staticObjs
   for j = 1:PSOConstants.NUM_OF_STATIC_OBJS
       r12 = distance(swarm(index).Location, staticObs(j).cordinate);
       if r12 < rSeparation + staticObs(j).RADIUS
           magnitude = 30*G/r12^2;
           connect = swarm(index).Location - staticObs(j).cordinate;
           vX = magnitude/r12*connect(1);
           vY = magnitude/r12*connect(2);
           vSeparation = vSeparation + [vX, vY];
%            if r12<2*ProblemSet.VEL_HIGH + PSOConstants.RADIUS + staticObs(j).RADIUS
%                vSeparation = vSeparation *10;
%            end
%            vSeparation = 10*vSeparation/iteration;
       end
   end
% update vAttraction
    for i = 1:PSOConstants.SWARM_SIZE
       if i ~= index
            % r12 = distance between 2 particle
            r12 = distance(swarm(index).Location, swarm(i).Location);
            if r12 > r2 && r12 < r3
                magnitude = G*PSOConstants.C2/(r12-r3)^2;
                connect = swarm(index).Location - swarm(i).Location;
                vX = -magnitude/r12*connect(1);
                vY = -magnitude/r12*connect(2);
                vSeparation = vSeparation + [vX, vY];
            end
          
        end
    end
    
    veloOutput = vSeparation + vAttraction;
    
%     veloOutput = [0,0];
end
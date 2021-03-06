% ------------------------------initialize-----------------------------%
function resultTest = PSOProcess()
PRBLEM_NAME = 'RealLuna2'
F = getData(PRBLEM_NAME);

% initialize static obstacles
obs(1) = StaticObs(35,-10);
% obs(2) = StaticObs(15, 27);
obs(2) = StaticObs(-24, -12);
obs(3) = StaticObs(1, 39);
obs(4) = StaticObs(-3, -25);
% obs(6) = StaticObs(25, -35);
% obs(7) = StaticObs(15, -25);
% obs(8) = StaticObs(-20, 20);
% obs(9) = StaticObs(40, 0);
% obs(10) = StaticObs(-40, -40);

% initialize swarm
index = 1;
while index <= PSOConstants.SWARM_SIZE
    swarm(index)= Particle;
    for j=1:PSOConstants.PROBLEM_DIMENSION
        swarm(index).Location(j) = ProblemSet.LOC_LOW + rand(1) * (ProblemSet.LOC_HIGH - ProblemSet.LOC_LOW);
        swarm(index).Velocity(j) = ProblemSet.VEL_LOW + rand(1) * (ProblemSet.VEL_HIGH - ProblemSet.VEL_LOW);
    end
    swarm(index).Fitness = ProblemSet.evaluate(PRBLEM_NAME,F,swarm(index).Location, PSOConstants.PROBLEM_DIMENSION);
   
    % save location to display
    saveLocationX(1,index) = swarm(index).Location(1);
    saveLocationY(1,index) = swarm(index).Location(2);
    
    temp = 0;
    % check overlap with obstacles
    for obsIndex = 1:PSOConstants.NUM_OF_STATIC_OBJS
        if distance(swarm(index).Location, obs(obsIndex).cordinate) <= (PSOConstants.RADIUS + StaticObs.RADIUS)
            disp('Initialize in obstacle location --> initialize againt');
            temp = 1;
            break;
        end
    end
    % check overlap with other particle
    for otherIndex = 1:index-1
        if distance(swarm(index).Location, swarm(otherIndex).Location) <= 2*PSOConstants.RADIUS
            disp('Initialize in other swarm location --> initialize againt');
            temp = 1;
            break;
        end
    end
    if temp == 0
        index = index + 1;
    end
end

% save fitnessList
for i=1:PSOConstants.SWARM_SIZE
    fitnessValueList(i) = swarm(i).Fitness();
end
% save pBest list and pBestLocation list
for i=1:PSOConstants.SWARM_SIZE
    pBest(i) = fitnessValueList(i);
    pBestLocation(i,:) = swarm(i).Location;
end

% ------------------------------iteration process-----------------------------%
t = 1; % step of iteration
count=0; % number of collision
BestFitnessEver(1) = 0; % gBestList to display

% iteration
while t<=PSOConstants.MAX_ITERATION  
    % step 1 - update pBest
    for i=1:PSOConstants.SWARM_SIZE
        if fitnessValueList(i) > pBest(i)
            pBest(i) = fitnessValueList(i);
            pBestLocation(i,:) = swarm(i).Location;
        end
    end
    
    % step 2 - update gBest
    bestParticleIndex = getMinPos(fitnessValueList, PSOConstants.SWARM_SIZE);
    if t==1 || fitnessValueList(bestParticleIndex) > gBest
        gBest = fitnessValueList(bestParticleIndex);
        gBestLocation = swarm(bestParticleIndex).Location;
    end
    
    for i=1:PSOConstants.SWARM_SIZE
        r1 = rand(1);
        r2 = rand(1);
        
        % step 3 - update velocity
        vAPF = APF(swarm,obs, i, t); 
%         vAPF = [0 0]
        for j=1:PSOConstants.PROBLEM_DIMENSION
            newVel(j) = PSOConstants.w(t)*swarm(i).Velocity(j)+ r1*PSOConstants.c1(t) * (pBestLocation(i,j) - swarm(i).Location(j))+r2*PSOConstants.c2(t) * (gBestLocation(j) - swarm(i).Location(j))+ 3*vAPF(j);
        end
        %check limit speed
        s = newVel(1)/newVel(2); % ratio of v components
        sign1 =  newVel(1)/abs(newVel(1));
        sign2 =  newVel(2)/abs(newVel(2));
        if (abs(newVel(1)) > ProblemSet.VEL_HIGH)
            newVel(1) = rand*ProblemSet.VEL_HIGH*sign1;
            newVel(2) = newVel(1)/s;
        end
        if (abs(newVel(2)) > ProblemSet.VEL_HIGH)
            newVel(2) = rand*ProblemSet.VEL_HIGH*sign2;
            newVel(1) = newVel(2)*s;
        end
        swarm(i).Velocity = newVel;
        
        % step 4 - update location
        for j=1:PSOConstants.PROBLEM_DIMENSION
            newLoc(j) = swarm(i).Location(j) + newVel(j);
            % check space limit
            if newLoc(j) > ProblemSet.LOC_HIGH
                newLoc(j) = ProblemSet.LOC_HIGH - rand*(ProblemSet.LOC_HIGH - swarm(i).Location(j));
            end
            if newLoc(j) < ProblemSet.LOC_LOW
                newLoc(j) = ProblemSet.LOC_LOW - rand*(ProblemSet.LOC_LOW - swarm(i).Location(j));
            end
        end
        
        % check collision 
        isCollision = 0;
        isCollisionObs = 0;
        x1 = swarm(i).Location(1);
        y1 = swarm(i).Location(2);
        x2 = newLoc(1);
        y2 = newLoc(2);
        center = [(x1+x2)/2 (y1+y2)/2];
        deltaX = abs(2*PSOConstants.RADIUS*abs(y2 - y1)...
                    /distance(newLoc, swarm(i).Location));
        deltaY = abs(2*PSOConstants.RADIUS*abs(x2 - x1)...
                    /distance(newLoc, swarm(i).Location));
                
        vertex1 = [center(1)+deltaX, center(2)+deltaY];
        vertex2 = [center(1)+deltaX+abs(x2-center(1)), center(2)-deltaY];
        vertex3 = [2*center(1)-vertex1(1), 2*center(2)-vertex1(2)];
        vertex4 = [2*center(1)-vertex2(1), 2*center(2)-vertex2(2)];
        
        bound1 = [vertex1(1) vertex2(1) vertex3(1) vertex4(1) vertex1(1)];
        bound2 = [vertex1(2) vertex2(2) vertex3(2) vertex4(2) vertex1(2)];
        for k=1:PSOConstants.SWARM_SIZE
            isCollision = 0;
            if k~= i
                in = inpolygon(swarm(k).Location(1), swarm(k).Location(2), bound1, bound2);
                if in~= 0
                    isCollision = 1;
                end
                d = distance(newLoc, swarm(k).Location);
                if d<2*PSOConstants.RADIUS
                    isCollision = 1;
                end
            end
            if isCollision == 1
                count = count + 1;
                disp('collision');
                disp(count);
            end
        end
        
        deltaX2 = abs((StaticObs.RADIUS+PSOConstants.RADIUS)*abs(y2 - y1)...
                    /distance(newLoc, swarm(i).Location));
        deltaY2 = abs((StaticObs.RADIUS+PSOConstants.RADIUS)*abs(x2 - x1)...
                    /distance(newLoc, swarm(i).Location));
        for k2=1:PSOConstants.NUM_OF_STATIC_OBJS
            isCollisionObs = 0;
            in = inpolygon(obs(k2).cordinate(1), obs(k2).cordinate(2), bound1, bound2);
            if in~= 0
               isCollisionObs = 1;
            end
            d = distance(newLoc, obs(k2).cordinate);
            if d<StaticObs.RADIUS+PSOConstants.RADIUS
               isCollisionObs = 1;
            end
            if isCollisionObs == 1
                count = count + 1;
                disp('collisionObs');
                disp(count);
            end
        end
        % update location
        swarm(i).Location = newLoc;

        % step 5 - update fitness
        swarm(i).Fitness = ProblemSet.evaluate(PRBLEM_NAME,F,swarm(i).Location, PSOConstants.PROBLEM_DIMENSION);
    end
    
    t = t+1;
    max_iter = t;
    % update fitnessList
    for i=1:PSOConstants.SWARM_SIZE
        fitnessValueList(i) = swarm(i).Fitness();
    end
     
    % check convergence
%     for i=1:PSOConstants.SWARM_SIZE
%         temp = 1;
%         for j=1:PSOConstants.SWARM_SIZE
%             if j~=i && distance(swarm(i).Location, swarm(j).Location) > 11*PSOConstants.RADIUS
%                 temp = 0;
%             end
%         end
%         if temp == 1
%             t = PSOConstants.MAX_ITERATION+1;
%             break;
%         end
%     end
    % check convergence
    % Adjacency Matrix
    A = zeros(PSOConstants.SWARM_SIZE, PSOConstants.SWARM_SIZE);
    for i1 = 1:PSOConstants.SWARM_SIZE
        for i2 = (i1+1):PSOConstants.SWARM_SIZE
            if distance(swarm(i1).Location, swarm(i2).Location) < PSOConstants.COMMUNICATION_RANGE*2
                A(i1,i2) = 1;
                A(i2,i1) = 1;
            end
        end
        A(i1,i1) = 0;
    end

    % Degree Matrix
    D = zeros(PSOConstants.SWARM_SIZE, PSOConstants.SWARM_SIZE);
    for i1 = 1:PSOConstants.SWARM_SIZE
        for i2 = 1:PSOConstants.SWARM_SIZE
            if distance(swarm(i1).Location, swarm(i2).Location) < PSOConstants.COMMUNICATION_RANGE*2 && i1 ~= i2
                D(i1,i1) = D(i1,i1)+1;
            end
        end
    end

    % Laplacian Matrix
    L = D - A;

    eigen = sort(eig(L));    
    lambda2(t) = eigen(2);
    if lambda2(t) < 10^-6
        lambda2(t) = 0; % because of its numerical method, matlab usually gives result at 10^-16, which is actually zero.
    end

    if lambda2(t) > 0
        mar_iter = t;
        t = PSOConstants.MAX_ITERATION+1;
    end
    
    % save location to display
    for i=1:PSOConstants.SWARM_SIZE
        saveLocationX(t+1,i) = swarm(i).Location(1);
        saveLocationY(t+1,i) = swarm(i).Location(2);
    end
    BestFitnessEver(t+1) = gBest;
end

% display result
disp('Num of collisions: ');
disp(count);
resultTest = max_iter;

% visualize(saveLocationX, saveLocationY, obs, BestFitnessEver, count, max_iter);
% m=linspace(1, max_iter, max_iter);
% figLambda = figure('Position', [100, 100, 1049, 895]);
% plot(m, lambda2,'LineWidth',2);
end
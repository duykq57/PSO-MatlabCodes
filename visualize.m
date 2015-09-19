function visualize(saveLocationX, saveLocationY, obs, BestFitnessEver, count, iteration)
WAIT = 0.05;
FigHandle = figure('Position', [100, 100, 1049, 895]);

for i=1:PSOConstants.NUM_OF_STATIC_OBJS
    obsX(i) = obs(i).cordinate(1);
    obsY(i) = obs(i).cordinate(2);
    obsRadiusMatrix(i) = obs(i).RADIUS;
end

for i=1:iteration
    clf;
    str = ['Step: ',num2str(i), '   Num of collisions: ', num2str(count),'\it \color[rgb]{0.2,0.5,0.5} Best Value = ', num2str(BestFitnessEver(i))];
    title(str,'FontSize',18);
    hold on;
    %scatter(saveLocationX(i,:), saveLocationY(i,:));
    plot(obsX, obsY,'.');
    viscircles([obsX; obsY]',obsRadiusMatrix,'EdgeColor','r','LineWidth',0.2);
    hold on
    plot(saveLocationX(i,:), saveLocationY(i,:),'.');
    comRangeMatrix = PSOConstants.COMMUNICATION_RANGE/3*ones(1,PSOConstants.SWARM_SIZE);
    radiusMatrix = PSOConstants.RADIUS*ones(1,PSOConstants.SWARM_SIZE);
    viscircles([saveLocationX(i,:); saveLocationY(i,:)]',comRangeMatrix,'EdgeColor','g','LineWidth',0.2);
    viscircles([saveLocationX(i,:); saveLocationY(i,:)]',radiusMatrix,'EdgeColor','r','LineWidth',0.2); 
    axis([-50 50 -50 50]);
    hold on;
    pause(WAIT);
end
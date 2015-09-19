function minPos = getMinPos(list,swarm_size)
pos=1;
minValue=list(1);
for i=1:swarm_size
    if list(i) > minValue
        pos = i;
        minValue = list(i);
    end
end
minPos = pos;
end
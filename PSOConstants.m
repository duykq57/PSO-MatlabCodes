classdef PSOConstants
    properties(Constant)
        SWARM_SIZE = 5;
        MAX_ITERATION = 200;
        PROBLEM_DIMENSION = 2;
        w = linspace(.5,.01,200);
        c1 = linspace(2,.1,200);
        c2 = linspace(0.1,2,200);
        C1 = 2.0;
        C2 = 2.0;
        W_UPPERBOUND = 1.0;
        W_LOWERBOUND = 0.0;
        RADIUS = 1;
        COMMUNICATION_RANGE = 5;
        NUM_OF_STATIC_OBJS = 4;
    end
end
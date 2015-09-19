classdef PSOConstants
    properties(Constant)
        SWARM_SIZE = 15;
        MAX_ITERATION = 300;
        PROBLEM_DIMENSION = 2;
        w = linspace(.5,.01,300);
        c1 = linspace(2,.1,300);
        c2 = linspace(0.1,2,300);
%         C1 = 2.0;
%         C2 = 2.0;
        W_UPPERBOUND = 1.0;
        W_LOWERBOUND = 0.0;
        RADIUS = 1;
        COMMUNICATION_RANGE = 15;
        NUM_OF_STATIC_OBJS = 5;
    end
end
classdef StaticObs
    properties
        cordinate;
    end
    properties(Constant)
        RADIUS = 5;
    end
    methods
        function obs = StaticObs(x, y)
            obs.cordinate(1) = x;
            obs.cordinate(2) = y;
        end
    end
end

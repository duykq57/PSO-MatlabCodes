classdef ProblemSet
    properties(Constant)
        ERR_TOLERANCE = 1E-20;
        LOC_LOW = -50;
        LOC_HIGH = 50;
        VEL_LOW = -1.5;
        VEL_HIGH = 1.5;
    end
    
    methods(Static)
        function result = evaluate(problem_name, F, location, dim)
            switch problem_name
                case 'Sphere'
                    result = 0;
                    for i=1:dim
                        result = result + location(i)*location(i);
                    end
                case 'Rosenbrock'
                    result = 0;
                    for i=1:(dim-1)
                        result = result + 100*(location(i+1)- location(i).^2).^2 + (location(i)-1).^2;
                    end
                case 'singleLuna'
                    h = 10;
                    I = 5; % luminous intensity of isotropic source
                    SS = h*I;
                    x = location(1);
                    y = location(2);
                    result = SS./(sqrt((x-20).^2+(y+20).^2+h^2)).^3; % flux
                case 'RealLuna1'
                    result = F(location(1), location(2));
                case 'RealLuna2'
                    result = F(location(1), location(2));
                otherwise
            end     
        end
    end
end
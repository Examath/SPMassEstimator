classdef Material
    % Material Class to represent material properties
    % This class defines a material with properties such as density,
    % yield stress, and thickness.

    properties
        Name
        Density      % Density of the material (kg/m^3)
        YieldStress  % Yield stress of the material (Pa)
        Thickness    % Thickness of the material (m)
    end

    methods
        function obj = Material(name, density, yieldStress, thickness)
            % New Construct an instance of the Material class
            % This constructor initializes the material properties with
            % the given density, yield stress, and thickness.
            %
            % Inputs:
            %   density - Density of the material (kg/m^3)
            %   yieldStress - Yield stress of the material (Pa)
            %   thickness - Thickness of the material (m)
            %
            % Outputs:
            %   obj - An instance of the Material class

            obj.Name = name;
            obj.Density = density;
            obj.YieldStress = yieldStress;
            obj.Thickness = thickness;
        end
    end

    methods (Static)
        function result = getMass(input, volume)
            if isa(input, 'Material')
                result = input.Density * volume;
            elseif isnumeric(input)
                result = input;
            else
                error('MAT-01 Input must be either a Material object or a numeric value.');
            end
        end

        function result = getName(input)
            if isa(input, 'Material')
                result = input.Name;
            elseif isnumeric(input)
                result = 'Other';
            else
                error('MAT-02 Input must be either a Material object or a numeric value.');
            end
        end
    end
end
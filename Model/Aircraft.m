classdef Aircraft < handle
    %AIRCRAFT Represents the mass model of an aircraft
    
    properties
        % Table containing all components
        Components

        % The category to add components to
        Category = ''
    end
    
    methods
        function obj = Aircraft()
            %AIRCRAFT Construct an instance of this class
            %   Detailed explanation goes here
            obj.Components = table('Size', [0, 7], ...
                'VariableTypes', {'string', 'string', 'string', 'double', 'double', 'double', 'string'}, ...
                'VariableNames', {'Category', 'Name', 'Material', 'm', 'x', 'I', 'Details'});
        end

        function setCategory(obj, category)
            obj.Category = category;
            fprintf("_______________________________\n%s\n", obj.Category);
        end

        function addComponent(obj, name, material, m, x, I, details)
            %ADDCOMPONENT Adds a new component to the Components table
            newRow = {obj.Category, name, Material.getName(material), m, x, I, details};
            obj.Components = [obj.Components; newRow];
            fprintf("  + %-18s %.3fkg, %+.3fm, %.3fkgm^2 | %s\n", name, m, x, I, details);
        end

        function addRect(obj, name, material, X, W, H)
            %ADDRECT Adds a new rectangular prizm to the components
            %table
            L = X(1);
            x = X(2);
            V = L*W*H;
            m = Material.getMass(material, V);
            I = (L^2 + H^2)*m/12;
            details = sprintf("rect (%.3f * %.3f * %.3f)m", L,W,H);
            obj.addComponent(name, material, m, x, I, details);
        end

        function addTube(obj, name, material, X, D, t)
            %ADDTUBE Adds a new tube to the components table
            L = X(1);
            x = X(2);
            % V = t * L * pi * D;
            V = t * L * pi * (D - t);
            m = Material.getMass(material, V);
            %I = (D^2/8 + L^2/12) * m;
            I = 1/12 * m * (3 * (D^2/2 - D * t + t^2) + L^2);
            details = sprintf("tube (L=%.3f, D=%.3f)m T=%.3fm", L, D, t);
            obj.addComponent(name, material, m, x, I, details);
        end

        function addCyln(obj, name, material, X, D)
            %ADDCYLN Adds a new cylinder to the components table
            L = X(1);
            x = X(2);
            V = L * pi * (D^2 / 4);
            m = Material.getMass(material, V);
            I = (D^2/16 + L^2/12) * m;
            details = sprintf("cyln (L=%.3f D=%.3f)m", L, D);
            obj.addComponent(name, material, m, x, I, details);
        end

        function addProfileH(obj, name, material, xmac, L, W, H, t)
            %ADDPROFILEH Adds a new horizontal profile component to the components table
            x = xmac - 0.25 * L;
            V = 2 * t * L * W * (1 + H/L);
            m = Material.getMass(material, V);
            I = (L^2/12 + H^2/4) * m;
            details = sprintf("prof (%.3f * %.3f * %.3f, T=%.3f)m", L, W, H, t);
            obj.addComponent(name, material, m, x, I, details);
        end       
        
        function o = calc(obj, category)
            %CALC Calculate the total mass, cofg, and inertia for components
            % in a specified category
            if isempty(category)
                % Include all components if category is empty
                selectedComponents = obj.Components;
            else
                % Filter components based on category
                idx = contains(obj.Components.Category, category);
                selectedComponents = obj.Components(idx, :);
            end
            
            if isempty(selectedComponents)
                o = [0, 0, 0];
                return;
            end
            
            m = sum(selectedComponents.m);
            x = sum(selectedComponents.m .* selectedComponents.x) / m;
            I = sum(selectedComponents.I) + sum(selectedComponents.m .* (selectedComponents.x .^ 2));
            o = [m, x, I];
            fprintf("%-22s %.3fkg, %+.3fm, %.3fkgm^2\n", category, m, x, I);
        end

        function total(obj)
            idx = contains(obj.Components.Category, obj.Category);
            selectedComponents = obj.Components(idx, :);
            if isempty(selectedComponents)
                return;
            end
            m = sum(selectedComponents.m);
            x = sum(selectedComponents.m .* selectedComponents.x) / m;
            I = sum(selectedComponents.I) + sum(selectedComponents.m .* (selectedComponents.x .^ 2));
            fprintf("  = TOTAL              %.3fkg, %+.3fm, %.3fkgm^2\n", m, x, I);
        end
    end
end


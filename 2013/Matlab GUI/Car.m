classdef Car < handle
    properties (Access = private)
        % Values are stored here
        params
    end
    properties (Access = public)
        % Application data
        appdata
        cardata
    end
    properties (Constant)
        
        % Servo param id's
        frontAxleLeftBrakeServosNeutralPositions = 10
        frontAxleRightBrakeServosNeutralPositions = 11
        rearAxleLeftBrakeServosNeutralPositions = 12
        rearAxleRightBrakeServosNeutralPositions = 13
        frontAxleLeftBrakeServosMaximumPositions = 14
        frontAxleRightBrakeServosMaximumPositions = 15
        rearAxleLeftBrakeServosMaximumPositions = 16
        rearAxleRightBrakeServosMaximumPositions = 17

        % ABS parameters
        absEnabled = 20
        absLowThres = 21
        absMiddleThres = 22
        absHighThres = 23
        finalPhaseLengthLift = 24
        finalPhaseLengthHolding = 25
        slopeFirstPhaseCalcBrake = 26
        thirdPhaseReleaseBrake = 27
        lastPhaseReleaseBrake = 28

        % New ABS parameters
        slipTolerance = 30
        enabled = 31
        cutOffSpeed = 32
        minAcc = 33
        maxAcc = 34
        muSplitThreshold = 35
        
        % ESP parameters
        espEnabled = 40
        espSensitivityControlAngVel = 41
        espSensitivityAdjSlipAngle = 42
        espBrakeForceFactor = 43
        espBrakeForceDist = 44
        espAngularVelContPCoeff = 45
        espAngularVelContDCoeff = 46
        espDriftAngleContrPCoeff = 47
        espDriftAngleContrDCoeff = 48
        espThresValAngularVelToSlipAngleContrl = 49

        % Vehicle params
        dynamicWheelRollRadius = 50
        wheelbase = 51
        vehicleMass = 52
        distanceFrontAxleCoG = 53
        distanceRearAxleCoG = 54
        frontAxleTurnStiffness = 55
        rearAxleTurnStiffness = 56
    end
    
    methods (Static = true)
        %% Setter and getter for Car instance
        function val = getInstance(appdatavalue)
            persistent current;
            if nargin >= 1
                current = appdatavalue;
            end
            if (isempty(current) || ~isvalid(current))
                current = Car;
            end
            val = current;
        end
    end
    
    methods
        % Constructor
        function this = Car()
            this.params = zeros(1, 60); % 60 can be increased
        end
        
        % Get Param
        function val = getParam(this, id)
            val = this.params(id);
        end
        
        % Set Param
        function setParam(this, id, val)
            if ischar(val)
                val = str2double(val);
            end
            this.params(id) = val;
        end
        
        % Save Car object to file
        function saveToFile(this, filename)
            if length(filename) > 11 && strcmp(filename(end-10:end), '_params.mat')
                filename = filename(1:end-11);
            elseif length(filename) > 12 && strcmp(filename(end-11:end), '_appdata.mat')
                filename = filename(1:end-12);
            elseif strcmp(filename(end-3:end), '.mat')
                filename = filename(1:end-4);
            end
            
            this.appdata
            params = this.params;
            appdata = this.appdata;
            save([ filename '_params.mat' ], 'params');
            save([ filename '_appdata.mat' ], 'appdata');
            clear appdata;
            clear params;
        end
        
        % Load Car object from file
        function loadFromFile(this, filename)
            if length(filename) > 11 && strcmp(filename(end-10:end), '_params.mat')
                filename = filename(1:end-11);
            elseif length(filename) > 12 && strcmp(filename(end-11:end), '_appdata.mat')
                filename = filename(1:end-12);
            end
            
            if exist([filename '_params.mat'], 'file')
                p = load([ filename '_params.mat' ], 'params');
                this.params = p.params;
                clear p;
                Logging.log('Params loaded');
            end

            if exist([filename '_appdata.mat'], 'file')
                p = load([ filename '_appdata.mat' ], 'appdata');
                this.appdata = p.appdata;
                clear p;
                Logging.log('Appdata loaded');
            end
        end

    end
end
    
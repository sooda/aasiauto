classdef Car < handle
    properties (Access = private)
        % Values are stored here
        params
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
            this.params(id) = val;
        end
        
        % Save Car object to file
        function saveToFile(this, filename)
            temp = this.params;
            save(filename, 'temp');
%            clear temp;
        end
        
        % Load Car object from file
        function loadFromFile(this, filename)
            load(filename, 'temp');
            this.params = temp;
%            clear temp;
        end

    end
end
    
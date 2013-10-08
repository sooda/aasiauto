classdef Car < handle
    properties
        % Vehicle parameters
        dynamicWheelRollRadius
        wheelbase
        vehicleMass
        distanceFrontAxleCoG
        distanceRearAxleCoG
        frontAxleTurnStiffness
        rearAxleTurnStiffness

        % Servo calibration
        frontAxleLeftBrakeServosNeutralPositions
        frontAxleRightBrakeServosNeutralPositions
        rearAxleLeftBrakeServosNeutralPositions
        rearAxleRightBrakeServosNeutralPositions
        frontAxleLeftBrakeServosMaximumPositions
        frontAxleRightBrakeServosMaximumPositions
        rearAxleLeftBrakeServosMaximumPositions
        rearAxleRightBrakeServosMaximumPositions

        % ABS parameters
        absEnabled
        absLowThres
        absMiddleThres
        absHighThres
        finalPhaseLengthLift
        finalPhaseLengthHolding
        slopeFirstPhaseCalcBrake
        thirdPhaseReleaseBrake
        lastPhaseReleaseBrake

        % ESP parameters
        espEnabled
        espSensitivityControlAngVel
        espSensitivityAdjSlipAngle
        espBrakeForceFactor
        espBrakeForceDist
        espAngularVelContPCoeff
        espAngularVelContDCoeff
        espDriftAngleContrPCoeff
        espDriftAngleContrDCoeff
        espThresValAngularVelToSlipAngleContrl

    end
    
    methods
        function this = saveToFile(this, filename)
            Logging.log('This must be implemented first!');
            % 'this' holds current Car object
        end
        
        function this = loadFromFile(this, filename)
            Logging.log('This must be implemented first!');
            % 'this' holds current Car object
        end

    end
end
    
classdef Protocol < value
    properties (Constant)

    end
    methods (Static = true)
       
        function setCarValue(car, id, value)
            % TODO: value processing here?
            if id < 20
               value = value; % join from two bytes
            elseif id == 20
               value = value; % no conversation
            elseif id > 20 && id < 30
               value = num2str(value);
            elseif id == 40
               value = value;
            elseif id > 40 && id <= 51
               value = num2str(value);
            elseif id > 51
               value = value; % join from two bytes
            end

            switch id
                case 10
                   car.frontAxleLeftBrakeServosNeutralPositions = value;
                case 11
                   car.frontAxleRightBrakeServosNeutralPositions = value;
                case 12
                   car.rearAxleLeftBrakeServosNeutralPositions = value;
                case 13
                   car.rearAxleRightBrakeServosNeutralPositions = value;
                case 14
                   car.frontAxleLeftBrakeServosMaximumPositions = value;
                case 15
                   car.frontAxleRightBrakeServosMaximumPositions = value;
                case 16
                   car.rearAxleLeftBrakeServosMaximumPositions = value;
                case 17
                   car.rearAxleRightBrakeServosMaximumPositions = value;

                case 20
                   car.absEnabled = value;
                case 21
                   car.absLowThres = value;
                case 22
                   car.absMiddleThres = value;
                case 23
                   car.absHighThres = value;
                case 24
                   car.finalPhaseLengthLift = value;
                case 25
                   car.finalPhaseLengthHolding = value;
                case 26
                   car.slopeFirstPhaseCalcBrake = value;
                case 27
                   car.thirdPhaseReleaseBrake = value;
                case 28
                   car.lastPhaseReleaseBrake = value;

                case 40
                   car.espEnabled = value;
                case 41
                   car.espSensitivityControlAngVel = value;
                case 42
                   car.espSensitivityAdjSlipAngle = value;
                case 43
                   car.espBrakeForceFactor = value;
                case 44
                   car.espBrakeForceDist = value;
                case 45
                   car.espAngularVelContPCoeff = value;
                case 46
                   car.espAngularVelContDCoeff = value;
                case 47
                   car.espDriftAngleContrPCoeff = value;
                case 48
                   car.espDriftAngleContrDCoeff = value;
                case 49
                   car.espThresValAngularVelToSlipAngleContrl = value;

                case 50
                   car.dynamicWheelRollRadius = value;
                case 51
                   car.wheelbase = value;
                case 52
                   car.vehicleMass = value;
                case 53
                   car.distanceFrontAxleCoG = value;
                case 54
                   car.distanceRearAxleCoG = value;
                case 55
                   car.frontAxleTurnStiffness = value;
                case 56
                   car.rearAxleTurnStiffness = value;

                otherwise
                   Logging.log('Invalid car property ID');
            end
        end
       
        function value = getCarValue(car, id)
            keySet = { 
                    10, 11, 12, 13, 14, 15, 16, 17, ...
                    20, 21, 22, 23, 24, 25, 26, 27, 28, ...
                    40, 41, 42, 43, 44, 45, 46, 47, 48, 49, ...
                    50, 51, 52, 53, 54, 55, 56
                };
            valueSet = {
                    car.frontAxleLeftBrakeServosNeutralPositions
                    car.frontAxleRightBrakeServosNeutralPositions
                    car.rearAxleLeftBrakeServosNeutralPositions
                    car.rearAxleRightBrakeServosNeutralPositions
                    car.frontAxleLeftBrakeServosMaximumPositions
                    car.frontAxleRightBrakeServosMaximumPositions
                    car.rearAxleLeftBrakeServosMaximumPositions
                    car.rearAxleRightBrakeServosMaximumPositions

                    car.absEnabled
                    car.absLowThres
                    car.absMiddleThres
                    car.absHighThres
                    car.finalPhaseLengthLift
                    car.finalPhaseLengthHolding
                    car.slopeFirstPhaseCalcBrake
                    car.thirdPhaseReleaseBrake
                    car.lastPhaseReleaseBrake

                    car.espEnabled
                    car.espSensitivityControlAngVel
                    car.espSensitivityAdjSlipAngle
                    car.espBrakeForceFactor
                    car.espBrakeForceDist
                    car.espAngularVelContPCoeff
                    car.espAngularVelContDCoeff
                    car.espDriftAngleContrPCoeff
                    car.espDriftAngleContrDCoeff
                    car.espThresValAngularVelToSlipAngleContrl

                    car.dynamicWheelRollRadius
                    car.wheelbase
                    car.vehicleMass
                    car.distanceFrontAxleCoG
                    car.distanceRearAxleCoG
                    car.frontAxleTurnStiffness
                    car.rearAxleTurnStiffness
                };
            
            mapObj = containers.Map(keySet, valueSet);
            value = mapObj(id);
            
            if id < 20
               value = value; % split to two bytes
            elseif id == 20
               value = value; % no conversation
            elseif id > 20 && id < 30
               value = str2int(value);
            elseif id == 40
               value = value;
            elseif id > 40 && id <= 51
               value = str2int(value);
            elseif id > 51
               value = value; % split to two bytes
            end
            
        end

   end
end
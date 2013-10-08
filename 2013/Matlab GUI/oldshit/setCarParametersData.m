%Set the parameter data to the car parameters editboxes
function setCarParametersData(handles,data)

%Set Vehicle parameters
set(handles.dynamicWheelRollRadiusEdit, 'String', data.dynamicWheelRollRadius);
set(handles.wheelbaseEdit, 'String',data.wheelbase);
set(handles.vehicleMassEdit, 'String', data.vehicleMass);
set(handles.distanceFrontAxleCoGEdit, 'String',data.distanceFrontAxleCoG);
set(handles.distanceRearAxleCoGEdit, 'String', data.distanceRearAxleCoG);
set(handles.frontAxleTurnStiffnessEdit, 'String', data.frontAxleTurnStiffness);
set(handles.rearAxleTurnStiffnessEdit, 'String', data.rearAxleTurnStiffness);

%Set servo calibration
set(handles.frontAxleLeftBrakeServosNeutralPositionsEdit, 'String', data.frontAxleLeftBrakeServosNeutralPositions);
set(handles.frontAxleRightBrakeServosNeutralPositionsEdit, 'String', data.frontAxleRightBrakeServosNeutralPositions);
set(handles.rearAxleLeftBrakeServosNeutralPositionsEdit, 'String', data.rearAxleLeftBrakeServosNeutralPositions);
set(handles.rearAxleRightBrakeServosNeutralPositionsEdit, 'String', data.rearAxleRightBrakeServosNeutralPositions);
set(handles.frontAxleLeftBrakeServosMaximumPositionsEdit, 'String', data.frontAxleLeftBrakeServosMaximumPositions);
set(handles.frontAxleRightBrakeServosMaximumPositionsEdit, 'String', data.frontAxleRightBrakeServosMaximumPositions);
set(handles.rearAxleLeftBrakeServosMaximumPositionsEdit, 'String', data.rearAxleLeftBrakeServosMaximumPositions);
set(handles.rearAxleRightBrakeServosMaximumPositionsEdit, 'String', data.rearAxleRightBrakeServosMaximumPositions);

%Set ABS Parameters
set(handles.absEnabledCheckBox,'Value',data.absEnabled);
set(handles.absLowThresEdit, 'String', data.absLowThres);
set(handles.absMiddleThresEdit, 'String', data.absMiddleThres);
set(handles.absHighThresEdit, 'String', data.absHighThres);
set(handles.finalPhaseLengthLiftEdit, 'String', data.finalPhaseLengthLift);
set(handles.finalPhaseLengthHoldingEdit, 'String', data.finalPhaseLengthHolding);
set(handles.slopeFirstPhaseCalcBrakeEdit, 'String', data.slopeFirstPhaseCalcBrake);
set(handles.thirdPhaseReleaseBrakeEdit, 'String', data.thirdPhaseReleaseBrake);
set(handles.lastPhaseReleaseBrakeEdit, 'String', data.lastPhaseReleaseBrake);

%Set ESP Parameters
set(handles.espEnabledCheckBox,'Value',data.espEnabled);
set(handles.espSensitivityControlAngVelEdit, 'String', data.espSensitivityControlAngVel);
set(handles.espSensitivityAdjSlipAngleEdit, 'String', data.espSensitivityAdjSlipAngle);
set(handles.espBrakeForceFactorEdit, 'String', data.espBrakeForceFactor);
set(handles.espBrakeForceDistEdit, 'String', data.espBrakeForceDist);
set(handles.espAngularVelContPCoeffEdit, 'String', data.espAngularVelContPCoeff);
set(handles.espAngularVelContDCoeffEdit, 'String', data.espAngularVelContDCoeff);
set(handles.espDriftAngleContrPCoeffEdit, 'String', data.espDriftAngleContrPCoeff);
set(handles.espDriftAngleContrDCoeffEdit, 'String', data.espDriftAngleContrDCoeff);
set(handles.espThresValAngularVelToSlipAngleContrlEdit, 'String', data.espThresValAngularVelToSlipAngleContrl);

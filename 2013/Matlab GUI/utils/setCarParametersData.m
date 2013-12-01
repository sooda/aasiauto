%Set the parameter data to the car parameters editboxes
function setCarParametersData(handles)

c = Car.getInstance;

%Set Vehicle parameters
set(handles.dynamicWheelRollRadiusEdit, 'String', c.getParam(Car.dynamicWheelRollRadius));
set(handles.wheelbaseEdit, 'String', c.getParam(Car.wheelbase));
set(handles.vehicleMassEdit, 'String', c.getParam(Car.vehicleMass));
set(handles.distanceFrontAxleCoGEdit, 'String', c.getParam(Car.distanceFrontAxleCoG));
set(handles.distanceRearAxleCoGEdit, 'String', c.getParam(Car.distanceRearAxleCoG));
set(handles.frontAxleTurnStiffnessEdit, 'String', c.getParam(Car.frontAxleTurnStiffness));
set(handles.rearAxleTurnStiffnessEdit, 'String', c.getParam(Car.rearAxleTurnStiffness));

%Set servo calibration
set(handles.frontAxleLeftBrakeServosNeutralPositionsEdit, 'String', c.getParam(Car.frontAxleLeftBrakeServosNeutralPositions));
set(handles.frontAxleRightBrakeServosNeutralPositionsEdit, 'String', c.getParam(Car.frontAxleRightBrakeServosNeutralPositions));
set(handles.rearAxleLeftBrakeServosNeutralPositionsEdit, 'String', c.getParam(Car.rearAxleLeftBrakeServosNeutralPositions));
set(handles.rearAxleRightBrakeServosNeutralPositionsEdit, 'String', c.getParam(Car.rearAxleRightBrakeServosNeutralPositions));
set(handles.frontAxleLeftBrakeServosMaximumPositionsEdit, 'String', c.getParam(Car.frontAxleLeftBrakeServosMaximumPositions));
set(handles.frontAxleRightBrakeServosMaximumPositionsEdit, 'String', c.getParam(Car.frontAxleRightBrakeServosMaximumPositions));
set(handles.rearAxleLeftBrakeServosMaximumPositionsEdit, 'String', c.getParam(Car.rearAxleLeftBrakeServosMaximumPositions));
set(handles.rearAxleRightBrakeServosMaximumPositionsEdit, 'String', c.getParam(Car.rearAxleRightBrakeServosMaximumPositions));

%Set ABS Parameters
set(handles.absEnabledCheckBox, 'Value', c.getParam(Car.enabled));
set(handles.slipToleranceEdit, 'String', num2str(c.getParam(Car.slipTolerance)));
set(handles.cutOffSpeedEdit, 'String', c.getParam(Car.cutOffSpeed));
set(handles.minAccEdit, 'String', c.getParam(Car.minAcc));
set(handles.maxAccEdit, 'String', c.getParam(Car.maxAcc));
set(handles.muSplitThresholdEdit, 'String', c.getParam(Car.muSplitThreshold));

%Set ESP Parameters
set(handles.espEnabledCheckBox, 'Value', c.getParam(Car.espEnabled));
set(handles.espSensitivityControlAngVelEdit, 'String', c.getParam(Car.espSensitivityControlAngVel));
set(handles.espSensitivityAdjSlipAngleEdit, 'String', c.getParam(Car.espSensitivityAdjSlipAngle));
set(handles.espBrakeForceFactorEdit, 'String', c.getParam(Car.espBrakeForceFactor));
set(handles.espBrakeForceDistEdit, 'String', c.getParam(Car.espBrakeForceDist));
set(handles.espAngularVelContPCoeffEdit, 'String', c.getParam(Car.espAngularVelContPCoeff));
set(handles.espAngularVelContDCoeffEdit, 'String', c.getParam(Car.espAngularVelContDCoeff));
set(handles.espDriftAngleContrPCoeffEdit, 'String', c.getParam(Car.espDriftAngleContrPCoeff));
set(handles.espDriftAngleContrDCoeffEdit, 'String', c.getParam(Car.espDriftAngleContrDCoeff));
set(handles.espThresValAngularVelToSlipAngleContrlEdit, 'String', c.getParam(Car.espThresValAngularVelToSlipAngleContrl));

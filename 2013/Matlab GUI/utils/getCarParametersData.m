function data = getCarParametersData(handles)

c = Car.getInstance;

%Get Vehicle parameters
c.setParam(Car.dynamicWheelRollRadius, get(handles.dynamicWheelRollRadiusEdit, 'String'));

c.setParam(Car.dynamicWheelRollRadius, get(handles.dynamicWheelRollRadiusEdit, 'String'));
c.setParam(Car.wheelbase, get(handles.wheelbaseEdit, 'String'));
c.setParam(Car.vehicleMass, get(handles.vehicleMassEdit, 'String'));
c.setParam(Car.distanceFrontAxleCoG, get(handles.distanceFrontAxleCoGEdit, 'String'));
c.setParam(Car.distanceRearAxleCoG, get(handles.distanceRearAxleCoGEdit, 'String'));
c.setParam(Car.frontAxleTurnStiffness, get(handles.frontAxleTurnStiffnessEdit, 'String'));
c.setParam(Car.rearAxleTurnStiffness, get(handles.rearAxleTurnStiffnessEdit, 'String'));

%Get servo calibration
c.setParam(Car.frontAxleLeftBrakeServosNeutralPositions, get(handles.frontAxleLeftBrakeServosNeutralPositionsEdit, 'String'));
c.setParam(Car.frontAxleRightBrakeServosNeutralPositions, get(handles.frontAxleRightBrakeServosNeutralPositionsEdit, 'String'));
c.setParam(Car.rearAxleLeftBrakeServosNeutralPositions, get(handles.rearAxleLeftBrakeServosNeutralPositionsEdit, 'String'));
c.setParam(Car.rearAxleRightBrakeServosNeutralPositions, get(handles.rearAxleRightBrakeServosNeutralPositionsEdit, 'String'));
c.setParam(Car.frontAxleLeftBrakeServosMaximumPositions, get(handles.frontAxleLeftBrakeServosMaximumPositionsEdit, 'String'));
c.setParam(Car.frontAxleRightBrakeServosMaximumPositions, get(handles.frontAxleRightBrakeServosMaximumPositionsEdit, 'String'));
c.setParam(Car.rearAxleLeftBrakeServosMaximumPositions, get(handles.rearAxleLeftBrakeServosMaximumPositionsEdit, 'String'));
c.setParam(Car.rearAxleRightBrakeServosMaximumPositions, get(handles.rearAxleRightBrakeServosMaximumPositionsEdit, 'String'));

%Get ABS Parameters
c.setParam(Car.enabled, get(handles.absEnabledCheckBox,'Value'));
c.setParam(Car.slipTolerance, get(handles.slipToleranceEdit, 'String'));
c.setParam(Car.cutOffSpeed, get(handles.cutOffSpeedEdit, 'String'));
c.setParam(Car.minAcc, get(handles.minAccEdit, 'String'));
c.setParam(Car.maxAcc, get(handles.maxAccEdit, 'String'));
c.setParam(Car.muSplitThreshold, get(handles.muSplitThresholdEdit, 'String'));

%Get ESP Parameters
c.setParam(Car.espEnabled, get(handles.espEnabledCheckBox,'Value'));
c.setParam(Car.espSensitivityControlAngVel, get(handles.espSensitivityControlAngVelEdit, 'String'));
c.setParam(Car.espSensitivityAdjSlipAngle, get(handles.espSensitivityAdjSlipAngleEdit, 'String'));
c.setParam(Car.espBrakeForceFactor, get(handles.espBrakeForceFactorEdit, 'String'));
c.setParam(Car.espBrakeForceDist, get(handles.espBrakeForceDistEdit, 'String'));
c.setParam(Car.espAngularVelContPCoeff, get(handles.espAngularVelContPCoeffEdit, 'String'));
c.setParam(Car.espAngularVelContDCoeff, get(handles.espAngularVelContDCoeffEdit, 'String'));
c.setParam(Car.espDriftAngleContrPCoeff, get(handles.espDriftAngleContrPCoeffEdit, 'String'));
c.setParam(Car.espDriftAngleContrDCoeff, get(handles.espDriftAngleContrDCoeffEdit, 'String'));
c.setParam(Car.espThresValAngularVelToSlipAngleContrl, get(handles.espThresValAngularVelToSlipAngleContrlEdit, 'String'));

data = c.cardata;
%Read and return the data from the car paramterers edit boxes
function data = getCarParametersData(handles)

%Get Vehicle parameters
data.dynamicWheelRollRadius = get(handles.dynamicWheelRollRadiusEdit, 'String');
data.wheelbase = get(handles.wheelbaseEdit, 'String');
data.vehicleMass = get(handles.vehicleMassEdit, 'String');
data.distanceFrontAxleCoG = get(handles.distanceFrontAxleCoGEdit, 'String');
data.distanceRearAxleCoG = get(handles.distanceRearAxleCoGEdit, 'String');
data.frontAxleTurnStiffness = get(handles.frontAxleTurnStiffnessEdit, 'String');
data.rearAxleTurnStiffness = get(handles.rearAxleTurnStiffnessEdit, 'String');

%Get servo calibration
data.frontAxleLeftBrakeServosNeutralPositions = get(handles.frontAxleLeftBrakeServosNeutralPositionsEdit, 'String');
data.frontAxleRightBrakeServosNeutralPositions = get(handles.frontAxleRightBrakeServosNeutralPositionsEdit, 'String');
data.rearAxleLeftBrakeServosNeutralPositions = get(handles.rearAxleLeftBrakeServosNeutralPositionsEdit, 'String');
data.rearAxleRightBrakeServosNeutralPositions = get(handles.rearAxleRightBrakeServosNeutralPositionsEdit, 'String');
data.frontAxleLeftBrakeServosMaximumPositions = get(handles.frontAxleLeftBrakeServosMaximumPositionsEdit, 'String');
data.frontAxleRightBrakeServosMaximumPositions = get(handles.frontAxleRightBrakeServosMaximumPositionsEdit, 'String');
data.rearAxleLeftBrakeServosMaximumPositions = get(handles.rearAxleLeftBrakeServosMaximumPositionsEdit, 'String');
data.rearAxleRightBrakeServosMaximumPositions = get(handles.rearAxleRightBrakeServosMaximumPositionsEdit, 'String');

%Get ABS Parameters
data.absEnabled = get(handles.absEnabledCheckBox,'Value');
data.absLowThres = get(handles.absLowThresEdit, 'String');
data.absMiddleThres = get(handles.absMiddleThresEdit, 'String');
data.absHighThres = get(handles.absHighThresEdit, 'String');
data.finalPhaseLengthLift = get(handles.finalPhaseLengthLiftEdit, 'String');
data.finalPhaseLengthHolding = get(handles.finalPhaseLengthHoldingEdit, 'String');
data.slopeFirstPhaseCalcBrake = get(handles.slopeFirstPhaseCalcBrakeEdit, 'String');
data.thirdPhaseReleaseBrake = get(handles.thirdPhaseReleaseBrakeEdit, 'String');
data.lastPhaseReleaseBrake = get(handles.lastPhaseReleaseBrakeEdit, 'String');

%Get ESP Parameters
data.espEnabled = get(handles.espEnabledCheckBox,'Value');
data.espSensitivityControlAngVel = get(handles.espSensitivityControlAngVelEdit, 'String');
data.espSensitivityAdjSlipAngle = get(handles.espSensitivityAdjSlipAngleEdit, 'String');
data.espBrakeForceFactor = get(handles.espBrakeForceFactorEdit, 'String');
data.espBrakeForceDist = get(handles.espBrakeForceDistEdit, 'String');
data.espAngularVelContPCoeff = get(handles.espAngularVelContPCoeffEdit, 'String');
data.espAngularVelContDCoeff = get(handles.espAngularVelContDCoeffEdit, 'String');
data.espDriftAngleContrPCoeff = get(handles.espDriftAngleContrPCoeffEdit, 'String');
data.espDriftAngleContrDCoeff = get(handles.espDriftAngleContrDCoeffEdit, 'String');
data.espThresValAngularVelToSlipAngleContrl = get(handles.espThresValAngularVelToSlipAngleContrlEdit, 'String');

function setCarConfs(hObject, eventdata, handles)
    data = getCarParametersData(handles);
    appdata = getappdata(handles.figure1, 'App_Data');

    %Write brake controller parameters to car
    [hi, lo] = ByteTools.calcHighLowByte_From_Value(data.frontAxleLeftBrakeServosNeutralPositions);
    fcustomwrite(appdata.serial,hi,lo,10);

    [hi, lo] = ByteTools.calcHighLowByte_From_Value(data.frontAxleRightBrakeServosNeutralPositions);
    fcustomwrite(appdata.serial,hi,lo,11);

    [hi, lo] = ByteTools.calcHighLowByte_From_Value(data.rearAxleLeftBrakeServosNeutralPositions);
    fcustomwrite(appdata.serial,hi,lo,12);

    [hi, lo] = ByteTools.calcHighLowByte_From_Value(data.rearAxleRightBrakeServosNeutralPositions);
    fcustomwrite(appdata.serial,hi,lo,13);

    [hi, lo] = ByteTools.calcHighLowByte_From_Value(data.frontAxleLeftBrakeServosMaximumPositions);
    fcustomwrite(appdata.serial,hi,lo,14);

    [hi, lo] = ByteTools.calcHighLowByte_From_Value(data.frontAxleRightBrakeServosMaximumPositions);
    fcustomwrite(appdata.serial,hi,lo,15);

    [hi, lo] = ByteTools.calcHighLowByte_From_Value(data.rearAxleLeftBrakeServosMaximumPositions);
    fcustomwrite(appdata.serial,hi,lo,16);

    [hi, lo] = ByteTools.calcHighLowByte_From_Value(data.rearAxleRightBrakeServosMaximumPositions);
    fcustomwrite(appdata.serial,hi,lo,17);

    %Write ABS Parameters to car
    fcustomwrite(appdata.serial,data.absEnabled,'',20);
    fcustomwrite(appdata.serial,str2double(data.absLowThres),'',21);
    fcustomwrite(appdata.serial,str2double(data.absMiddleThres),'',22);
    fcustomwrite(appdata.serial,str2double(data.absHighThres),'',23);
    fcustomwrite(appdata.serial,str2double(data.finalPhaseLengthLift),'',24);
    fcustomwrite(appdata.serial,str2double(data.finalPhaseLengthHolding),'',25);
    fcustomwrite(appdata.serial,str2double(data.slopeFirstPhaseCalcBrake),'',26);
    fcustomwrite(appdata.serial,str2double(data.thirdPhaseReleaseBrake),'',27);
    fcustomwrite(appdata.serial,str2double(data.lastPhaseReleaseBrake),'',28);

    %Write ESP Parameters to car
    fcustomwrite(appdata.serial,data.espEnabled,'',40);
    fcustomwrite(appdata.serial,str2double(data.espSensitivityControlAngVel),'',41);
    fcustomwrite(appdata.serial,str2double(data.espSensitivityAdjSlipAngle),'',42);
    fcustomwrite(appdata.serial,str2double(data.espBrakeForceFactor),'',43);
    fcustomwrite(appdata.serial,str2double(data.espBrakeForceDist),'',44);
    fcustomwrite(appdata.serial,str2double(data.espAngularVelContPCoeff),'',45);
    fcustomwrite(appdata.serial,str2double(data.espAngularVelContDCoeff),'',46);
    fcustomwrite(appdata.serial,str2double(data.espDriftAngleContrPCoeff),'',47);
    fcustomwrite(appdata.serial,str2double(data.espDriftAngleContrDCoeff),'',48);
    fcustomwrite(appdata.serial,str2double(data.espThresValAngularVelToSlipAngleContrl),'',49);

    %Write Vehicle Parameters to car
    fcustomwrite(appdata.serial,str2double(data.dynamicWheelRollRadius),'',50);
    [hi, lo] = ByteTools.calcHighLowByte_From_Value(data.wheelbase); %scaled mm to range [0 65535]
    fcustomwrite(appdata.serial,hi,lo,51);
    [hi, lo] = ByteTools.calcHighLowByte_From_Value(data.vehicleMass, 1000); %scaled kg to range [0 65535]
    fcustomwrite(appdata.serial,hi,lo,52);
    [hi, lo] = ByteTools.calcHighLowByte_From_Value(data.distanceFrontAxleCoG);
    fcustomwrite(appdata.serial,hi,lo,53);
    [hi, lo] = ByteTools.calcHighLowByte_From_Value(data.distanceRearAxleCoG);
    fcustomwrite(appdata.serial,hi,lo,54);
    [hi, lo] = ByteTools.calcHighLowByte_From_Value(data.frontAxleTurnStiffness);
    fcustomwrite(appdata.serial,hi,lo,55);
    [hi, lo] = ByteTools.calcHighLowByte_From_Value(data.rearAxleTurnStiffness);
    fcustomwrite(appdata.serial,hi,lo,56);
    Logging.log('GUI Car data parameters uploaded to car.');

end
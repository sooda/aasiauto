function controller(block)
%MSFUNTMPL_BASIC A template for a Leve-2 M-file S-function
%   The M-file S-function is written as a MATLAB function with the
%   same name as the S-function. Replace 'msfuntmpl_basic' with the 
%   name of your S-function.
%
%   It should be noted that the M-file S-function is very similar
%   to Level-2 C-Mex S-functions. You should be able to get more
%   information for each of the block methods by referring to the
%   documentation for C-Mex S-functions.
%
%   Copyright 2003-2009 The MathWorks, Inc.
%%
%% The setup method is used to setup the basic attributes of the
%% S-function such as ports, parameters, etc. Do not add any other
%% calls to the main body of the function.
%%
setup(block);

%endfunction

%% Function: setup ===================================================
%% Abstract:
%%   Set up the S-function block's basic characteristics such as:
%%   - Input ports
%%   - Output ports
%%   - Dialog parameters
%%   - Options
%%
%%   Required         : Yes
%%   C-Mex counterpart: mdlInitializeSizes
%%
function setup(block)

% Register number of ports
block.NumInputPorts  = 1;
block.NumOutputPorts = 1;

% Setup port properties to be inherited or dynamic
block.SetPreCompInpPortInfoToDynamic;
block.SetPreCompOutPortInfoToDynamic;

% Override input port properties
block.InputPort(1).Dimensions        = 3;
block.InputPort(1).DatatypeID  = 0;  % double
block.InputPort(1).Complexity  = 'Real';
block.InputPort(1).DirectFeedthrough = true;

% Override output port properties
block.OutputPort(1).Dimensions       = 3;
block.OutputPort(1).DatatypeID  = 0; % double
block.OutputPort(1).Complexity  = 'Real';

% Register parameters
block.NumDialogPrms     = 0;

% Register sample times
%  [0 offset]            : Continuous sample time
%  [positive_num offset] : Discrete sample time
%
%  [-1, 0]               : Inherited sample time
%  [-2, 0]               : Variable sample time
block.SampleTimes = [-1 0];

% Specify the block simStateCompliance. The allowed values are:
%    'UnknownSimState', < The default setting; warn and assume DefaultSimState
%    'DefaultSimState', < Same sim state as a built-in block
%    'HasNoSimState',   < No sim state
%    'CustomSimState',  < Has GetSimState and SetSimState methods
%    'DisallowSimState' < Error out when saving or restoring the model sim state
block.SimStateCompliance = 'DefaultSimState';

%% -----------------------------------------------------------------
%% The M-file S-function uses an internal registry for all
%% block methods. You should register all relevant methods
%% (optional and required) as illustrated below. You may choose
%% any suitable name for the methods and implement these methods
%% as local functions within the same file. See comments
%% provided for each function for more information.
%% -----------------------------------------------------------------

block.RegBlockMethod('PostPropagationSetup',    @DoPostPropSetup);
block.RegBlockMethod('InitializeConditions', @InitializeConditions);
block.RegBlockMethod('Start', @Start);
block.RegBlockMethod('Outputs', @Outputs);     % Required
block.RegBlockMethod('Update', @Update);
block.RegBlockMethod('Derivatives', @Derivatives);
block.RegBlockMethod('Terminate', @Terminate); % Required

%end setup

%%
%% PostPropagationSetup:
%%   Functionality    : Setup work areas and state variables. Can
%%                      also register run-time methods here
%%   Required         : No
%%   C-Mex counterpart: mdlSetWorkWidths
%%
function DoPostPropSetup(block)
block.NumDworks = 2;
  
  block.Dwork(1).Name            = 'x1';
  block.Dwork(1).Dimensions      = 4;
  block.Dwork(1).DatatypeID      = 0;      % double
  block.Dwork(1).Complexity      = 'Real'; % real
  block.Dwork(1).UsedAsDiscState = true;
  
  block.Dwork(2).Name            = 'phase';
  block.Dwork(2).Dimensions      = 1;
  block.Dwork(2).DatatypeID      = 4;      % double
  block.Dwork(2).Complexity      = 'Real'; % real
  block.Dwork(2).UsedAsDiscState = true;


%%
%% InitializeConditions:
%%   Functionality    : Called at the start of simulation and if it is 
%%                      present in an enabled subsystem configured to reset 
%%                      states, it will be called when the enabled subsystem
%%                      restarts execution to reset the states.
%%   Required         : No
%%   C-MEX counterpart: mdlInitializeConditions
%%
function InitializeConditions(block)

%end InitializeConditions


%%
%% Start:
%%   Functionality    : Called once at start of model execution. If you
%%                      have states that should be initialized once, this 
%%                      is the place to do it.
%%   Required         : No
%%   C-MEX counterpart: mdlStart
%%
function Start(block)

block.Dwork(1).Data = [0;0;0;0];
block.Dwork(2).Data = int16(0);

%endfunction

%%
%% Outputs:
%%   Functionality    : Called to generate block outputs in
%%                      simulation step
%%   Required         : Yes
%%   C-MEX counterpart: mdlOutputs
%%
function Outputs(block)

%block.OutputPort(1).Data = block.Dwork(1).Data + block.InputPort(1).Data;
brakePwr = 0.0;
w = block.InputPort(1).Data(1);
time = block.InputPort(1).Data(3) - block.Dwork(1).Data(1);
loopPhase = block.Dwork(2).Data;
dataPos4 = block.Dwork(1).Data(4);

 if w < -5 && loopPhase == 0
     if loopPhase == -1
          brakePwr = block.Dwork(1).Data(2);
     else
        brakePwr = block.InputPort(1).Data(2);
        block.Dwork(1).Data(2) = block.InputPort(1).Data(2); % MAX Brake power
     end
     block.Dwork(1).Data(1) = block.InputPort(1).Data(3); % Reset time
     block.Dwork(2).Data = int16(1);
%  elseif loopPhase == 1
%      brakePwr = block.Dwork(1).Data(2);
%      if time > 0.3 % Go to next phase
%         block.Dwork(2).Data = int16(2);
%         block.Dwork(1).Data(1) = block.InputPort(1).Data(3); % Reset time
%      end
 elseif loopPhase == 1
     brakePwr = block.Dwork(1).Data(2) - (time * 200);
     if w > -4 % Go to next phase
        block.Dwork(1).Data(4) = brakePwr;
        block.Dwork(2).Data = int16(2);
        block.Dwork(1).Data(1) = block.InputPort(1).Data(3); % Reset time
     end
 elseif loopPhase == 2
     brakePwr = block.Dwork(1).Data(4);
     if w > 4
        block.Dwork(2).Data = int16(3);
        block.Dwork(1).Data(4) = brakePwr;
        block.Dwork(1).Data(1) = block.InputPort(1).Data(3); % Reset time
     end
 elseif loopPhase == 3
     brakePwr = block.Dwork(1).Data(4) + (time * 100);
     if w < 3
         block.Dwork(1).Data(4) = brakePwr;
         block.Dwork(2).Data = int16(4);
     end
 elseif loopPhase == 4
     brakePwr = block.Dwork(1).Data(4);
     if w < 0
         block.Dwork(1).Data(2) = brakePwr;
         block.Dwork(2).Data = int16(5);
         block.Dwork(1).Data(1) = block.InputPort(1).Data(3); % Reset time
     end
 elseif loopPhase == 5
     brakePwr = block.Dwork(1).Data(4) + (time * 50);
     if w < -5 && time > 0.5
         block.Dwork(1).Data(2) = brakePwr;
         block.Dwork(2).Data = int16(1);
         block.Dwork(1).Data(1) = block.InputPort(1).Data(3); % Reset time
     end
 elseif loopPhase == 0
     brakePwr = block.InputPort(1).Data(2);
     %if loopPhase ~= -1
     %   block.Dwork(2).Data = int16(0);
     %end
 end

block.OutputPort(1).Data(1) = brakePwr;
block.OutputPort(1).Data(2) = loopPhase;
block.OutputPort(1).Data(3) = block.Dwork(2).Data;
%end Outputs

%%
%% Update:
%%   Functionality    : Called to update discrete states
%%                      during simulation step
%%   Required         : No
%%   C-MEX counterpart: mdlUpdate
%%
function Update(block)

%block.Dwork(1).Data = block.InputPort(1).Data;

%end Update

%%
%% Derivatives:
%%   Functionality    : Called to update derivatives of
%%                      continuous states during simulation step
%%   Required         : No
%%   C-MEX counterpart: mdlDerivatives
%%
function Derivatives(block)

%end Derivatives

%%
%% Terminate:
%%   Functionality    : Called at the end of simulation for cleanup
%%   Required         : Yes
%%   C-MEX counterpart: mdlTerminate
%%
function Terminate(block)

%end Terminate


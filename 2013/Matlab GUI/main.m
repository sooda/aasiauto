% Startup function for the program
function main

    %% Close and clear all
    clc;
    clear;

    %% Add subfolders to path
    folders = [ 'utils' ; 'tests' ];

    for i = 1:size(folders,1)
        d = fullfile(pwd, folders(i,:), filesep);
        addpath(d);
    end

    %% Run the main program
    %RCCarGUI
    CommunicationTest()

end
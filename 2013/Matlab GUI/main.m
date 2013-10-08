% Startup function for the program
function main

    %% Close and clear all
    clc;
    clear;

    %% Add subfolders to path
    folders =  { 'utils' , 'oldshit' , 'tests' };

    for i = 1:size(folders, 2)
        d = fullfile(pwd, char(folders(i)), filesep);
        addpath(d);
    end

    %% Run the main program
    RCCarGUI
    %CommunicationTest()

end